# Emilio Dashboard

A compact 800x480 dashboard for Raspberry Pi touch display, showing:
- Weather
- Tasks
- Calendar
- Inbox summary
- System health and services
- Chess ratings

## Purpose

This dashboard is optimized for at-a-glance daily operation and monitoring from a 7" kiosk screen.

## Current Architecture

- Single-file frontend (`index.html`)
- Reads state from `/state/*.json`
- Auto-refreshes every 30 seconds

## Data Sources

- `/state/weather.json`
- `/state/todoist.json`
- `/state/calendar.json`
- `/state/gmail.json`
- `/state/services.json`
- `/state/lichess.json`
- `/state/meta.json`

## Reliability Features

- Feed health strip with degraded/stale indicators
- Per-card error state signaling
- Stale data detection using `meta.updated_at`
- Touch test mode for cracked-screen diagnostics

## Deployment

### Current Pi deploy behavior
- Nginx serves dashboard from `/var/lib/emilio/dashboard`
- `.github/workflows/deploy-pi.yml` can trigger an immediate deploy on every push to `main` when `PI_HOST`, `PI_USER`, and `PI_SSH_KEY` are configured
- `emilio-dashboard-deploy.timer` remains a fallback poller and will pick up `main` within about 5 minutes if the GitHub deploy workflow is unavailable
- The dashboard watches `/state/deploy.json` and automatically reloads when the deployed Git SHA changes, so the Pi kiosk screen and website stay on the same build
- State files are refreshed by `emilio-state-refresh.timer`

### GitHub Actions deploy on push
This repo includes `.github/workflows/deploy-pi.yml`.

On every push to `main`, it:
1. Validates `index.html`
2. SSHes into the Pi and starts `emilio-dashboard-deploy.service`
3. Confirms the dashboard and `/state/deploy.json` are reachable on localhost

Required repo secrets:
- `PI_HOST`
- `PI_USER`
- `PI_SSH_KEY`
- optional: `PI_PORT`

### Atomic release deploy helper
`scripts/deploy-emilio-dashboard.sh` provides atomic symlink-based releases (`/opt/emilio-dashboard/releases` + `/opt/emilio-dashboard/current`) and rollback-friendly layout.

Example:
```bash
sudo bash scripts/deploy-emilio-dashboard.sh origin/main
```

If nginx still points at `/var/lib/emilio/dashboard`, update its `root` to `/opt/emilio-dashboard/current` to fully enable atomic switchovers.

## Next Steps

See [PLANS.md](PLANS.md) for roadmap and release hardening plan.
