# CampusSphere – Complete Roadmap

## Part 7: Deployment, DevOps, Security & Compliance

> **Document Series:** Part 7 of 8
> **Continues from:** [Part 6: UI Wireframes](./Roadmap_Part6_UI_Wireframes.md)

---

## 7.1 Cloudflare-Centric Infrastructure

```
┌──────────────────────────────────────────────────────────────────────┐
│              PRODUCTION INFRASTRUCTURE                                │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │                    CLOUDFLARE EDGE                              │  │
│  │                                                                │  │
│  │  DNS (*.campussphere.in + custom domains)                      │  │
│  │  ├── Auto SSL (Universal + Advanced CNAMEs)                   │  │
│  │  ├── WAF (Web Application Firewall)                            │  │
│  │  ├── DDoS Protection (Layer 3/4/7)                            │  │
│  │  └── Bot Protection                                            │  │
│  │                                                                │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │  │
│  │  │  CF Pages    │  │  CF Workers  │  │  CF R2       │        │  │
│  │  │  ──────────  │  │  ──────────  │  │  ──────────  │        │  │
│  │  │  Admin Web   │  │  Hono API    │  │  File Store  │        │  │
│  │  │  Super Admin │  │  All Routes  │  │  Assignments │        │  │
│  │  │  React/Next  │  │  Tenant MW   │  │  Receipts    │        │  │
│  │  │              │  │  Auth/RBAC   │  │  Avatars     │        │  │
│  │  └──────────────┘  └──────┬───────┘  │  Recordings  │        │  │
│  │                           │           └──────────────┘        │  │
│  │  ┌──────────────┐        │                                    │  │
│  │  │  CF KV       │        │                                    │  │
│  │  │  ──────────  │        │                                    │  │
│  │  │  Tenant slug │        │                                    │  │
│  │  │  → ID map    │        │                                    │  │
│  │  │  Feature     │        │                                    │  │
│  │  │  flags       │        │                                    │  │
│  │  └──────────────┘        │                                    │  │
│  └──────────────────────────┼────────────────────────────────────┘  │
│                              │                                       │
│  ┌───────────────────────────┼───────────────────────────────────┐  │
│  │              EXTERNAL SERVICES                                 │  │
│  │                           │                                    │  │
│  │  ┌──────────────┐  ┌─────▼────────┐  ┌──────────────┐        │  │
│  │  │  Supabase    │  │  Upstash     │  │  Railway/    │        │  │
│  │  │  ──────────  │  │  Redis       │  │  Fly.io      │        │  │
│  │  │  PostgreSQL  │  │  ──────────  │  │  ──────────  │        │  │
│  │  │  + RLS       │  │  JWT blacklist│  │  AI/ML       │        │  │
│  │  │  + Realtime  │  │  Tenant cache │  │  FastAPI     │        │  │
│  │  │              │  │  Rate limit   │  │  Models      │        │  │
│  │  └──────────────┘  │  Sessions     │  └──────────────┘        │  │
│  │                     └──────────────┘                           │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐        │  │
│  │  │  Resend      │  │  MSG91       │  │  100ms       │        │  │
│  │  │  ──────────  │  │  ──────────  │  │  ──────────  │        │  │
│  │  │  Emails      │  │  SMS (DLT)   │  │  WebRTC      │        │  │
│  │  │  Receipts    │  │  OTP         │  │  Meetings    │        │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘        │  │
│  │                                                                │  │
│  │  ┌──────────────┐  ┌──────────────┐                           │  │
│  │  │  Firebase    │  │  Razorpay    │                           │  │
│  │  │  ──────────  │  │  ──────────  │                           │  │
│  │  │  FCM Push    │  │  SaaS billing│                           │  │
│  │  │  Notifs      │  │  Subscriptons│                           │  │
│  │  └──────────────┘  └──────────────┘                           │  │
│  └───────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7.2 CI/CD Pipeline (GitHub Actions)

```yaml
# .github/workflows/deploy.yml
name: CampusSphere CI/CD

on:
  push:
    branches: [main, staging]
  pull_request:
    branches: [main]

env:
  CLOUDFLARE_API_TOKEN: ${{ secrets.CF_API_TOKEN }}
  CLOUDFLARE_ACCOUNT_ID: ${{ secrets.CF_ACCOUNT_ID }}

jobs:
  # ── Lint & Type Check ────────────────────────────
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm turbo lint type-check

  # ── Unit Tests ───────────────────────────────────
  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm turbo test
      - uses: codecov/codecov-action@v3

  # ── Deploy Workers API ───────────────────────────
  deploy-api:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - name: Deploy to Cloudflare Workers
        working-directory: workers
        run: npx wrangler deploy --env production
        env:
          CLOUDFLARE_API_TOKEN: ${{ secrets.CF_API_TOKEN }}

  # ── Deploy Admin Dashboard (CF Pages / Vercel) ──
  deploy-admin:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v2
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: 'pnpm'
      - run: pnpm install --frozen-lockfile
      - run: pnpm turbo build --filter=admin-dashboard
      - name: Deploy to Cloudflare Pages
        uses: cloudflare/pages-action@v1
        with:
          apiToken: ${{ secrets.CF_API_TOKEN }}
          accountId: ${{ secrets.CF_ACCOUNT_ID }}
          projectName: campussphere-admin
          directory: apps/admin-dashboard/out

  # ── Deploy AI Service ────────────────────────────
  deploy-ai:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Deploy AI Service to Railway
        uses: bervProject/railway-deploy@main
        with:
          railway_token: ${{ secrets.RAILWAY_TOKEN }}
          service: campussphere-ai

  # ── Database Migrations ──────────────────────────
  migrate:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: supabase/setup-cli@v1
      - run: supabase db push --linked
        env:
          SUPABASE_ACCESS_TOKEN: ${{ secrets.SUPABASE_ACCESS_TOKEN }}
```

---

## 7.3 Security Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│              SECURITY LAYERS                                          │
│                                                                      │
│  Layer 1: EDGE (Cloudflare)                                          │
│  ────────────────────────                                            │
│  ├── WAF Rules: OWASP Top 10 protection                             │
│  ├── Rate Limiting: Per-IP + Per-Tenant via Upstash Redis           │
│  ├── DDoS: Automatic L3/L4/L7 mitigation                           │
│  ├── Bot Protection: Challenge suspicious traffic                   │
│  ├── IP Geoblocking: Optional per-tenant (India-only option)        │
│  └── SSL/TLS: TLS 1.3, HSTS enforced                               │
│                                                                      │
│  Layer 2: APPLICATION (Workers)                                      │
│  ──────────────────────────────                                      │
│  ├── Authentication                                                  │
│  │   ├── Custom JWT (access + refresh tokens)                       │
│  │   ├── Access Token: 15 min expiry                                │
│  │   ├── Refresh Token: 7 day expiry, stored HTTP-only cookie       │
│  │   ├── Token Blacklist: Upstash Redis (on logout/password change) │
│  │   ├── OTP: 6-digit, 5 min expiry, 3 attempts max                │
│  │   └── Device binding: Single device per student                  │
│  │                                                                   │
│  ├── Authorization (RBAC)                                            │
│  │   ├── Role-based middleware checks on every request               │
│  │   ├── Roles: student, faculty, hod, coordinator, admin, super    │
│  │   └── Resource ownership: verified per request                   │
│  │                                                                   │
│  ├── Input Validation                                                │
│  │   ├── Zod schemas on all endpoints                                │
│  │   ├── SQL injection: prevented by Supabase SDK (parameterized)   │
│  │   ├── XSS: sanitized output + Content-Security-Policy            │
│  │   └── File upload: type + size validation before R2               │
│  │                                                                   │
│  └── Anti-Proxy (Attendance)                                         │
│      ├── GPS coordinates with haversine distance check               │
│      ├── Device fingerprinting (single registered device)           │
│      ├── Time window enforcement (10 min from class start)          │
│      ├── IP analysis (detect VPN/proxy IPs)                         │
│      └── Anomaly detection (multiple marks from same device)        │
│                                                                      │
│  Layer 3: DATA (Supabase)                                            │
│  ────────────────────────                                            │
│  ├── Row-Level Security (RLS): Tenant isolation at DB level         │
│  ├── Encryption at rest: Supabase default (AES-256)                 │
│  ├── Aadhaar fields: AES-256 encrypted before storage               │
│  ├── Password: bcrypt with cost factor 12                            │
│  ├── Payment gateway secrets: encrypted in tenant config             │
│  ├── Connection pooling: Supabase Pooler (PgBouncer)                │
│  └── Backups: Daily automated via Supabase                          │
│                                                                      │
│  Layer 4: FILE STORAGE (R2)                                          │
│  ──────────────────────────                                          │
│  ├── Private by default (no public URLs)                             │
│  ├── Pre-signed URLs for download (15 min expiry)                   │
│  ├── Upload validation: file type + size + virus scan (future)      │
│  └── Tenant-scoped paths: /{tenant_id}/...                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7.4 Authentication Flow

```
┌──────────────────────────────────────────────────────────────────────┐
│              JWT AUTH FLOW (Custom, not Supabase Auth)                │
│                                                                      │
│  Login:                                                              │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Client                  Worker API              Upstash Redis │  │
│  │  ──────                  ──────────              ────────────  │  │
│  │  POST /auth/login                                              │  │
│  │  { phone, password }                                           │  │
│  │       │                                                        │  │
│  │       ├──→ Verify password (bcrypt compare)                    │  │
│  │       │    Check tenant_id + is_active                         │  │
│  │       │                                                        │  │
│  │       │    Generate:                                           │  │
│  │       │    accessToken (JWT, 15m, HS256)                       │  │
│  │       │    ├── sub: user_id                                    │  │
│  │       │    ├── tenant_id: xxx                                  │  │
│  │       │    ├── role: "student"                                 │  │
│  │       │    └── exp: now + 15m                                  │  │
│  │       │                                                        │  │
│  │       │    refreshToken (JWT, 7d, separate secret)             │  │
│  │       │    └── Stored in HTTP-only cookie                     │  │
│  │       │                                                        │  │
│  │       │                         Store refresh token ───────→  │  │
│  │       │                         Key: refresh:{user_id}        │  │
│  │       │                         TTL: 7 days                    │  │
│  │       │                                                        │  │
│  │       ◄──── { accessToken, user, tenant }                     │  │
│  └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  Refresh:                                                            │
│  POST /auth/refresh (with HTTP-only cookie)                         │
│  → Verify refresh token exists in Redis                             │
│  → Issue new access token                                           │
│  → Rotate refresh token (one-time use)                              │
│                                                                      │
│  Logout:                                                             │
│  POST /auth/logout                                                   │
│  → Add access token JTI to blacklist in Redis (TTL: 15m)           │
│  → Delete refresh token from Redis                                  │
│  → Clear HTTP-only cookie                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7.5 Indian Compliance

```
┌──────────────────────────────────────────────────────────────────────┐
│              COMPLIANCE FRAMEWORK                                     │
│                                                                      │
│  1. DPDP Act (Digital Personal Data Protection Act, 2023)            │
│  ─────────────────────────────────────────────────────               │
│  ├── Consent: Explicit consent collected at registration             │
│  ├── Purpose: Data used only for stated educational purposes        │
│  ├── Minimization: Only essential data collected                    │
│  ├── Deletion: Account deletion within 30 days on request          │
│  ├── DPO: Each tenant can assign Data Protection Officer            │
│  ├── Breach: Notification within 72 hours                           │
│  └── Aadhaar: AES-256 encrypted, accessed only with consent        │
│                                                                      │
│  2. IT Act, 2000 (+ Amendments)                                      │
│  ──────────────────────────────                                      │
│  ├── Sec 43A: Reasonable security practices (ISO 27001 aligned)     │
│  ├── Sec 72: Privacy and confidentiality of data                    │
│  ├── SSL/TLS mandatory for all data transmission                    │
│  └── Audit logs maintained for 3 years                              │
│                                                                      │
│  3. RBI Guidelines (Payment Related)                                 │
│  ──────────────────────────────────                                  │
│  ├── No storage of full card details                                │
│  ├── PCI DSS compliance via payment gateway (Razorpay handles)     │
│  ├── Transaction audit trail maintained                             │
│  └── Automated reconciliation reports                               │
│                                                                      │
│  4. UGC/AICTE Requirements                                          │
│  ─────────────────────────                                           │
│  ├── Attendance tracking: Min 75% enforced with configurable %     │
│  ├── Result format: CGPA/Grade as per university standards          │
│  ├── Student records: Maintained as per UGC norms                   │
│  └── Accessibility: WCAG 2.1 AA compliance (target)                │
│                                                                      │
│  5. SMS/DLT Compliance (India SMS Regulations)                       │
│  ─────────────────────────────────────────                           │
│  ├── DLT registration (MSG91 handles)                                │
│  ├── Entity ID + Template IDs approved                               │
│  ├── Sender ID registered ("CMPSPH" or tenant-custom)               │
│  └── Opt-in/opt-out mechanisms                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7.6 Environment Variables

```
┌──────────────────────────────────────────────────────────────────────┐
│              SECRETS MANAGEMENT                                       │
│                                                                      │
│  Cloudflare Workers Secrets (via wrangler secret put):               │
│  ──────────────────────────────────────────────                      │
│                                                                      │
│  # Supabase                                                         │
│  SUPABASE_URL=https://xxxx.supabase.co                              │
│  SUPABASE_SERVICE_KEY=eyJhbGci...                                   │
│                                                                      │
│  # Upstash Redis                                                     │
│  UPSTASH_REDIS_URL=https://xxxx.upstash.io                          │
│  UPSTASH_REDIS_TOKEN=AXxx...                                        │
│                                                                      │
│  # Auth                                                              │
│  JWT_SECRET=<64-char-random>                                        │
│  JWT_REFRESH_SECRET=<64-char-random>                                │
│                                                                      │
│  # Communication                                                     │
│  RESEND_API_KEY=re_xxxx                                              │
│  MSG91_AUTH_KEY=xxxx                                                 │
│  WATI_API_KEY=xxxx                                                   │
│                                                                      │
│  # Push Notifications                                                │
│  FCM_SERVER_KEY=xxxx                                                 │
│  FCM_PROJECT_ID=campussphere                                        │
│                                                                      │
│  # Platform Payments (CampusSphere's Razorpay for SaaS billing)     │
│  RAZORPAY_PLATFORM_KEY_ID=rzp_live_xxxx                             │
│  RAZORPAY_PLATFORM_KEY_SECRET=xxxx                                  │
│                                                                      │
│  # Video Meetings                                                    │
│  HMAC_100MS_SECRET=xxxx                                              │
│  HMS_TEMPLATE_ID=xxxx                                                │
│                                                                      │
│  # R2 is bound directly in wrangler.toml (no secret needed)         │
│  # Tenant-specific payment secrets stored encrypted in DB            │
│                                                                      │
│  Storage: Cloudflare Workers Secrets (encrypted at rest)             │
│  Access: Available as env.VAR_NAME in Worker code                   │
│  Never committed to Git. Never logged.                               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7.7 Monitoring & Observability

```
┌──────────────────────────────────────────────────────────────────────┐
│              MONITORING STACK                                         │
│                                                                      │
│  Error Tracking:     Sentry (Cloudflare Workers + Flutter + React)   │
│  Logging:            Logflare (Cloudflare integration)               │
│  Uptime Monitoring:  Cloudflare Health Checks                       │
│  APM:                Cloudflare Workers Analytics                   │
│  Alerting:           Sentry + PagerDuty (Enterprise)                │
│                                                                      │
│  Key Metrics Tracked:                                                │
│  ├── API response times (p50, p95, p99)                             │
│  ├── Error rates by endpoint                                        │
│  ├── Worker CPU time (Cloudflare dashboard)                         │
│  ├── Database connection pool usage                                 │
│  ├── Redis cache hit/miss ratio                                     │
│  ├── R2 storage usage per tenant                                    │
│  ├── Payment success/failure rates                                  │
│  ├── WebRTC connection quality (100ms dashboard)                    │
│  └── Supabase Realtime connection count                             │
└──────────────────────────────────────────────────────────────────────┘
```

---

> **→ Continue to [Part 8: Business Model & Timeline](./Roadmap_Part8_Business_Timeline.md)**
