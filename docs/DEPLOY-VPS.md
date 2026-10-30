# Deploy Timesheet Studio on Ubuntu

Node.js 24 LTS or later is required (`node:sqlite` is built in). No Docker, no frontend build, and no PM2 are required. This repository uses systemd and Nginx. The database is SQLite with WAL and contains separate documents for every account.

## 1. Prepare paths and source

```bash
sudo install -d -o ubuntu -g ubuntu -m 0750 /home/ubuntu/codex /home/ubuntu/patches /home/ubuntu/backups && \
install -d -m 0700 /home/ubuntu/codex/timesheet-studio-data && \
git clone https://github.com/fbrhrdynt/TimesheetStudio.git /home/ubuntu/codex/timesheet-studio && \
cd /home/ubuntu/codex/timesheet-studio && \
npm install --omit=dev && \
bash deploy/configure.sh
```

The configuration script prompts for the public HTTPS URL and initial admin password without echoing it. Enter the initial password selected for this deployment. Credentials are kept in `.env`, never in Git. Existing `.env` files are preserved. Set `ADMIN_INITIAL_PASSWORD` only on initial installation. The bootstrap identity is username `febroherdyanto`, email `febroherdyanto98@gmail.com`. The first login is restricted to changing the password; no dashboard or user administration is accessible until that completes. Remove `ADMIN_INITIAL_PASSWORD` from `.env` afterward and restart. It never resets an existing admin.

## 2. Configure SMTP

Edit `.env`, keeping file permissions at `600`:

```dotenv
SMTP_HOST=smtp.example.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-smtp-user
SMTP_PASS="your-smtp-password"
SMTP_FROM=timesheet@your-domain.com
```

Port 587 requires STARTTLS. For implicit TLS on 465, use `SMTP_SECURE=true`. Configure the sending domain's SPF/DKIM/DMARC with your mail provider. The sender display name is **Timesheet Studio by Febro One**. Never commit `.env`.

With SMTP absent, invited accounts remain pending and the administrator sees “Menunggu SMTP”; no claim is made that an email was sent. After configuring SMTP and restarting, use **Kirim ulang** on the pending account. Sending failures are recorded without passwords, email bodies, or activation tokens in logs. This version has an SMTP transport in the VPS runtime. The hosted cloud preview keeps email pending until the VPS transport is configured.

## 3. Start the service

Confirm `command -v node` is `/usr/bin/node`, or update `ExecStart` in the unit to the correct absolute executable. Then:

```bash
sudo install -m 0644 deploy/timesheet-studio.service /etc/systemd/system/timesheet-studio.service && \
sudo systemctl daemon-reload && \
sudo systemctl enable --now timesheet-studio && \
sudo systemctl status timesheet-studio --no-pager
```

Migrations in `drizzle/*.sql` apply once at startup inside a transaction; the migration ledger is stored in the database. Runtime data is outside the Git checkout.

## 4. Nginx and TLS

Copy `deploy/nginx.conf`, replace `timesheet.example.com`, enable the configuration, run `sudo nginx -t`, reload Nginx, then install a valid TLS certificate using your normal Certbot procedure. `APP_URL` must exactly match the public HTTPS origin. The application binds to localhost; the Nginx reverse proxy is the public entrypoint. HTTPS sessions use Secure, HttpOnly, SameSite=Strict cookies.

## 5. Account workflow

1. Log in as the administrator and replace the initial password.
2. In **Kelola pengguna**, enter a name and email.
3. The invitation expires after 24 hours. The user chooses a password and optional username. If no username is selected, the email is used.
4. The user logs in and configures their own employee profile, logo, signature, activity rows, and daily entries.
5. Reset links expire after 30 minutes. A used/expired link cannot be used again. Password changes revoke existing sessions and other reset tokens.

There is no public signup and no user role promotion endpoint. Admin may disable and re-enable normal accounts; disabling revokes sessions and pending reset/activation tokens.

## 6. Backup and update

Use SQLite's online backup API rather than copying the database while it is open. On a server with `sqlite3` installed:

```bash
mkdir -p /home/ubuntu/backups && \
sqlite3 /home/ubuntu/codex/timesheet-studio-data/timesheet.sqlite ".backup '/home/ubuntu/backups/timesheet-studio.sqlite'" && \
chmod 600 /home/ubuntu/backups/timesheet-studio.sqlite
```

Keep `.env` backed up separately with the same restricted permissions. An update does not change the database or reset passwords:

```bash
cd /home/ubuntu/codex/timesheet-studio && \
git pull --ff-only && \
npm install --omit=dev && \
sudo systemctl restart timesheet-studio
```

Inspect service logs with `journalctl -u timesheet-studio -n 100 --no-pager`. When two devices edit at once, stale writes are rejected; back up the open draft as JSON and reload rather than overwriting newer server records.

## Export behavior

The original workbook retains column widths, row heights, row count, and merges. Export changes input values, selected text styles, image placement, number formats, print area and fit-to-page settings. Seven activity rows are available. Periods longer than 30 days use two worksheets with the original geometry. POH is only H22. Location and explanation are required for every selected date. Four manual daily time fields are optional. Receiving cost center is blank unless explicitly configured for that activity row. Field-location day count needs an editable confirmation and prints on the first worksheet. PDF uses the same coordinates and contains a rendered page image, not selectable text; compare the output against your organization's required form before submitting.
