#!/usr/bin/env bash
set -euo pipefail
cd /home/ubuntu/codex/timesheet-studio
if [[ -f .env ]]; then
  echo 'Existing .env preserved. Edit it directly if configuration needs to change.'
  exit 0
fi
read -r -p 'Public URL (https://your-domain): ' studio_url
if [[ ! "$studio_url" =~ ^https://[A-Za-z0-9.-]+(:[0-9]+)?$ ]]; then echo 'Use an https origin without a path.'; exit 1; fi
read -r -s -p 'Initial admin password (replace at first login): ' studio_initial
printf '\n'
if [[ ${#studio_initial} -lt 8 || "$studio_initial" == *$'\n'* || "$studio_initial" == *'"'* || "$studio_initial" == *'\'* ]]; then echo 'Initial password requires 8+ characters, without quotes or backslashes.'; exit 1; fi
umask 077
{
  printf 'APP_URL=%s\nHOST=127.0.0.1\nPORT=3018\nDATA_DIR=/home/ubuntu/codex/timesheet-studio-data\n' "$studio_url"
  printf 'ADMIN_INITIAL_PASSWORD="%s"\n' "$studio_initial"
  printf 'SMTP_HOST=\nSMTP_PORT=587\nSMTP_SECURE=false\nSMTP_USER=\nSMTP_PASS=\nSMTP_FROM=\n'
} > .env
unset studio_initial
chmod 600 .env
printf 'Configuration saved. Configure SMTP in .env before sending invitations.\n'
