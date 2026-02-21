# CampusSphere – Complete Roadmap

## Part 4: Fee Management, Payment Integration & White-Label Engine

> **Document Series:** Part 4 of 8
> **Continues from:** [Part 3: Core Modules](./Roadmap_Part3_Core_Modules.md)

---

## 4.1 Fee Management Lifecycle

```
┌──────────────────────────────────────────────────────────────────────┐
│              FEE LIFECYCLE                                            │
│                                                                      │
│  Step 1: Admin Creates Fee Structure                                 │
│  ═══════════════════════════════════                                 │
│  Admin Dashboard → Fee Management → Create Structure                 │
│  {                                                                   │
│    "name": "B.Tech 3rd Sem Tuition 2025-26",                        │
│    "academicYear": "2025-26",                                        │
│    "departmentId": "cse-uuid",                                       │
│    "programId": "btech-uuid",                                        │
│    "semester": 3,                                                    │
│    "feeType": "tuition",                                             │
│    "amount": 22500,                                                  │
│    "dueDate": "2026-03-15",                                          │
│    "lateFeePerDay": 50,                                              │
│    "installmentsAllowed": true,                                      │
│    "maxInstallments": 3                                               │
│  }                                                                   │
│                                                                      │
│  Step 2: System Auto-Assigns Fees to Students                        │
│  ════════════════════════════════════════════                         │
│  → Cloudflare Cron Trigger runs daily                                │
│  → Finds students matching dept/program/semester                     │
│  → Creates fee_records with scholarship deductions                   │
│  → Sends notification: "Tuition fee of ₹22,500 due by Mar 15"      │
│                                                                      │
│  Step 3: Student Views Fee Dashboard                                 │
│  ═══════════════════════════════════                                 │
│  → Net amount after scholarship                                      │
│  → Installment options                                                │
│  → Late fee calculation if past due date                              │
│  → Payment history with receipts                                     │
│                                                                      │
│  Step 4: Student Pays                                                │
│  ═════════════════════                                               │
│  → Selects amount (full or installment)                              │
│  → Redirected to tenant's configured payment gateway                 │
│  → Payment captured via webhook                                      │
│  → Receipt PDF auto-generated, stored in R2                         │
│  → Emailed via Resend + WhatsApp notification                       │
│                                                                      │
│  Step 5: Admin Reports                                               │
│  ══════════════════                                                  │
│  → Real-time collection dashboard                                    │
│  → Export to Excel for accounting                                    │
│  → GST-compliant invoice generation                                  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4.2 Payment Integration (Configurable per Tenant)

### How It Works

```
┌──────────────────────────────────────────────────────────────────────┐
│              PAYMENT ARCHITECTURE                                     │
│                                                                      │
│  TWO SEPARATE PAYMENT FLOWS:                                         │
│                                                                      │
│  Flow 1: SaaS Platform Billing (B2B)                                 │
│  ──────────────────────────────────                                  │
│  • WHO PAYS: Institution (admin)                                     │
│  • WHAT: Monthly/yearly CampusSphere subscription                   │
│  • GATEWAY: Razorpay Subscriptions (platform-controlled)            │
│  • INCLUDES: Plan management, upgrade/downgrade, invoice             │
│                                                                      │
│  Flow 2: Student Fee Collection (B2C)                                │
│  ─────────────────────────────────                                   │
│  • WHO PAYS: Student                                                 │
│  • WHAT: Tuition, hostel, exam, lab fees                             │
│  • GATEWAY: Institution's choice (from tenant config)               │
│  • SUPPORTED: Razorpay, Cashfree, PayU, CCAvenue, Custom           │
│                                                                      │
│  Why Configurable?                                                   │
│  Some institutions already have payment gateway contracts.           │
│  They should be able to use their own gateway+credentials.           │
│  New institutions get Razorpay by default.                           │
│                                                                      │
│  Payment Flow (Student Fees):                                        │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Student App                 Worker API              Gateway    │  │
│  │  ──────────                 ──────────              ──────── │  │
│  │  [Pay ₹16,375]                                                │  │
│  │       │                                                        │  │
│  │       ├── POST /v1/fees/pay ──→ Create order on                │  │
│  │       │   { feeRecordId,        tenant's gateway               │  │
│  │       │     amount }             (Razorpay/Cashfree/etc)       │  │
│  │       │                              │                         │  │
│  │       ◄── { orderId, gatewayUrl } ───┘                         │  │
│  │       │                                                        │  │
│  │  Open gateway checkout (Razorpay/Cashfree SDK)                │  │
│  │  Student pays via UPI/Card/NetBanking                          │  │
│  │       │                                                        │  │
│  │       │                    Webhook: /v1/webhooks/payment       │  │
│  │       │                         │                              │  │
│  │       │                    Verify signature                    │  │
│  │       │                    Update payment status               │  │
│  │       │                    Update fee_record balance           │  │
│  │       │                    Generate PDF receipt → R2           │  │
│  │       │                    Send receipt via Resend + FCM       │  │
│  │       │                         │                              │  │
│  │       ◄── Push: "Payment successful! Receipt attached" ──────┘  │
│  └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

### Gateway Abstraction Layer

```typescript
// workers/src/modules/fees/gateway-factory.ts

interface PaymentGateway {
  createOrder(params: CreateOrderParams): Promise<OrderResult>;
  verifySignature(params: VerifyParams): boolean;
  handleWebhook(payload: any, signature: string): Promise<WebhookResult>;
  initiateRefund(paymentId: string, amount: number): Promise<RefundResult>;
}

// Factory pattern: returns correct gateway based on tenant config
export function getPaymentGateway(tenant: TenantConfig): PaymentGateway {
  switch (tenant.eduPaymentGateway) {
    case 'razorpay':
      return new RazorpayGateway(tenant.eduGatewayKeyId, tenant.eduGatewayKeySecret);
    case 'cashfree':
      return new CashfreeGateway(tenant.eduGatewayKeyId, tenant.eduGatewayKeySecret);
    case 'payu':
      return new PayUGateway(tenant.eduGatewayKeyId, tenant.eduGatewayKeySecret);
    case 'ccavenue':
      return new CCAvenue(tenant.eduGatewayKeyId, tenant.eduGatewayKeySecret);
    default:
      return new RazorpayGateway(tenant.eduGatewayKeyId, tenant.eduGatewayKeySecret);
  }
}

// Usage in fee payment route:
app.post('/v1/fees/pay', authMiddleware, async (c) => {
  const tenant = c.get('tenant');
  const gateway = getPaymentGateway(tenant);

  const order = await gateway.createOrder({
    amount: body.amount * 100, // paise
    currency: 'INR',
    receipt: `FEE-${feeRecord.id}`,
    notes: {
      studentId: student.id,
      feeRecordId: body.feeRecordId,
      tenantId: tenant.id,
    },
  });

  return c.json({ orderId: order.id, gatewayKey: tenant.eduGatewayKeyId });
});
```

### Receipt Generation

```
┌──────────────────────────────────────────────────────────────────────┐
│              RECEIPT GENERATION FLOW                                  │
│                                                                      │
│  Payment Verified → Worker triggers receipt generation               │
│                                                                      │
│  Receipt Includes:                                                   │
│  ├── Institution name + logo (from tenant config)                   │
│  ├── Receipt number: RCP-2026-00198                                 │
│  ├── Student name, roll number, department                           │
│  ├── Fee breakdown (tuition, lab, library, etc.)                    │
│  ├── Scholarship deduction                                           │
│  ├── Payment method, transaction ID                                 │
│  ├── Date/time in IST                                                │
│  ├── Digital signature / verification QR                             │
│  └── "Powered by CampusSphere" (or removed for white-label Pro+)   │
│                                                                      │
│  Storage: PDF → Cloudflare R2 at:                                   │
│  /{tenant_id}/receipts/{year}/{student_id}/{receipt_number}.pdf     │
│                                                                      │
│  Delivery:                                                           │
│  ├── In-app download                                                 │
│  ├── Email via Resend (PDF attachment)                               │
│  └── WhatsApp link (via WATI)                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4.3 SaaS Platform Billing (Razorpay Subscriptions)

### Pricing Tiers

```
┌──────────────────────────────────────────────────────────────────────┐
│              CAMPUSSPHERE – PRICING TABLE                             │
│                                                                      │
│  ┌────────────────┬────────────────┬────────────────┬──────────────┐│
│  │    STARTER     │      PRO       │   ENTERPRISE   │    TRIAL     ││
│  ├────────────────┼────────────────┼────────────────┼──────────────┤│
│  │ ₹4,999/mo      │ ₹14,999/mo     │ Custom         │ FREE 30 days ││
│  │ ₹49,999/yr     │ ₹1,49,999/yr   │ Contact Sales  │              ││
│  ├────────────────┼────────────────┼────────────────┼──────────────┤│
│  │ 500 students   │ 2000 students  │ Unlimited      │ 100 students ││
│  │ 30 faculty     │ 100 faculty    │ Unlimited      │ 10 faculty   ││
│  │ 5GB storage    │ 50GB storage   │ 500GB+ storage │ 1GB storage  ││
│  ├────────────────┼────────────────┼────────────────┼──────────────┤│
│  │ ✅ Attendance   │ ✅ Everything   │ ✅ Everything   │ ✅ Core only  ││
│  │ ✅ Academics    │   in Starter   │   in Pro       │              ││
│  │ ✅ Fees         │ ✅ Assignments  │ ✅ Custom domain│              ││
│  │ ✅ Timetable    │ ✅ Chatrooms    │ ✅ AI Analytics │              ││
│  │ ✅ Notifications│ ✅ Meetings     │ ✅ Priority SLA │              ││
│  │ ✅ Basic Reports│ ✅ Adv Reports  │ ✅ API Access   │              ││
│  │ ❌ Chatrooms    │ ✅ Email+Push   │ ✅ White-label  │              ││
│  │ ❌ Meetings     │ ❌ AI Analytics │   App          │              ││
│  │ ❌ AI           │ ❌ Custom domain│ ✅ On-premise   │              ││
│  │ ❌ SMS/WhatsApp │ ✅ SMS+WhatsApp │ ✅ Dedicated    │              ││
│  │                │                │   Support      │              ││
│  └────────────────┴────────────────┴────────────────┴──────────────┘│
│                                                                      │
│  All plans include: SSL, Daily Backups, Email Support                │
│  +18% GST applicable on all plans                                    │
└──────────────────────────────────────────────────────────────────────┘
```

### Razorpay Subscription Integration

```typescript
// workers/src/modules/billing/subscription.service.ts
import Razorpay from 'razorpay';

// Platform-level Razorpay (CampusSphere's own keys, NOT tenant keys)
const platformRazorpay = new Razorpay({
  key_id: env.RAZORPAY_PLATFORM_KEY_ID,
  key_secret: env.RAZORPAY_PLATFORM_KEY_SECRET,
});

// Create subscription plan (done once by super admin)
async function createPlan(planConfig: PlanConfig) {
  return platformRazorpay.plans.create({
    period: planConfig.period,     // 'monthly' | 'yearly'
    interval: 1,
    item: {
      name: `CampusSphere ${planConfig.name}`,
      amount: planConfig.amount * 100,  // paise
      currency: 'INR',
      description: planConfig.description,
    },
  });
}

// Subscribe a tenant to a plan
async function subscribeTenant(tenantId: string, planId: string) {
  const tenant = await supabase.from('tenants').select('*').eq('id', tenantId).single();

  const subscription = await platformRazorpay.subscriptions.create({
    plan_id: planId,
    total_count: 12,               // 12 billing cycles
    customer_notify: 1,
    notes: {
      tenant_id: tenantId,
      institution_name: tenant.data.name,
    },
  });

  // Store subscription ID with tenant
  await supabase.from('tenants').update({
    razorpay_subscription_id: subscription.id,
    subscription_status: 'active',
    plan: planId.includes('starter') ? 'starter' : 'pro',
  }).eq('id', tenantId);

  return subscription;
}
```

---

## 4.4 White-Label Engine

### Theme Engine (Flutter Mobile)

```dart
// apps/mobile/lib/core/theme/dynamic_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DynamicTheme {
  /// Load tenant-specific theme from API/cache
  static Future<ThemeData> loadTheme(String tenantId) async {
    // 1. Try loading from local cache (Hive)
    final cachedConfig = await TenantCache.getConfig(tenantId);

    // 2. If not cached, fetch from API
    final config = cachedConfig ?? await TenantApi.getConfig(tenantId);

    // 3. Build ThemeData from tenant config
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _hexToColor(config.primaryColor),
        primary: _hexToColor(config.primaryColor),
        secondary: _hexToColor(config.secondaryColor),
        tertiary: _hexToColor(config.accentColor),
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.getTextTheme(config.fontFamily),
      appBarTheme: AppBarTheme(
        backgroundColor: _hexToColor(config.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _hexToColor(config.primaryColor),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}

// Usage in main.dart:
// final theme = await DynamicTheme.loadTheme(tenantId);
// runApp(MaterialApp(theme: theme, ...));
```

### Domain Routing (Cloudflare DNS)

```
┌──────────────────────────────────────────────────────────────────────┐
│              DOMAIN ROUTING ARCHITECTURE                              │
│                                                                      │
│  Default Subdomains (Free for all tenants):                          │
│  ├── xyz.campussphere.in → XYZ Engineering College                  │
│  ├── abc.campussphere.in → ABC Arts College                         │
│  └── def.campussphere.in → DEF Medical College                      │
│                                                                      │
│  Custom Domains (Pro/Enterprise):                                    │
│  ├── erp.xyzcollege.edu.in → XYZ College (CNAME to CF)             │
│  └── campus.defmed.ac.in → DEF Medical (CNAME to CF)               │
│                                                                      │
│  Setup:                                                              │
│  1. Super admin adds custom domain in tenant config                 │
│  2. Cloudflare API auto-creates DNS record                           │
│  3. Cloudflare auto-provisions SSL certificate                       │
│  4. Worker resolves tenant from hostname                             │
│                                                                      │
│  Tenant Middleware (Hono):                                           │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  export async function tenantMiddleware(c, next) {             │  │
│  │    const host = c.req.header('host');                          │  │
│  │    let tenantId: string | null = null;                        │  │
│  │                                                                │  │
│  │    // Priority 1: JWT claim                                    │  │
│  │    const jwt = c.get('auth');                                  │  │
│  │    if (jwt?.tenantId) {                                        │  │
│  │      tenantId = jwt.tenantId;                                  │  │
│  │    }                                                           │  │
│  │    // Priority 2: Subdomain                                    │  │
│  │    else if (host?.endsWith('.campussphere.in')) {              │  │
│  │      const slug = host.split('.')[0];                          │  │
│  │      tenantId = await resolveTenantBySlug(slug, c.env);       │  │
│  │    }                                                           │  │
│  │    // Priority 3: Custom domain                                │  │
│  │    else {                                                      │  │
│  │      tenantId = await resolveTenantByDomain(host, c.env);     │  │
│  │    }                                                           │  │
│  │    // Priority 4: Header (for mobile apps)                     │  │
│  │    if (!tenantId) {                                            │  │
│  │      tenantId = c.req.header('X-Tenant-ID');                  │  │
│  │    }                                                           │  │
│  │                                                                │  │
│  │    if (!tenantId) return c.json({ error: 'Tenant not found' },│  │
│  │                              404);                             │  │
│  │                                                                │  │
│  │    // Load config from Redis cache or Supabase                 │  │
│  │    const config = await getTenantConfig(tenantId, c.env);     │  │
│  │    c.set('tenantId', tenantId);                                │  │
│  │    c.set('tenant', config);                                    │  │
│  │                                                                │  │
│  │    // Set RLS context for Supabase queries                     │  │
│  │    await c.get('supabase').rpc('set_tenant_context',          │  │
│  │      { tenant_id: tenantId });                                 │  │
│  │                                                                │  │
│  │    await next();                                               │  │
│  │  }                                                             │  │
│  └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  Tenant Config Caching (Upstash Redis):                              │
│  ├── Key: tenant:config:{tenantId}                                  │
│  ├── TTL: 5 minutes                                                  │
│  ├── Invalidated on admin config save                                │
│  └── Fallback: query Supabase if cache miss                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

> **→ Continue to [Part 5: AI/ML Analytics Layer](./Roadmap_Part5_AI_Analytics.md)**
