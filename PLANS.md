# PLANS.md — emilio-dashboard

## Goal
Ship a reliable, maintainable, release-ready dashboard for daily personal ops.

## Phase 1 — Stability (current)
- [x] Feed-level health visibility
- [x] Stale-data warnings
- [x] Touch test mode
- [ ] Add clearer empty/error copy for each widget

## Phase 2 — UX/Glanceability
- [ ] "Now / Next" event section with stronger visual hierarchy
- [ ] Priority-first tasks with optional compact mode
- [ ] Better color accessibility in warning states

## Phase 3 — Maintainability
- [ ] Split `index.html` into `index.html`, `styles.css`, and modular JS files
- [ ] Add lightweight lint/format checks
- [ ] Add local preview/dev instructions

## Phase 4 — Release Readiness
- [ ] Add screenshot states (normal, stale, degraded)
- [ ] Add manual smoke test checklist
- [ ] Tag a release with known constraints and rollback steps

## Success Metrics
- Operator can detect stale/degraded state in <3 seconds
- No silent feed failures
- New UI changes can be validated with checklist in <10 minutes