# Timesheet Studio

Version 0.3.0. Personal timesheets with a private account for each user, an administrator-managed invitation flow, and Excel/PDF exports based on the supplied company template.

## Features

- Username/email and password login; mandatory replacement of the initial admin password.
- Admin creates accounts from name and email; single-use activation and reset links.
- HTML email branded **Timesheet Studio by Febro One**, delivered through configurable SMTP on the VPS.
- Per-account server storage, optimistic revision checks, employee profile, custom company logo, and signature processing to transparent PNG.
- Seven configurable activity rows from A29–A55; multiple activities per day.
- Visible required Remote Location Bonus and Explanation on each date; optional manual regular hours, overtime, start and end times.
- POH only in H22; blank receiving cost center unless explicitly set; editable and confirmed suggestion for field-location days.
- Each period is saved independently with its own profile/activity snapshot, monthly history, personal Draft/Sent/Approved status, justified edits and audit snapshots.
- One `.xlsx` file and one worksheet for up to 31 days; correct Excel MIME for Safari downloads. Existing columns/row geometry and merges are retained, with a matching AL column for the 31st day. PDF uses one fitted landscape page.
- Sent and Approved are read-only until explicitly reopened with a reason; reopening Approved additionally requires an urgent-edit confirmation. No status sends email to a manager.

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

v0.4 adds embedded PNG signatures in Excel, shared custom activity codes, compact expandable activity rows, and automatic server-side encryption for private payloads. See `docs/VPS.md` for key backup/recovery and exact security boundaries. The master encryption key must never be committed to Git.
