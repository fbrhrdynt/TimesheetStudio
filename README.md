# Timesheet Studio

Personal timesheets with a private account for each user, an administrator-managed invitation flow, and Excel/PDF exports based on the supplied company template.

## Features

- Username/email and password login; mandatory replacement of the initial admin password.
- Admin creates accounts from name and email; single-use activation and reset links.
- HTML email branded **Timesheet Studio by Febro One**, delivered through configurable SMTP on the VPS.
- Per-account server storage, optimistic revision checks, employee profile, custom company logo, and signature processing to transparent PNG.
- Seven configurable activity rows from A29–A55; multiple activities per day.
- Visible required Remote Location Bonus and Explanation on each date; optional manual regular hours, overtime, start and end times.
- POH only in H22; blank receiving cost center unless explicitly set; editable and confirmed suggestion for field-location days.
- Excel keeps original row/column geometry and merges; images retain aspect ratio; PDF preview and output, JSON backup/restore.

## Run on a VPS

Node.js 24+ is required. Install dependencies, copy `.env.example` to `.env`, configure `APP_URL` and the initial administrator password, then run:

```bash
npm install --omit=dev
npm start
```

For the complete Ubuntu, Nginx, systemd, SMTP and backup instructions, read [docs/DEPLOY-VPS.md](docs/DEPLOY-VPS.md).

There is no self-registration. The bootstrap admin username is `febroherdyanto`; the password is supplied through server configuration and is never stored in source. SMTP configuration is required before invitations or password reset email can be delivered.

Run backend checks with `npm test` on Node 24+. They cover first-password enforcement, invitation activation, token expiry/replay, session revocation, data isolation, revision conflicts, and missing SMTP behavior.

## Source layout

`public/` is the browser app and template assets. `server/core.mjs` is the shared authentication/data API. `server/node.mjs` provides the VPS HTTP/SQLite/SMTP adapters. `drizzle/` contains schema migrations. `deploy/` contains systemd and Nginx examples. Runtime records and secrets must remain outside source control.

The Excel template is the user's supplied form, sanitized of sample identity, activity entries and signature. Company marks remain the property of their owners; each user can upload their own logo.
