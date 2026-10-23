# Deploy and Host

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/actual-budget-1?utm_campaign=actualbudget)

**Actual Budget** — the local-first, privacy-focused envelope budgeting app (a self-hosted YNAB alternative) as a one-click Railway template. Track accounts, plan spending with envelope budgets, import bank transactions, and keep every byte of your financial data on your own infrastructure. Zero form fields on deploy.

On first boot the server binds Railway's injected `PORT`, initializes its SQLite state on the persistent volume, and serves the full web app. Open the URL, create your first budget file, and set a server password in Settings — no accounts, no subscriptions, no data leaving your server.

## About Hosting

One service, deployed with one click:

- **actualbudget** — Actual Budget v26.10.0 server (pinned official image `actualbudget/actual-server`, digest-pinned), healthcheck `GET /`, binds Railway's injected `PORT` natively (verified in upstream source)
- Persistent volume `actualbudget-data` at `/data` — `account.sqlite` (login/sessions) plus all budget files

No companion services: Actual is a single Node process with embedded SQLite. Point any browser at your Railway domain and budget.

## Why Deploy

Self-hosting Actual Budget means your financial data never leaves your infrastructure — no cloud subscription, no third-party analytics on your spending. It's local-first: the app works offline and syncs to your server, with bank sync via SimpleFIN/GoCardless configured per budget. On Railway it is always on, so multi-device sync just works around the clock.

## Common Use Cases

- Envelope budgeting for households — give every dollar a job, roll over unused funds
- Multi-device budget sync without a SaaS subscription
- Net-worth and spending tracking with bank transaction import
- A private finance hub: schedules, reports, and goals with zero data sharing

## Configuration

Zero form fields on deploy. After deploy, the optional knobs in the service's **Variables** panel (all upstream `ACTUAL_*` vars; the template bakes only the data dir):

- `ACTUAL_DATA_DIR` — data directory (baked default `/data`, the volume mount)
- `PORT` — injected by Railway automatically; the server binds `0.0.0.0:$PORT` (`ACTUAL_PORT` is the upstream alias)
- `ACTUAL_HOSTNAME` — bind hostname (default `::`, all interfaces)
- `ACTUAL_LOGIN_METHOD` — auth method: `password` (default), `header`, or `openid`
- `ACTUAL_TRUSTED_PROXIES` — comma-separated trusted reverse proxies (for correct client IPs behind extra proxies)
- `ACTUAL_TOKEN_EXPIRATION` — session token lifetime
- `ACTUAL_UPLOAD_FILE_SIZE_LIMIT_MB` / `ACTUAL_UPLOAD_SYNC_ENCRYPTED_FILE_SIZE_LIMIT_MB` / `ACTUAL_UPLOAD_GENERAL_FILE_SIZE_LIMIT_MB` — upload caps in MB
- `ACTUAL_OPENID_DISCOVERY_URL`, `ACTUAL_OPENID_CLIENT_ID`, `ACTUAL_OPENID_CLIENT_SECRET`, ... — OpenID Connect
- `ACTUAL_ENFORCE_OPENID` — require OpenID login

Set your server password in the web UI after first boot (Settings). Bank sync (SimpleFIN, GoCardless) is configured per budget in the UI, not via env vars.

## Dependencies for

### Deployment Dependencies

Hobby plan or higher for the persistent volume. Actual Budget needs nothing at runtime beyond its volume — no external API keys, no companion services, no third-party accounts. `GET /` returns 200 once the server is up.
