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

## Next Steps

See [PLANS.md](PLANS.md) for roadmap and release hardening plan.