# Cloudflare Setup: emilio.andrewlara.com

Expose the Emilio dashboard to the internet via Cloudflare Tunnel — no port forwarding, no exposed IP.

## Architecture

```
Browser → Cloudflare → cloudflared tunnel → Pi nginx (localhost:80)
```

Cloudflare Tunnel handles TLS, DDoS protection, and access control. nginx gets a normal HTTP request on localhost.

## Step 1: Install cloudflared on the Pi

```bash
ssh andrew@emilio
curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb -o /tmp/cloudflared.deb
sudo dpkg -i /tmp/cloudflared.deb
cloudflared --version
```

## Step 2: Authenticate cloudflared

```bash
cloudflared tunnel login
# Opens a browser — log in with your Cloudflare account
# Cert saved to ~/.cloudflared/cert.pem
```

## Step 3: Create the tunnel

```bash
cloudflared tunnel create emilio-dashboard
# Note the tunnel UUID shown — you'll need it
cloudflared tunnel list
```

## Step 4: Configure the tunnel

```bash
sudo mkdir -p /etc/cloudflared
sudo tee /etc/cloudflared/config.yml << 'EOF'
tunnel: <YOUR-TUNNEL-UUID>
credentials-file: /root/.cloudflared/<YOUR-TUNNEL-UUID>.json

ingress:
  - hostname: emilio.andrewlara.com
    service: http://localhost:80
  - service: http_status:404
EOF
```

Copy credentials file:
```bash
sudo cp ~/.cloudflared/<UUID>.json /root/.cloudflared/
```

## Step 5: DNS record (Cloudflare dashboard)

In Cloudflare DNS for andrewlara.com:
- Type: `CNAME`
- Name: `emilio`
- Target: `<YOUR-TUNNEL-UUID>.cfargotunnel.com`
- Proxy: ON (orange cloud)

Or via CLI:
```bash
cloudflared tunnel route dns emilio-dashboard emilio.andrewlara.com
```

## Step 6: Add password protection (Cloudflare Access)

In Cloudflare Zero Trust → Access → Applications:
1. Add an application
2. Type: Self-hosted
3. Domain: `emilio.andrewlara.com`
4. Policy: Allow → Emails → `your@email.com`
5. This adds a Cloudflare login gate — no nginx auth needed

Alternatively, nginx basic auth (simpler):
```bash
sudo apt install apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd andrew
# Enter password when prompted

sudo tee /etc/nginx/sites-available/emilio-dashboard << 'EOF'
server {
    listen 80;
    server_name emilio.andrewlara.com localhost;
    root /var/lib/emilio/dashboard;
    index index.html;

    # Uncomment for password protection (skip if using Cloudflare Access):
    # auth_basic "Emilio";
    # auth_basic_user_file /etc/nginx/.htpasswd;

    location /api/ {
        proxy_pass http://127.0.0.1:8766/;
        proxy_set_header Host $host;
    }

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

sudo nginx -t && sudo systemctl reload nginx
```

## Step 7: Run cloudflared as a service

```bash
sudo cloudflared service install
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
sudo systemctl status cloudflared
```

## Step 8: Test

Visit https://emilio.andrewlara.com — should load the dashboard.

## Interactive API (future)

The dashboard's interactive buttons POST to `/api/`. A small Python API server on port 8766 will proxy these to the tool wrappers. This is not yet implemented — buttons will show a "connecting..." state until the API service is deployed.

To add API support later:
- Deploy `emilio-api.service` (Python aiohttp server on :8766)
- nginx proxies `/api/` → `:8766`
- Dashboard JS `fetch('/api/todoist/add', ...)` calls work
