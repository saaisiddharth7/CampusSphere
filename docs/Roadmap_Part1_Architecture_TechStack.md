# CampusSphere – Complete Roadmap

## Part 1: Vision, System Architecture & Complete Tech Stack

> **Document Series:** Part 1 of 13
> **Project:** CampusSphere – White-Label AI-Powered Campus Management Platform
> **Target:** India Government Hackathon → B2B SaaS for Indian Colleges & Schools
> **Author:** CampusSphere Team
> **Date:** February 2026
> **Status:** Production Architecture – Ready for Implementation

---

## Table of Contents

```
1.1  Executive Vision & Problem Statement
1.2  Platform Identity & Positioning
1.3  Target Customer Segments & Market Analysis
1.4  High-Level System Architecture
1.5  Multi-Tenant Architecture (Deep Dive)
1.6  White-Label Configuration Engine
1.7  Complete Technology Stack (with Decision Rationale)
1.8  Request Lifecycle & Data Flow
1.9  Project Directory Structure
1.10 Role-Based Access Control (RBAC) – Complete Matrix
1.11 Core Feature Modules Overview
1.12 Extended Platform Modules Index (Parts 9-13)
1.13 Indian Education System Compatibility Matrix
1.14 Environment Variables & Secrets Registry
1.15 Performance & Scalability Targets
1.16 Glossary of Terms
```

---

## 1.1 Executive Vision & Problem Statement

### The Problem

Indian educational institutions (40,000+ colleges, 1,000+ universities, 1.5M+ schools) face a **fragmented technology landscape**:

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    THE PROBLEM – INDIAN EDUCATION TECH                    │
│                                                                          │
│   Current State (Most Indian Institutions):                              │
│                                                                          │
│   📋 Attendance     → Paper registers / Excel sheets                    │
│   💰 Fee Collection → Manual counter collection / Bank challans          │
│   📄 Results        → PDF printouts on notice boards                     │
│   📅 Timetable      → Printed sheets distributed per semester            │
│   📞 Communication  → WhatsApp groups (unorganized, multiple groups)     │
│   📝 Assignments    → Paper-based submission, manual tracking            │
│   📊 Reports        → Faculty manually compiles for NAAC/NBA/AISHE       │
│   🏠 Hostel         → Logbooks and registers                             │
│   💼 Placements     → Excel + WhatsApp + Notice board                    │
│                                                                          │
│   Pain Points:                                                           │
│   ├── ❌ No single source of truth for student data                     │
│   ├── ❌ Proxy attendance rampant across campuses                       │
│   ├── ❌ Parents have zero visibility into child's progress             │
│   ├── ❌ Fee defaulters hard to track; revenue leakage                  │
│   ├── ❌ NAAC/NBA accreditation reports take weeks to compile           │
│   ├── ❌ No predictive analytics to identify at-risk students           │
│   ├── ❌ High cost of existing ERP solutions (₹10-50L/year)            │
│   └── ❌ Zero integration between different systems                     │
│                                                                          │
│   Market Gap:                                                            │
│   ├── Existing solutions are expensive (Oracle, SAP, custom builds)     │
│   ├── Most solutions are NOT mobile-first                                │
│   ├── No white-labeling (institutions want their own brand)             │
│   ├── Not designed for Indian infrastructure (low bandwidth, UPI)       │
│   └── No AI/ML integration for predictive insights                      │
└──────────────────────────────────────────────────────────────────────────┘
```

### The Solution: CampusSphere

CampusSphere is a **production-grade, white-label, multi-tenant SaaS platform** that transforms how Indian educational institutions manage their campus operations.

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    THE SOLUTION – CAMPUSSPHERE                            │
│                                                                          │
│   What CampusSphere delivers:                                            │
│                                                                          │
│   ✅ Single platform replacing 10+ disconnected tools                   │
│   ✅ Mobile-first: Works on ₹8,000 Android phones + 2G/3G              │
│   ✅ White-label: "MyCollege ERP" with institution's branding           │
│   ✅ AI-powered: Dropout prediction, attendance trends, performance     │
│   ✅ Affordable: ₹15/student/month (vs ₹500+ for competitors)          │
│   ✅ Geo-fenced + biometric attendance (anti-proxy)                     │
│   ✅ UPI / Razorpay / Cashfree – Indian payment stack                   │
│   ✅ NAAC/NBA reports auto-generated from platform data                 │
│   ✅ Offline-capable: Queue operations when no internet                 │
│   ✅ 30+ modules covering every campus need                             │
│                                                                          │
│   Strategic Goals:                                                       │
│   1. Win the Government Hackathon → Working prototype demo              │
│   2. Scale as B2B SaaS → Sell to colleges/universities/schools          │
│   3. White-Label → Each institution = their own branded app             │
│   4. India-First → UPI, DLT SMS, regional languages, low bandwidth     │
│   5. Data-Driven → AI insights no Indian campus has today               │
└──────────────────────────────────────────────────────────────────────────┘
```

### Key Differentiators

| Differentiator | CampusSphere | Competitors (Oracle, Fedena, CampusNexus) |
|---|---|---|
| **Pricing** | ₹15-45/student/month | ₹200-500+/student/month |
| **White-Label** | Full branding (app, domain, logo) | Limited or none |
| **Mobile App** | Flutter (Android + iOS) | Web-only or poor mobile UX |
| **Deployment** | Cloud-native, serverless | On-premise or VM-based |
| **AI/ML** | Built-in (dropout risk, predictions) | Add-on or absent |
| **Offline Mode** | Yes (queue + sync) | No |
| **Setup Time** | < 24 hours | 2-6 months |
| **India Stack** | UPI, DLT SMS, AADHAAR-ready | Often western-focused |
| **Multi-Tenant** | Shared infra, isolated data (RLS) | Separate instances = costly |

---

## 1.2 Platform Identity & Positioning

```
┌──────────────────────────────────────────────────────────────────────────┐
│                    CAMPUSSPHERE – BRAND IDENTITY                         │
│                                                                          │
│   Platform Name:    CampusSphere                                         │
│   Tagline:          "Every Campus. One Sphere."                          │
│   Platform Domain:  campussphere.in                                      │
│   Tenant Pattern:   <institution>.campussphere.in                        │
│   Custom Domains:   erp.myinstitution.edu.in (CNAME → campussphere.in) │
│                                                                          │
│   Product Tiers:                                                         │
│   ┌──────────────┬─────────────────────────────────────────────────┐    │
│   │ Tier         │ Description                                     │    │
│   ├──────────────┼─────────────────────────────────────────────────┤    │
│   │ Starter      │ Core modules (Attendance, Fees, Results)        │    │
│   │ Professional │ + Assignments, Chatrooms, Meetings, Timetable  │    │
│   │ Premium      │ + AI Analytics, Hostel, Placement, Events      │    │
│   │ Enterprise   │ + Custom domain, Priority support, SLA         │    │
│   └──────────────┴─────────────────────────────────────────────────┘    │
│                                                                          │
│   Deployment Model:                                                      │
│   ├── Shared Infrastructure (all tenants on same Supabase + Workers)    │
│   ├── Data Isolation via PostgreSQL Row-Level Security (RLS)            │
│   ├── Per-tenant file storage (R2 bucket prefixes)                      │
│   └── No separate servers per tenant = massive cost efficiency          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 1.3 Target Customer Segments & Market Analysis

### Customer Segments

```
┌─────────────────────────────────────────────────────────────────────┐
│                    CampusSphere – Target Markets                     │
├─────────────────────┬───────────────────────┬───────────────────────┤
│   Tier 1: Colleges  │  Tier 2: Universities  │  Tier 3: Schools     │
│   ─────────────     │  ──────────────────    │  ────────────────    │
│   • Engineering     │  • State Universities  │  • CBSE Schools      │
│   • Medical         │  • Deemed Universities │  • ICSE Schools      │
│   • Arts & Science  │  • Central Universities│  • State Board       │
│   • Polytechnics    │  • Private Universities│  • International     │
│   • B.Ed Colleges   │  • Open Universities   │  • Coaching Inst.    │
├─────────────────────┴───────────────────────┴───────────────────────┤
│   Tier 4: Government Bodies                                         │
│   • State Education Departments                                     │
│   • UGC / AICTE Monitoring Dashboards                               │
│   • District-Level Education Networks                               │
└─────────────────────────────────────────────────────────────────────┘
```

### Total Addressable Market (India)

```
┌──────────────────────────────────────────────────────────────────────┐
│                    TAM / SAM / SOM                                    │
│                                                                      │
│   TAM (Total Addressable Market):                                    │
│   • 40,000+ colleges × avg 2,000 students = 80M students            │
│   • 1,000+ universities                                             │
│   • 1.5M+ schools                                                    │
│   • Market Size: ~₹12,000 Cr/year (EdTech ERP)                      │
│                                                                      │
│   SAM (Serviceable Available Market):                                │
│   • 15,000 private colleges actively seeking digital solutions       │
│   • 500 universities with budget for ERP                             │
│   • Market Size: ~₹3,000 Cr/year                                    │
│                                                                      │
│   SOM (Serviceable Obtainable Market – Year 1-3):                    │
│   • 50-200 colleges (aggressive sales + word of mouth)               │
│   • Focus: Tamil Nadu, Karnataka, Maharashtra, Telangana             │
│   • Target Revenue: ₹3.6 Cr by Year 3                               │
│                                                                      │
│   Pricing Sweet Spot:                                                │
│   • ₹15/student/month (Starter) — ₹45/student/month (Enterprise)   │
│   • Average college: 2,000 students × ₹25 × 12 = ₹6 LPA           │
│   • This is 10-20x cheaper than Oracle/SAP alternatives             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.4 High-Level System Architecture

### Architecture Philosophy

CampusSphere follows a **serverless-first, edge-optimized** architecture. Every design decision prioritizes:

1. **Low latency** – API responses < 100ms at edge (Cloudflare Workers)
2. **Zero cold starts** – Workers V8 isolates start in < 5ms
3. **Automatic scaling** – No capacity planning needed
4. **Cost efficiency** – Pay per request, not per server
5. **Data isolation** – PostgreSQL RLS enforces tenant boundaries at the DB level
6. **Offline resilience** – Mobile app queues operations when network is unreliable

### Why NOT Traditional Servers?

```
┌──────────────────────────────────────────────────────────────────────┐
│   ARCHITECTURE DECISION: Serverless vs Traditional                    │
│                                                                      │
│   Option A: Traditional (Node.js + Express on EC2/VPS)               │
│   ├── ❌ Monthly server cost ₹5,000-30,000 even with zero traffic   │
│   ├── ❌ Cold starts on Lambda (up to 3 seconds for Node.js)        │
│   ├── ❌ Manual scaling (add more instances as tenants grow)         │
│   ├── ❌ Single region = high latency for distant users             │
│   └── ❌ DevOps overhead (Docker, Kubernetes, load balancers)       │
│                                                                      │
│   Option B: Cloudflare Workers + Supabase ✅ (CHOSEN)                │
│   ├── ✅ ₹0 cost for first 100K requests/day (free tier generous)   │
│   ├── ✅ 0ms cold start (V8 isolates, not containers)               │
│   ├── ✅ Auto-scales to millions of requests                        │
│   ├── ✅ Deployed to 300+ edge locations globally                   │
│   ├── ✅ Built-in DDoS protection, WAF, SSL                        │
│   └── ✅ Minimal DevOps (just `wrangler deploy`)                    │
│                                                                      │
│   Cost Comparison (1000 students, moderate usage):                    │
│   Traditional: ~₹15,000/month (EC2 + RDS + Redis + S3)              │
│   CampusSphere: ~₹2,000/month (Workers + Supabase + R2)             │
│   Savings: 87% lower infrastructure cost                             │
└──────────────────────────────────────────────────────────────────────┘
```

### Architecture Overview Diagram

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                         CAMPUSSPHERE – SYSTEM ARCHITECTURE                   │
│                                                                              │
│  ╔═══════════════════════════════════════════════════════════════════════╗   │
│  ║                        CLIENT LAYER                                   ║   │
│  ║                                                                       ║   │
│  ║  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ ║   │
│  ║  │ Student App  │  │ Faculty App  │  │  Admin Panel │  │ Super    │ ║   │
│  ║  │ (Flutter)    │  │ (Flutter)    │  │  (Next.js)   │  │ Admin    │ ║   │
│  ║  │              │  │              │  │              │  │ (Next.js)│ ║   │
│  ║  │ • Attendance │  │ • Mark Att.  │  │ • Manage     │  │ • Tenant │ ║   │
│  ║  │ • Timetable  │  │ • Grades     │  │ • Reports    │  │   Mgmt   │ ║   │
│  ║  │ • Fees       │  │ • Timetable  │  │ • Analytics  │  │ • Billing│ ║   │
│  ║  │ • Chatroom   │  │ • Assign.    │  │ • Settings   │  │ • White  │ ║   │
│  ║  │ • Meetings   │  │ • Chatroom   │  │ • Users      │  │   Label  │ ║   │
│  ║  │ • Hostel     │  │ • Meetings   │  │ • Hostel     │  │ • Analyt.│ ║   │
│  ║  │ • Placement  │  │ • Materials  │  │ • Inventory  │  │ • Support│ ║   │
│  ║  │ • AI Chat    │  │ • Research   │  │ • Placement  │  │          │ ║   │
│  ║  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘  └────┬─────┘ ║   │
│  ╚═════════╪════════════════╪════════════════╪═══════════════╪═══════╝   │
│            │                │                │               │            │
│            └────────────────┴────────┬───────┴───────────────┘            │
│                                      │ HTTPS (TLS 1.3)                    │
│                                      ▼                                    │
│  ╔═══════════════════════════════════════════════════════════════════════╗   │
│  ║              CLOUDFLARE EDGE NETWORK (300+ global PoPs)              ║   │
│  ║  ┌─────────────────────────────────────────────────────────────────┐║   │
│  ║  │ • DNS Resolution (campussphere.in + wildcard *.campussphere.in)│║   │
│  ║  │ • DDoS Protection (Layer 3, 4, 7)                              │║   │
│  ║  │ • Web Application Firewall (WAF – OWASP Top 10 rules)         │║   │
│  ║  │ • Bot Management (block scrapers, credential stuffing)         │║   │
│  ║  │ • Rate Limiting (per-IP + per-tenant)                          │║   │
│  ║  │ • Wildcard SSL Certificate (auto-renewed)                      │║   │
│  ║  │ • Custom Domain SSL (for institution domains)                  │║   │
│  ║  │ • Tenant Resolution: subdomain → tenant_id lookup              │║   │
│  ║  └────────────────────────────┬────────────────────────────────────┘║   │
│  ╚═══════════════════════════════╪════════════════════════════════════╝   │
│                                  │                                        │
│                                  ▼                                        │
│  ╔═══════════════════════════════════════════════════════════════════════╗   │
│  ║          CLOUDFLARE WORKERS (Hono Framework – Edge API Layer)        ║   │
│  ║                                                                       ║   │
│  ║  Middleware Chain (every request passes through):                      ║   │
│  ║  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐            ║   │
│  ║  │ CORS   │→│ Tenant │→│ Auth   │→│ RBAC   │→│ Rate   │→ Route    ║   │
│  ║  │ Handler│ │ Resolve│ │ Verify │ │ Check  │ │ Limit  │  Handler  ║   │
│  ║  └────────┘ └────────┘ └────────┘ └────────┘ └────────┘            ║   │
│  ║                                                                       ║   │
│  ║  Service Modules:                                                     ║   │
│  ║  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────────┐  ║   │
│  ║  │ Auth        │ │ Attendance  │ │ Academic    │ │ Fee & Payment │  ║   │
│  ║  │ Service     │ │ Service     │ │ Service     │ │ Service       │  ║   │
│  ║  └─────────────┘ └─────────────┘ └─────────────┘ └───────────────┘  ║   │
│  ║  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────────┐  ║   │
│  ║  │ Timetable   │ │ Assignment  │ │ Notification│ │ White-Label   │  ║   │
│  ║  │ Service     │ │ Service     │ │ Service     │ │ Config Service│  ║   │
│  ║  └─────────────┘ └─────────────┘ └─────────────┘ └───────────────┘  ║   │
│  ║  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────────┐  ║   │
│  ║  │ Chatroom    │ │ Meeting     │ │ Reports     │ │ Tenant Admin  │  ║   │
│  ║  │ Service     │ │ Service     │ │ Service     │ │ Service       │  ║   │
│  ║  └─────────────┘ └─────────────┘ └─────────────┘ └───────────────┘  ║   │
│  ║  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────────┐  ║   │
│  ║  │ Hostel      │ │ Inventory   │ │ Placement   │ │ Alumni        │  ║   │
│  ║  │ Service     │ │ Service     │ │ Service     │ │ Service       │  ║   │
│  ║  └─────────────┘ └─────────────┘ └─────────────┘ └───────────────┘  ║   │
│  ║  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌───────────────┐  ║   │
│  ║  │ Chatbot     │ │ Grievance   │ │ Events      │ │ Parent Portal │  ║   │
│  ║  │ Service     │ │ Service     │ │ Service     │ │ Service       │  ║   │
│  ║  └─────────────┘ └─────────────┘ └─────────────┘ └───────────────┘  ║   │
│  ╚═══════════════════════════════╪════════════════════════════════════╝   │
│                                  │                                        │
│           ┌──────────────────────┼──────────────────────┐                 │
│           │                      │                      │                 │
│           ▼                      ▼                      ▼                 │
│  ╔════════════════╗  ╔════════════════╗  ╔════════════════════════════╗   │
│  ║ Supabase       ║  ║ Upstash Redis  ║  ║ Cloudflare R2 + KV        ║   │
│  ║ (PostgreSQL    ║  ║ (Serverless)   ║  ║                            ║   │
│  ║  + Realtime    ║  ║                ║  ║ R2: File storage (docs,   ║   │
│  ║  + RLS         ║  ║ • JWT blacklist║  ║  photos, receipts, assign)║   │
│  ║  + Auth helpers║  ║ • Rate limiting║  ║                            ║   │
│  ║  + Edge Funcs) ║  ║ • Session cache║  ║ KV: Tenant config cache,  ║   │
│  ║                ║  ║ • Tenant cache ║  ║  feature flags, static    ║   │
│  ╚════════════════╝  ╚════════════════╝  ╚════════════════════════════╝   │
│                                                                           │
│  ╔═══════════════════════════════════════════════════════════════════════╗   │
│  ║                      EXTERNAL SERVICES                                ║   │
│  ║                                                                       ║   │
│  ║  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ ║   │
│  ║  │ Resend       │  │ MSG91        │  │ 100ms SDK    │  │ Firebase │ ║   │
│  ║  │ (Email)      │  │ (SMS – DLT)  │  │ (WebRTC      │  │ Cloud    │ ║   │
│  ║  │ OTP, alerts, │  │ OTP, attend. │  │  Meetings)   │  │ Messaging│ ║   │
│  ║  │ receipts     │  │ alerts       │  │              │  │ (Push)   │ ║   │
│  ║  └──────────────┘  └──────────────┘  └──────────────┘  └──────────┘ ║   │
│  ║  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ ║   │
│  ║  │ Razorpay     │  │ Cashfree     │  │ Sentry       │  │ Python   │ ║   │
│  ║  │ (SaaS Bill + │  │ PayU/CCAvenue│  │ + Logflare   │  │ AI/ML    │ ║   │
│  ║  │  Student Fee)│  │ (Alt. Gates) │  │ (Monitoring) │  │ (FastAPI)│ ║   │
│  ║  └──────────────┘  └──────────────┘  └──────────────┘  └──────────┘ ║   │
│  ╚═══════════════════════════════════════════════════════════════════════╝   │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 1.5 Multi-Tenant Architecture (Deep Dive)

### What is Multi-Tenancy?

Multi-tenancy means **multiple institutions (tenants) share the same application infrastructure** but their data is completely isolated. Think of it like an apartment building – same building, but each apartment is private and secure.

```
┌──────────────────────────────────────────────────────────────────────┐
│   MULTI-TENANCY MODELS COMPARED                                      │
│                                                                      │
│   Model 1: Separate Database per Tenant ❌ (NOT chosen)              │
│   ├── Each college gets its own PostgreSQL database                  │
│   ├── Pro: Perfect isolation                                         │
│   ├── Con: 100 colleges = 100 databases = massive cost              │
│   ├── Con: Schema migrations must run on ALL databases              │
│   └── Con: Cross-tenant analytics impossible                        │
│                                                                      │
│   Model 2: Separate Schema per Tenant ❌ (NOT chosen)                │
│   ├── One database, but each college has its own schema             │
│   ├── Pro: Good isolation, single DB                                │
│   ├── Con: 100 colleges = 100 schemas = complex migrations         │
│   └── Con: Connection pooling nightmare                             │
│                                                                      │
│   Model 3: Shared Tables + RLS ✅ (CHOSEN)                           │
│   ├── One database, one set of tables for ALL colleges              │
│   ├── Every table has a tenant_id column                            │
│   ├── PostgreSQL RLS policies auto-filter by tenant_id              │
│   ├── Pro: One migration updates ALL tenants                        │
│   ├── Pro: Cost-effective (one Supabase project)                    │
│   ├── Pro: Cross-tenant analytics possible (Super Admin)            │
│   ├── Pro: Connection pooling works normally                        │
│   └── Con: Requires careful RLS policy design (we handle this)      │
└──────────────────────────────────────────────────────────────────────┘
```

### Tenant Resolution Flow (Step by Step)

```
┌──────────────────────────────────────────────────────────────────────┐
│                   TENANT RESOLUTION – STEP BY STEP                    │
│                                                                      │
│   STEP 1: Request arrives at Cloudflare                              │
│   ──────────────────────────────────                                 │
│   URL: https://xyz.campussphere.in/v1/attendance/mark               │
│   OR:  https://erp.xyzcollege.edu.in/v1/attendance/mark             │
│                                                                      │
│   STEP 2: Cloudflare Worker extracts tenant identifier               │
│   ──────────────────────────────────────────────                     │
│   Source 1: Subdomain → "xyz" from xyz.campussphere.in              │
│   Source 2: Custom domain → lookup erp.xyzcollege.edu.in in DB/KV   │
│   Source 3: JWT claim → tenant_id from authenticated token           │
│   Source 4: Header → X-Tenant-ID (for server-to-server calls)       │
│                                                                      │
│   Priority: JWT > Header > Subdomain > Custom Domain                 │
│                                                                      │
│   STEP 3: Resolve tenant_id                                          │
│   ─────────────────────────                                          │
│   ┌─────────────────────────────────────────────┐                   │
│   │ 1. Check Upstash Redis cache:               │                   │
│   │    Key: "tenant:subdomain:xyz"              │                   │
│   │    → If found: return cached tenant config   │                   │
│   │                                              │                   │
│   │ 2. If cache miss, query Supabase:            │                   │
│   │    SELECT * FROM tenants                     │                   │
│   │    WHERE subdomain = 'xyz'                   │                   │
│   │      OR custom_domain = 'erp.xyzcollege.edu' │                   │
│   │                                              │                   │
│   │ 3. Cache result in Redis (TTL: 5 minutes):   │                   │
│   │    SET tenant:subdomain:xyz {config} EX 300  │                   │
│   └─────────────────────────────────────────────┘                   │
│                                                                      │
│   STEP 4: Set PostgreSQL tenant context for RLS                      │
│   ──────────────────────────────────────────────                     │
│   SQL: SET app.tenant_id = '<resolved_tenant_id>';                  │
│   → All subsequent queries in this request are now                   │
│     automatically filtered to this tenant's data                     │
│                                                                      │
│   STEP 5: Inject tenant config into request context                  │
│   ─────────────────────────────────────────────                      │
│   c.set('tenant', {                                                  │
│     id: 'uuid-...',                                                  │
│     name: 'XYZ Engineering College',                                 │
│     subdomain: 'xyz',                                                │
│     primaryColor: '#1E40AF',                                         │
│     logoUrl: 'https://r2.campussphere.in/xyz/logo.png',             │
│     enabledModules: ['attendance', 'fees', 'assignments', ...],     │
│     paymentGateway: 'razorpay',                                      │
│     plan: 'premium',                                                 │
│     studentLimit: 5000,                                              │
│   });                                                                │
│                                                                      │
│   STEP 6: Route handler executes with tenant context                 │
│   ─────────────────────────────────────────────                      │
│   → Any DB query automatically filtered by RLS                       │
│   → File uploads go to R2 path: /tenants/{tenant_id}/...            │
│   → Notifications sent with tenant's branding                       │
│   → Response includes tenant-specific configuration                 │
└──────────────────────────────────────────────────────────────────────┘
```

### RLS Policy Examples (How Data Isolation Works)

```sql
-- Every table has tenant_id. Here's how RLS works:

-- EXAMPLE 1: Students table
-- Students can only see their own record
-- Faculty can see students in their assigned classes
-- Admin can see all students in their tenant

CREATE POLICY "tenant_isolation" ON students
  FOR ALL
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

-- EXAMPLE 2: Attendance records
-- Students see only their own attendance
-- Faculty see attendance for classes they teach

CREATE POLICY "attendance_tenant_isolation" ON attendance_records
  FOR ALL
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

CREATE POLICY "student_own_attendance" ON attendance_records
  FOR SELECT
  USING (
    tenant_id = current_setting('app.tenant_id')::uuid
    AND student_id = auth.uid()
  );

-- EXAMPLE 3: Fee records (student sees own, admin sees all)
CREATE POLICY "fee_tenant_isolation" ON fee_records
  FOR ALL
  USING (tenant_id = current_setting('app.tenant_id')::uuid);

-- RESULT: College A's admin can NEVER see College B's students
-- This is enforced at the DATABASE level, not just the API level
-- Even if there's a bug in the API code, RLS prevents data leaks
```

---

## 1.6 White-Label Configuration Engine

### How White-Labeling Works

Each institution gets a **fully branded experience** – students, faculty, and parents see their institution's name, logo, and colors everywhere. They never see "CampusSphere".

```
┌──────────────────────────────────────────────────────────────────────┐
│                   WHITE-LABEL SETUP FLOW                             │
│                                                                      │
│   Super Admin creates new institution:                               │
│                                                                      │
│   Step 1: Basic Setup                                                │
│   ┌────────────────────────────────────┐                            │
│   │  Institution Name: XYZ College     │                            │
│   │  Subdomain: xyz.campussphere.in    │                            │
│   │  Custom Domain: erp.xyz.edu.in     │                            │
│   │  Contact Email: admin@xyz.edu.in   │                            │
│   │  Phone: +91-XXXXXXXXXX             │                            │
│   │  State: Tamil Nadu                 │                            │
│   │  Board/Affiliation: Anna Univ.     │                            │
│   └────────────────────────────────────┘                            │
│                                                                      │
│   Step 2: Branding                                                   │
│   ┌────────────────────────────────────┐                            │
│   │  Logo: [Upload to R2]             │                            │
│   │  Favicon: [Upload to R2]          │                            │
│   │  Primary Color: #1E40AF           │                            │
│   │  Secondary Color: #3B82F6         │                            │
│   │  Accent Color: #F59E0B           │                            │
│   │  Font: Inter / Poppins / Noto Sans│                            │
│   │  App Name: MyCollege ERP           │                            │
│   └────────────────────────────────────┘                            │
│                                                                      │
│   Step 3: Module Activation                                          │
│   ┌────────────────────────────────────────────────────────────┐    │
│   │  CORE (included in all plans):                              │    │
│   │  ☑ Attendance    ☑ Academic Dashboard  ☑ Fee Management    │    │
│   │  ☑ Timetable     ☑ Notifications       ☑ Student Profiles │    │
│   │                                                             │    │
│   │  PROFESSIONAL (Professional plan+):                         │    │
│   │  ☑ Assignments   ☑ Class Chatrooms     ☑ Live Meetings    │    │
│   │  ☑ Study Matls   ☑ Exam Timetable      ☑ Calendar         │    │
│   │                                                             │    │
│   │  PREMIUM (Premium plan+):                                   │    │
│   │  ☐ AI Analytics  ☐ Hostel Management   ☐ Placement Portal │    │
│   │  ☐ Grievance     ☐ Parent Portal       ☐ Event Ticketing  │    │
│   │  ☐ Inventory     ☐ Alumni Network      ☐ AI Chatbot       │    │
│   │  ☐ Polls         ☐ Internship Tracker  ☐ Research Repo    │    │
│   └────────────────────────────────────────────────────────────┘    │
│                                                                      │
│   Step 4: Payment Configuration                                      │
│   ┌────────────────────────────────────┐                            │
│   │  SaaS Billing: Razorpay (Auto)     │                            │
│   │  Student Fees Gateway:             │                            │
│   │    ○ Razorpay  ○ Cashfree          │                            │
│   │    ○ PayU      ○ CCAvenue          │                            │
│   │    ○ Custom (API Key + Secret)     │                            │
│   └────────────────────────────────────┘                            │
│                                                                      │
│   Step 5: Subscription Plan                                          │
│   ┌────────────────────────────────────┐                            │
│   │  Plan: Premium                     │                            │
│   │  Billing: Monthly / Yearly         │                            │
│   │  Students Limit: 5000              │                            │
│   │  Faculty Limit: 200                │                            │
│   │  Storage: 50GB (R2)               │                            │
│   │  Payment Method: UPI / Bank        │                            │
│   └────────────────────────────────────┘                            │
│                                                                      │
│   → Tenant record created in Supabase                                │
│   → Cloudflare DNS entry auto-configured                             │
│   → Admin credentials emailed via Resend                             │
│   → Institution is LIVE in < 5 minutes                               │
└──────────────────────────────────────────────────────────────────────┘
```

### Flutter Dynamic Theme Engine

```dart
// How the mobile app loads tenant-specific branding:

class DynamicTheme {
  /// Called on app launch and when tenant context changes
  static Future<ThemeData> loadTheme(String tenantId) async {
    // 1. Check local cache first (Hive)
    final cached = await Hive.box('theme').get(tenantId);
    if (cached != null && !isExpired(cached)) {
      return _buildTheme(cached);
    }

    // 2. Fetch from API
    final config = await TenantConfigApi.getConfig(tenantId);

    // 3. Cache locally for offline use
    await Hive.box('theme').put(tenantId, config.toJson());

    return _buildTheme(config);
  }

  static ThemeData _buildTheme(TenantConfig config) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _hexToColor(config.primaryColor),  // "#1E40AF"
        primary: _hexToColor(config.primaryColor),
        secondary: _hexToColor(config.secondaryColor),
        tertiary: _hexToColor(config.accentColor),
      ),
      textTheme: GoogleFonts.getTextTheme(config.fontFamily),
      appBarTheme: AppBarTheme(
        backgroundColor: _hexToColor(config.primaryColor),
        foregroundColor: Colors.white,
      ),
    );
  }
}

// RESULT: Student at XYZ College sees blue theme with "XYZ ERP" branding
// Student at ABC School sees green theme with "ABC Portal" branding
// Same APK, different look – powered by tenant_id
```

---

## 1.7 Complete Technology Stack (with Decision Rationale)

### Frontend – Mobile Application (Student & Faculty)

| Component | Technology | Why This? (Decision Rationale) |
|---|---|---|
| **Framework** | Flutter 3.x (Dart) | Single codebase for Android + iOS. 80% of Indian students use Android. Flutter is the most popular cross-platform framework in India. |
| **State Mgmt** | Riverpod 2.x | Scalable, testable, works with code generation. Better than Provider for large apps. |
| **Navigation** | GoRouter | Declarative routing with deep link support for push notification navigation. |
| **Local Storage** | Hive + SharedPreferences | Hive for structured data (offline attendance queue). SharedPreferences for simple flags. |
| **HTTP Client** | Dio | Interceptors for auth token refresh, tenant header injection, retry on network failure. |
| **Maps/Geo** | Google Maps Flutter + Geolocator | Geo-fencing for attendance marking. Ensures student is physically on campus. |
| **Push** | Firebase Cloud Messaging | Free, reliable, works on both Android & iOS. Every Indian Android phone has Google Play Services. |
| **Charts** | fl_chart | Lightweight, customizable charts for attendance and grade analytics. |
| **QR Code** | qr_flutter + mobile_scanner | QR-based attendance as fallback when geo-fence fails. |
| **Biometric** | local_auth | Fingerprint/Face ID for secure app login. Prevents sharing credentials. |
| **Offline** | Connectivity Plus + Hive | Queue attendance marks when offline (villages with poor connectivity). Sync when online. |
| **Theme** | Custom ThemeData from API | White-label colors/fonts dynamically loaded from tenant configuration. |
| **Realtime** | Supabase Realtime (Dart) | WebSocket channels for chatroom messages, live notification counts. |
| **Video** | 100ms Flutter SDK | WebRTC-based live class meetings. Better quality than Jitsi for Indian bandwidth. |

### Frontend – Admin Dashboard & Super Admin Panel

| Component | Technology | Why This? |
|---|---|---|
| **Framework** | React.js 18+ (TypeScript) | Rich ecosystem, excellent for data-heavy admin dashboards. |
| **Meta Framework** | Next.js 14 (App Router) | SSR for fast initial load, API routes, middleware for tenant resolution. |
| **UI Library** | shadcn/ui + Tailwind CSS | Beautiful, accessible components. Most popular in Indian dev community. |
| **State Mgmt** | Zustand + TanStack Query | Lightweight global state + powerful server state caching with auto-refetch. |
| **Charts** | Recharts + Tremor | Data visualization for analytics dashboards (attendance trends, fee collection). |
| **Tables** | TanStack Table | Virtual scrolling for large student/faculty lists (5000+ rows). |
| **Forms** | React Hook Form + Zod | Type-safe form validation for complex forms (student registration). |
| **Date/Time** | date-fns (IST default) | Indian Standard Time handling throughout. No UTC confusion. |
| **PDF** | @react-pdf/renderer | Fee receipts, mark sheets, hall tickets, NAAC reports. |
| **Excel** | SheetJS (xlsx) | Bulk data export for admins. Import student data from Excel. |

### Backend – API Server (Cloudflare Workers)

| Component | Technology | Why This? |
|---|---|---|
| **Runtime** | Cloudflare Workers (V8) | Edge-deployed, zero cold starts, 300+ locations, auto-scaling. |
| **Framework** | Hono 4.x | Ultrafast (4x faster than Express on Workers), Workers-native, great TypeScript DX. |
| **Language** | TypeScript 5.x | Type safety across the entire backend. Catches bugs at compile time. |
| **DB Client** | Supabase JS SDK | Type-safe queries with built-in RLS integration. Handles tenant context automatically. |
| **Auth** | Custom JWT (access + refresh) | Stateless auth. Access token (15min) + Refresh token (7d). Redis-backed blacklist for logout. |
| **AuthZ** | Custom RBAC middleware | 6 roles: Student, Faculty, HOD, Coordinator, Admin, Super Admin. |
| **Validation** | Zod | Request/response validation with TypeScript inference. Rejects malformed input. |
| **File Upload** | Cloudflare R2 SDK | S3-compatible, zero egress fees. Profile photos, assignments, receipts. |
| **Email** | Resend | Modern email API. OTP emails, fee receipts, attendance alerts. |
| **SMS** | MSG91 | India-specific, DLT-compliant SMS. Required for SMS in India since 2021. |
| **Cron** | Cloudflare Cron Triggers | Daily attendance reports, fee reminders, AI batch predictions. |
| **Rate Limit** | Upstash Redis | Per-IP and per-tenant rate limiting. Prevents API abuse. |
| **Logging** | Sentry + Logflare | Error tracking with tenant context + structured logging. |

### Database & Storage

| Component | Technology | Why This? |
|---|---|---|
| **Primary DB** | Supabase (PostgreSQL 15) | Managed Postgres with RLS, Realtime subscriptions, Auth helpers, Edge Functions. |
| **Cache** | Upstash Redis | Serverless Redis. Token blacklist, rate limiting, tenant config cache. |
| **KV Store** | Cloudflare KV | Edge-cached tenant configs, feature flags. Read-heavy, globally distributed. |
| **Search** | PostgreSQL Full-Text Search | Student/faculty search with pg_trgm for fuzzy matching. No need for Elasticsearch. |
| **File Storage** | Cloudflare R2 | S3-compatible, zero egress fees. Assignment files, profile photos, receipts. |
| **CDN** | Cloudflare CDN | Static assets, profile images, auto-optimized WebP conversion. |
| **Realtime** | Supabase Realtime | WebSocket channels for chat messages, notification counts, live dashboard updates. |
| **Backup** | Supabase PITR | Point-in-time recovery. Daily automated backups. 7-day retention. |

### AI/ML Layer

| Component | Technology | Why This? |
|---|---|---|
| **Language** | Python 3.11+ | ML ecosystem standard. scikit-learn, pandas, numpy. |
| **API** | FastAPI | High-performance async API for serving ML model predictions. |
| **ML Libs** | scikit-learn, XGBoost | Attendance prediction, dropout risk scoring, performance trends. |
| **Hosting** | Railway / Fly.io | Separate Python service (can't run Python on Cloudflare Workers). |
| **Scheduling** | Celery + Redis | Nightly batch prediction runs (recompute risk scores for all students). |

### Payment Integration

| Component | Technology | Why This? |
|---|---|---|
| **SaaS Billing** | Razorpay Subscriptions | Platform subscription billing for institutions (B2B invoicing). |
| **Student Fees** | Configurable per Tenant | Each institution picks their own payment gateway. |
| **Gateways** | Razorpay, Cashfree, PayU, CCAvenue | India's top 4 gateways. Cover 99% of Indian payment methods. |
| **UPI** | Via selected gateway | Direct UPI payment via Google Pay, PhonePe, Paytm. |

### Communication Stack

| Component | Technology | Why This? |
|---|---|---|
| **Push (Mobile)** | Firebase Cloud Messaging | Free, reliable, works on Android & iOS. |
| **Email** | Resend | Modern API, great deliverability, developer-friendly. |
| **SMS** | MSG91 | India-specific, DLT-compliant (legally required since 2021). |
| **WhatsApp** | WATI / Infobip | Fee reminders via WhatsApp Business API. India's most used messaging app. |
| **In-App Chat** | Supabase Realtime | Class chatrooms via WebSocket channels. |
| **Video** | 100ms / LiveKit | WebRTC-based live classes. Optimized for Indian bandwidth conditions. |

---

## 1.8 Request Lifecycle & Data Flow

### Complete Request Flow (Sequence)

This section explains exactly what happens when a student marks attendance, from pressing the button to receiving a confirmation.

```
┌──────────────────────────────────────────────────────────────────────┐
│   COMPLETE REQUEST LIFECYCLE – Mark Attendance Example                │
│                                                                      │
│   STEP 1: Flutter App (Student's Phone)                              │
│   ──────────────────────────────────                                 │
│   Student presses "Mark Attendance" button                           │
│                                                                      │
│   App collects:                                                      │
│   ├── GPS coordinates (latitude, longitude)                         │
│   ├── Device info (device_id, model, OS version)                    │
│   ├── Timestamp (IST)                                                │
│   ├── WiFi BSSID (if on campus WiFi)                                │
│   └── Subject ID (from current timetable entry)                     │
│                                                                      │
│   Dio HTTP Client sends:                                             │
│   POST https://xyz.campussphere.in/v1/attendance/mark               │
│   Headers:                                                           │
│     Authorization: Bearer eyJhbGci...                                │
│     X-Device-ID: flutter_abc123                                      │
│     Content-Type: application/json                                   │
│   Body: {                                                            │
│     "subject_id": "uuid-dbms-301",                                  │
│     "latitude": 13.0827,                                             │
│     "longitude": 80.2707,                                            │
│     "device_id": "flutter_abc123",                                   │
│     "wifi_bssid": "AA:BB:CC:DD:EE:FF"                               │
│   }                                                                  │
│                                                                      │
│   STEP 2: Cloudflare Edge Network                                    │
│   ───────────────────────────────                                    │
│   ├── DNS resolves xyz.campussphere.in → Cloudflare edge            │
│   ├── DDoS check passes                                             │
│   ├── WAF rules checked (no SQL injection, XSS)                    │
│   ├── Rate limit checked (< 100 req/min from this IP? OK)          │
│   └── Routes to nearest Cloudflare Worker (< 50ms latency)         │
│                                                                      │
│   STEP 3: Cloudflare Worker (Hono Middleware Chain)                  │
│   ──────────────────────────────────────────────                     │
│   3a. CORS Middleware                                                │
│       → Check origin, set appropriate headers                        │
│                                                                      │
│   3b. Tenant Middleware                                              │
│       → Extract "xyz" from subdomain                                 │
│       → Redis lookup: GET tenant:subdomain:xyz                       │
│       → Found: tenant_id = "t_001"                                  │
│       → SET app.tenant_id = 't_001' on Supabase connection          │
│                                                                      │
│   3c. Auth Middleware                                                │
│       → Extract JWT from Authorization header                        │
│       → Verify JWT signature with HMAC-SHA256 secret                │
│       → Check Redis blacklist: EXISTS blacklist:token:abc → No      │
│       → Check expiry: exp > now() → Valid                           │
│       → Extract: { user_id, role: "student", tenant_id: "t_001" }  │
│       → Verify: JWT tenant_id matches resolved tenant_id           │
│                                                                      │
│   3d. RBAC Middleware                                                │
│       → Route: POST /v1/attendance/mark                             │
│       → Required role: "student" ✅ (matches JWT role)              │
│                                                                      │
│   3e. Rate Limit Middleware                                          │
│       → Upstash Redis: INCR rate:t_001:user_id                     │
│       → Count: 5 (< 60/min limit) → Pass ✅                        │
│                                                                      │
│   STEP 4: Attendance Route Handler                                   │
│   ────────────────────────────────                                   │
│   4a. Validate request body with Zod schema                         │
│       → subject_id: valid UUID ✅                                   │
│       → latitude: valid float ✅                                    │
│       → longitude: valid float ✅                                   │
│                                                                      │
│   4b. Geo-fence check                                                │
│       → Load campus coordinates from tenant config                   │
│       → Calculate distance: haversine(student, campus)              │
│       → Distance: 45m (< 200m radius) → Inside campus ✅           │
│                                                                      │
│   4c. Timetable check                                                │
│       → Query: SELECT * FROM timetable_entries                      │
│         WHERE subject_id = $1 AND day_of_week = $2                  │
│         AND start_time <= now() AND end_time >= now()               │
│       → Active class found ✅                                       │
│                                                                      │
│   4d. Duplicate check                                                │
│       → Query: SELECT * FROM attendance_records                     │
│         WHERE student_id = $1 AND subject_id = $2 AND date = today  │
│       → No duplicate found ✅                                       │
│                                                                      │
│   4e. Anti-proxy check                                               │
│       → Same device_id used by another student today? No ✅         │
│       → WiFi BSSID matches known campus access points? Yes ✅       │
│                                                                      │
│   4f. Insert attendance record                                       │
│       → INSERT INTO attendance_records (                            │
│           tenant_id, student_id, subject_id, date,                  │
│           status, latitude, longitude, device_id,                    │
│           marked_at, method                                          │
│         ) VALUES (...)                                               │
│       → RLS automatically ensures tenant_id matches                 │
│                                                                      │
│   STEP 5: Post-Processing (async, non-blocking)                     │
│   ──────────────────────────────────────────────                     │
│   ├── Update running attendance percentage in cache                 │
│   ├── If attendance < 75%: trigger notification to student          │
│   ├── If first attendance today: update daily count for faculty     │
│   └── Trigger Supabase Realtime: faculty dashboard auto-updates     │
│                                                                      │
│   STEP 6: Response                                                   │
│   ──────────                                                         │
│   HTTP 201 Created                                                   │
│   {                                                                  │
│     "success": true,                                                 │
│     "data": {                                                        │
│       "attendance_id": "uuid-...",                                   │
│       "subject": "DBMS (CS301)",                                    │
│       "date": "2026-02-20",                                         │
│       "status": "present",                                           │
│       "running_percentage": 85.2                                     │
│     },                                                               │
│     "message": "Attendance marked successfully"                     │
│   }                                                                  │
│                                                                      │
│   Total Time: ~80ms (edge → DB → response)                          │
└──────────────────────────────────────────────────────────────────────┘
```

### Offline Mode Flow

```
┌──────────────────────────────────────────────────────────────────────┐
│   OFFLINE MODE – How it works when student has no internet           │
│                                                                      │
│   Scenario: Student in rural area with spotty 2G connection          │
│                                                                      │
│   1. Student presses "Mark Attendance"                               │
│   2. App detects no internet (Connectivity Plus)                     │
│   3. App stores attendance data locally in Hive:                     │
│      ┌─────────────────────────────────────────┐                    │
│      │ Hive Box: "offline_queue"               │                    │
│      │ {                                        │                    │
│      │   "type": "attendance_mark",            │                    │
│      │   "payload": { subject_id, lat, lng },  │                    │
│      │   "timestamp": "2026-02-20T14:00:00Z",  │                    │
│      │   "retries": 0                          │                    │
│      │ }                                        │                    │
│      └─────────────────────────────────────────┘                    │
│   4. App shows: "✅ Attendance queued. Will sync when online."       │
│   5. Background worker monitors connectivity                         │
│   6. When internet resumes:                                          │
│      → Read all items from offline_queue                             │
│      → Send each to API with original timestamp                     │
│      → Server validates: timestamp within class time? → Accept      │
│      → Remove from queue on success                                  │
│      → Show notification: "3 offline items synced ✅"                │
│   7. If sync fails: retry up to 3 times with exponential backoff    │
│   8. After 3 failures: mark as "manual_review" for faculty          │
└──────────────────────────────────────────────────────────────────────┘
```

### Realtime Data Flow (Chatrooms)

```
┌──────────────────────────────────────────────────────────────────────┐
│   REALTIME FLOW – Class Chatroom Messaging                           │
│                                                                      │
│   Student A sends message in DBMS chatroom:                          │
│                                                                      │
│   1. Flutter app → POST /v1/chatroom/messages                       │
│      Body: { chatroom_id: "...", content: "Doubt about 3NF" }      │
│                                                                      │
│   2. Worker validates & inserts into Supabase:                       │
│      INSERT INTO messages (chatroom_id, sender_id, content, ...)    │
│                                                                      │
│   3. Supabase Realtime detects INSERT on messages table              │
│      Broadcasts to WebSocket channel:                                │
│      "realtime:chatroom:{chatroom_id}"                               │
│                                                                      │
│   4. All connected clients (Student B, Student C, Faculty)           │
│      receive the message instantly via WebSocket:                     │
│      ┌──────────────────────────────────────┐                       │
│      │ { event: "INSERT",                   │                       │
│      │   new: {                             │                       │
│      │     id: "msg-uuid",                  │                       │
│      │     content: "Doubt about 3NF",      │                       │
│      │     sender_name: "Arun K",           │                       │
│      │     timestamp: "14:02:30"            │                       │
│      │   }                                  │                       │
│      │ }                                    │                       │
│      └──────────────────────────────────────┘                       │
│                                                                      │
│   5. Faculty's phone vibrates with notification                     │
│      (if push is enabled for this chatroom)                          │
│                                                                      │
│   Latency: < 50ms (WebSocket is persistent connection)               │
│   Scale: Supabase handles 10,000+ concurrent connections            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.9 Project Directory Structure

```
campussphere/
│
├── apps/
│   ├── mobile/                          # Flutter Mobile App
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── app/
│   │   │   │   ├── app.dart             # Root widget with theme engine
│   │   │   │   ├── router.dart          # GoRouter config
│   │   │   │   └── di.dart              # Dependency injection setup
│   │   │   ├── core/
│   │   │   │   ├── constants/           # API URLs, enums, keys
│   │   │   │   ├── theme/
│   │   │   │   │   ├── app_theme.dart   # Dynamic theme from tenant config
│   │   │   │   │   ├── colors.dart      # White-label color mapping
│   │   │   │   │   └── typography.dart  # Font definitions
│   │   │   │   ├── network/
│   │   │   │   │   ├── api_client.dart  # Dio setup with tenant interceptor
│   │   │   │   │   ├── api_endpoints.dart
│   │   │   │   │   └── interceptors/
│   │   │   │   │       ├── auth_interceptor.dart
│   │   │   │   │       ├── tenant_interceptor.dart
│   │   │   │   │       └── offline_interceptor.dart
│   │   │   │   ├── utils/
│   │   │   │   │   ├── geo_fence_util.dart
│   │   │   │   │   ├── device_info_util.dart
│   │   │   │   │   └── date_utils.dart  # IST conversion helpers
│   │   │   │   └── widgets/             # Shared widgets
│   │   │   │       ├── cs_button.dart
│   │   │   │       ├── cs_card.dart
│   │   │   │       ├── cs_app_bar.dart
│   │   │   │       └── cs_bottom_nav.dart
│   │   │   ├── features/               # Feature-first architecture
│   │   │   │   ├── auth/               # Login, OTP, biometric
│   │   │   │   ├── attendance/         # Mark, view, stats
│   │   │   │   ├── academic/           # Results, CGPA, rank
│   │   │   │   ├── fees/               # Pay, history, receipts
│   │   │   │   ├── timetable/          # Weekly view, notifications
│   │   │   │   ├── assignments/        # List, submit, track
│   │   │   │   │   ├── data/
│   │   │   │   │   │   ├── assignment_repository.dart
│   │   │   │   │   │   └── assignment_api.dart
│   │   │   │   │   ├── domain/
│   │   │   │   │   │   ├── assignment_model.dart
│   │   │   │   │   │   └── submission_model.dart
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── assignment_list_screen.dart
│   │   │   │   │       ├── assignment_detail_screen.dart
│   │   │   │   │       ├── submit_assignment_screen.dart
│   │   │   │   │       └── submission_tracker_screen.dart
│   │   │   │   ├── chatroom/           # Chat, rooms, messages
│   │   │   │   │   ├── data/
│   │   │   │   │   ├── domain/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── chatroom_list_screen.dart
│   │   │   │   │       ├── chatroom_screen.dart
│   │   │   │   │       └── widgets/
│   │   │   │   ├── meetings/           # Schedule, join, recordings
│   │   │   │   │   ├── data/
│   │   │   │   │   ├── domain/
│   │   │   │   │   └── presentation/
│   │   │   │   │       ├── meeting_list_screen.dart
│   │   │   │   │       ├── meeting_room_screen.dart
│   │   │   │   │       └── schedule_meeting_screen.dart
│   │   │   │   ├── hostel/             # Room, mess, gate pass
│   │   │   │   ├── placement/          # Drives, applications
│   │   │   │   ├── chatbot/            # AI assistant
│   │   │   │   ├── notifications/
│   │   │   │   └── profile/
│   │   │   └── l10n/                   # Localization (15 languages)
│   │   │       ├── app_en.arb          # English
│   │   │       ├── app_hi.arb          # Hindi
│   │   │       ├── app_ta.arb          # Tamil
│   │   │       └── app_te.arb          # Telugu
│   │   ├── android/
│   │   ├── ios/
│   │   └── pubspec.yaml
│   │
│   ├── admin-dashboard/                # Next.js Admin Panel
│   │   ├── src/
│   │   │   ├── app/
│   │   │   │   ├── layout.tsx
│   │   │   │   ├── (auth)/
│   │   │   │   ├── (dashboard)/
│   │   │   │   │   ├── layout.tsx
│   │   │   │   │   ├── page.tsx        # Dashboard overview
│   │   │   │   │   ├── students/       # Student management
│   │   │   │   │   ├── faculty/        # Faculty management
│   │   │   │   │   ├── attendance/     # Attendance reports
│   │   │   │   │   ├── academics/      # Results, grades
│   │   │   │   │   ├── assignments/    # Assignment management
│   │   │   │   │   ├── chatrooms/      # Chatroom moderation
│   │   │   │   │   ├── meetings/       # Meeting management
│   │   │   │   │   ├── fees/           # Fee collection
│   │   │   │   │   ├── timetable/      # Timetable builder
│   │   │   │   │   ├── hostel/         # Hostel management
│   │   │   │   │   ├── inventory/      # Asset tracking
│   │   │   │   │   ├── placement/      # Placement drives
│   │   │   │   │   ├── grievances/     # Grievance handling
│   │   │   │   │   ├── events/         # Event management
│   │   │   │   │   ├── reports/        # Analytics & reports
│   │   │   │   │   ├── notifications/  # Notification center
│   │   │   │   │   └── settings/       # Tenant settings
│   │   │   │   └── api/
│   │   │   ├── components/             # shadcn/ui components
│   │   │   ├── lib/
│   │   │   │   ├── supabase.ts
│   │   │   │   ├── api-client.ts
│   │   │   │   └── utils.ts
│   │   │   ├── hooks/                  # React hooks
│   │   │   ├── stores/                 # Zustand stores
│   │   │   └── types/                  # TypeScript interfaces
│   │   └── package.json
│   │
│   └── super-admin/                    # Next.js Super Admin Panel
│       ├── src/
│       │   └── app/
│       │       ├── (dashboard)/
│       │       │   ├── tenants/        # Tenant management
│       │       │   ├── billing/        # SaaS billing
│       │       │   ├── analytics/      # Platform-wide analytics
│       │       │   ├── support/        # Support tickets
│       │       │   └── settings/       # Platform settings
│       │       └── api/
│       └── package.json
│
├── workers/                            # Cloudflare Workers API
│   ├── src/
│   │   ├── index.ts                    # Hono app entry point
│   │   ├── config/
│   │   │   ├── env.ts                  # Environment bindings type
│   │   │   ├── supabase.ts             # Supabase client factory
│   │   │   └── redis.ts               # Upstash Redis client
│   │   ├── middleware/
│   │   │   ├── auth.middleware.ts       # JWT verification
│   │   │   ├── tenant.middleware.ts     # Tenant resolution
│   │   │   ├── rbac.middleware.ts       # Role-based access
│   │   │   └── rate-limit.middleware.ts # Per-IP + Per-tenant
│   │   ├── modules/                    # Feature modules
│   │   │   ├── auth/
│   │   │   ├── attendance/
│   │   │   ├── academic/
│   │   │   ├── timetable/
│   │   │   ├── fees/
│   │   │   ├── assignments/
│   │   │   │   ├── assignment.routes.ts
│   │   │   │   ├── assignment.controller.ts
│   │   │   │   ├── assignment.service.ts
│   │   │   │   └── assignment.schema.ts  # Zod validation
│   │   │   ├── chatroom/
│   │   │   ├── meetings/
│   │   │   ├── hostel/
│   │   │   ├── inventory/
│   │   │   ├── placement/
│   │   │   ├── internship/
│   │   │   ├── alumni/
│   │   │   ├── grievance/
│   │   │   ├── events/
│   │   │   ├── polls/
│   │   │   ├── chatbot/
│   │   │   ├── parent-portal/
│   │   │   ├── notification/
│   │   │   ├── report/
│   │   │   ├── tenant/
│   │   │   └── white-label/
│   │   ├── shared/
│   │   │   ├── utils/
│   │   │   └── types/
│   │   └── scheduled/                  # Cron Triggers
│   │       ├── attendance-report.ts
│   │       ├── fee-reminder.ts
│   │       ├── sla-escalation.ts       # Grievance SLA
│   │       └── ai-batch-trigger.ts
│   ├── wrangler.toml                   # Cloudflare config
│   ├── tsconfig.json
│   └── package.json
│
├── ai-service/                         # Python AI/ML Service
│   ├── app/
│   │   ├── main.py                     # FastAPI entry
│   │   ├── models/
│   │   │   ├── attendance_predictor.py
│   │   │   ├── dropout_risk.py
│   │   │   ├── performance_analyzer.py
│   │   │   ├── chatbot_intent.py       # Intent classification
│   │   │   └── learning_path.py        # Elective recommendations
│   │   ├── routes/
│   │   └── services/
│   ├── requirements.txt
│   └── Dockerfile
│
├── supabase/                           # Supabase Configuration
│   ├── migrations/                     # SQL migrations (chronological)
│   │   ├── 001_tenants.sql
│   │   ├── 002_users.sql
│   │   ├── 003_academic_structure.sql
│   │   ├── 004_attendance.sql
│   │   ├── 005_fees_payments.sql
│   │   ├── 006_assignments.sql
│   │   ├── 007_chatrooms.sql
│   │   ├── 008_meetings.sql
│   │   ├── 009_timetable.sql
│   │   ├── 010_notifications.sql
│   │   ├── 011_results.sql
│   │   ├── 012_rls_policies.sql
│   │   ├── 013_academic_calendar.sql
│   │   ├── 014_exam_timetable.sql
│   │   ├── 015_study_materials.sql
│   │   ├── 016_research_papers.sql
│   │   ├── 017_campus_events.sql
│   │   ├── 018_hostel_management.sql
│   │   ├── 019_inventory.sql
│   │   ├── 020_placement.sql
│   │   ├── 021_internship.sql
│   │   ├── 022_alumni.sql
│   │   ├── 023_chatbot.sql
│   │   ├── 024_grievance.sql
│   │   ├── 025_polls_surveys.sql
│   │   └── 026_parent_portal.sql
│   ├── seed.sql                        # Development seed data
│   └── config.toml                     # Supabase local config
│
├── shared/                             # Shared packages
│   ├── types/                          # Shared TypeScript types
│   └── utils/                          # Shared utilities
│
├── .github/
│   └── workflows/
│       ├── ci.yml                      # Lint, type-check, test
│       ├── deploy-workers.yml          # Deploy Workers to Cloudflare
│       └── deploy-admin.yml            # Deploy admin to Pages/Vercel
│
├── .env.example                        # Template for env vars
├── README.md
├── turbo.json                          # Turborepo monorepo config
└── package.json
```

---

## 1.10 Role-Based Access Control (RBAC) – Complete Matrix

### Role Definitions

```
┌──────────────────────────────────────────────────────────────────────┐
│   ROLE DEFINITIONS                                                    │
│                                                                      │
│   🎓 STUDENT (role: "student")                                       │
│   ├── Can only access their own data (attendance, fees, results)    │
│   ├── Submit assignments, join chatrooms, attend meetings           │
│   ├── Raise grievances, apply for hostel leave                      │
│   └── Use AI chatbot for queries                                    │
│                                                                      │
│   👩‍🏫 FACULTY (role: "faculty")                                       │
│   ├── Manage assigned classes (attendance, assignments)             │
│   ├── Create study materials, schedule meetings                     │
│   ├── View students in their classes only                           │
│   ├── Upload research papers, respond in chatrooms                  │
│   └── Cannot access other faculty's classes                         │
│                                                                      │
│   👨‍💼 HOD – Head of Department (role: "hod")                          │
│   ├── All faculty permissions for their department                  │
│   ├── View department-wide analytics                                │
│   ├── Approve purchase requests, view grievances                    │
│   └── Faculty performance overview for their department             │
│                                                                      │
│   📋 COORDINATOR (role: "coordinator")                               │
│   ├── Section-level management (like a class teacher)               │
│   ├── View section attendance, send notices                         │
│   ├── Coordinate between faculty and admin for section              │
│   └── Cannot modify grades or fees                                  │
│                                                                      │
│   ⚙️ ADMIN (role: "admin")                                           │
│   ├── Full access to ALL data within their tenant/institution       │
│   ├── Manage users, configure settings, view all reports            │
│   ├── Cannot access other institutions' data                        │
│   ├── Manage placements, hostel, inventory, events                  │
│   └── White-label configuration for their institution               │
│                                                                      │
│   🔑 SUPER ADMIN (role: "super_admin")                               │
│   ├── Platform-level access (CampusSphere team only)                │
│   ├── Create/manage tenants, manage SaaS billing                    │
│   ├── View cross-tenant analytics, platform health                  │
│   ├── Bypasses RLS for platform-level operations                    │
│   └── Cannot access tenant's student/faculty data directly          │
│                                                                      │
│   👨‍👩‍👧 PARENT (role: "parent")                                         │
│   ├── Read-only access to their child's data                        │
│   ├── View attendance, results, fee status, assignments             │
│   ├── Receive notifications (push, SMS, email)                      │
│   └── Cannot modify any data                                        │
│                                                                      │
│   🛡️ WARDEN (role: "warden")                                        │
│   ├── Hostel-specific permissions                                   │
│   ├── Approve leave, manage visitors, view complaints               │
│   └── View hostel students under their block                        │
└──────────────────────────────────────────────────────────────────────┘
```

### RBAC Permission Matrix

```
┌────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             RBAC – COMPLETE PERMISSION MATRIX                                   │
├───────────────────┬────────┬────────┬────────┬────────┬────────┬─────────┬────────┬────────────┤
│ Feature           │Student │Faculty │ HOD    │ Co-ord │ Admin  │Super Adm│ Parent │  Warden    │
├───────────────────┼────────┼────────┼────────┼────────┼────────┼─────────┼────────┼────────────┤
│ Mark Attendance   │✓(self) │✓(class)│✓(dept) │✓(sec)  │✓(all)  │ ✗       │ ✗      │ ✗          │
│ View Attendance   │✓(self) │✓(class)│✓(dept) │✓(sec)  │✓(all)  │✓(all)   │✓(child)│ ✗          │
│ Edit Attendance   │ ✗      │✓(class)│✓(dept) │✓(sec)  │✓(all)  │ ✗       │ ✗      │ ✗          │
│ View Timetable    │✓(own)  │✓(own)  │✓(dept) │✓(sec)  │✓(all)  │ ✗       │✓(child)│ ✗          │
│ Create Assignments│ ✗      │✓(class)│✓(dept) │ ✗      │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Submit Assignments│✓(self) │ ✗      │ ✗      │ ✗      │ ✗      │ ✗       │ ✗      │ ✗          │
│ Verify Submissions│ ✗      │✓(class)│✓(dept) │ ✗      │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Class Chatroom    │✓(own)  │✓(own)  │✓(dept) │✓(sec)  │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Schedule Meetings │ ✗      │✓(class)│✓(dept) │✓(sec)  │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Join Meetings     │✓(own)  │✓(own)  │✓(dept) │✓(sec)  │✓(all)  │ ✗       │ ✗      │ ✗          │
│ View Results      │✓(self) │✓(class)│✓(dept) │✓(sec)  │✓(all)  │✓(all)   │✓(child)│ ✗          │
│ Enter Grades      │ ✗      │✓(class)│✓(dept) │ ✗      │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Pay Fees          │✓(self) │ ✗      │ ✗      │ ✗      │ ✗      │ ✗       │✓(child)│ ✗          │
│ View Fee Status   │✓(self) │ ✗      │✓(dept) │ ✗      │✓(all)  │✓(all)   │✓(child)│ ✗          │
│ Upload Materials  │ ✗      │✓(class)│✓(dept) │ ✗      │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Download Materials│✓(own)  │✓(dept) │✓(dept) │✓(sec)  │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Raise Grievance   │✓       │✓       │ ✗      │ ✗      │ ✗      │ ✗       │ ✗      │ ✗          │
│ Resolve Grievance │ ✗      │ ✗      │✓(dept) │ ✗      │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Apply Hostel Leave│✓(self) │ ✗      │ ✗      │ ✗      │ ✗      │ ✗       │ ✗      │ ✗          │
│ Approve Leaves    │ ✗      │ ✗      │ ✗      │ ✗      │ ✗      │ ✗       │ ✗      │✓(block)    │
│ Manage Placement  │ ✗      │ ✗      │ ✗      │ ✗      │✓(all)  │ ✗       │ ✗      │ ✗          │
│ Apply for Drive   │✓(self) │ ✗      │ ✗      │ ✗      │ ✗      │ ✗       │ ✗      │ ✗          │
│ Send Notices      │ ✗      │✓(class)│✓(dept) │✓(sec)  │✓(all)  │✓(all)   │ ✗      │✓(block)    │
│ AI Insights       │ ✗      │✓(class)│✓(dept) │✓(sec)  │✓(all)  │✓(platf) │ ✗      │ ✗          │
│ AI Chatbot        │✓       │✓       │✓       │✓       │✓       │ ✗       │ ✗      │ ✗          │
│ Manage Users      │ ✗      │ ✗      │ ✗      │ ✗      │✓(all)  │✓(all)   │ ✗      │ ✗          │
│ White-Label Config│ ✗      │ ✗      │ ✗      │ ✗      │✓(own)  │✓(all)   │ ✗      │ ✗          │
│ Manage Tenants    │ ✗      │ ✗      │ ✗      │ ✗      │ ✗      │✓(all)   │ ✗      │ ✗          │
│ Platform Billing  │ ✗      │ ✗      │ ✗      │ ✗      │ ✗      │✓(all)   │ ✗      │ ✗          │
└───────────────────┴────────┴────────┴────────┴────────┴────────┴─────────┴────────┴────────────┘

Legend: ✓ = allowed, ✗ = denied
Scope: (self) = own data, (class) = assigned classes, (dept) = department,
       (sec) = section, (all) = institution-wide, (platf) = platform-wide
       (child) = linked child's data, (block) = hostel block
```

---

## 1.11 Core Feature Modules Overview

### Module 1: Assignment Management System

```
┌──────────────────────────────────────────────────────────────────────┐
│              ASSIGNMENT MANAGEMENT – FLOW                             │
│                                                                      │
│  FACULTY CREATES ASSIGNMENT                                          │
│  ┌──────────────────────────────────────────────────┐               │
│  │  Title: "Database Normalization Exercise"        │               │
│  │  Subject: DBMS (CS301)                           │               │
│  │  Class: 3rd Sem CSE-A                            │               │
│  │  Type: ○ Question  ● File Upload  ○ Both         │               │
│  │  Description: [Rich text editor]                 │               │
│  │  Attachments: [Upload PDF/DOC to R2]            │               │
│  │  Deadline: Feb 28, 2026 11:59 PM IST            │               │
│  │  Max Marks: 20                                   │               │
│  │  Late Submission: ☑ Allow (with penalty)         │               │
│  │  Late Penalty: -2 marks/day                      │               │
│  │  [CREATE ASSIGNMENT]                              │               │
│  └──────────────────────────────────────────────────┘               │
│                                                                      │
│  → Notification sent to all CSE-A students (Push + In-App)          │
│  → Assignment appears on student dashboard                           │
│  → Deadline countdown visible on student app                        │
│                                                                      │
│  STUDENT SUBMITS                                                     │
│  ┌──────────────────────────────────────────────────┐               │
│  │  Upload files (PDF, DOC, ZIP, Images)            │               │
│  │  OR type answer in text editor                    │               │
│  │  [SUBMIT] → Status changes to "Submitted"       │               │
│  │  → Can resubmit until deadline                    │               │
│  └──────────────────────────────────────────────────┘               │
│                                                                      │
│  FACULTY REVIEWS & VERIFIES                                          │
│  ┌──────────────────────────────────────────────────┐               │
│  │  Submission Dashboard:                            │               │
│  │  Total: 52 | Submitted: 38 | Pending: 14        │               │
│  │                                                  │               │
│  │  Roll   Name          Status    File    Action   │               │
│  │  001    Arun K        ✅ Done   📄 PDF  [Review]  │               │
│  │  002    Bharathi S    ✅ Done   📄 DOC  [Review]  │               │
│  │  003    Chandra M     ⏳ Late   📄 PDF  [Review]  │               │
│  │  004    Deepika R     ❌ Missing  —    [Remind]  │               │
│  │                                                  │               │
│  │  [Mark as Verified] [Request Resubmission]       │               │
│  │  [Download All Submissions as ZIP]               │               │
│  └──────────────────────────────────────────────────┘               │
└──────────────────────────────────────────────────────────────────────┘
```

### Module 2: Class Chatroom System

```
┌──────────────────────────────────────────────────────────────────────┐
│              CLASS CHATROOM – ARCHITECTURE                            │
│                                                                      │
│  Chatroom Types:                                                     │
│  ┌─────────────────────────────────────────────────┐                │
│  │  📚 Subject Chatroom                            │                │
│  │     • CS301-DBMS-3A (DBMS class, 3rd Sem CSE-A) │                │
│  │     • Members: 52 students + Prof. Lakshmi       │                │
│  │     • Purpose: Subject doubts, materials sharing │                │
│  │                                                  │                │
│  │  🏫 Section Chatroom                             │                │
│  │     • CSE-3A-General (General section chat)      │                │
│  │     • Members: 52 students + Coordinator + Staff │                │
│  │     • Purpose: Announcements, general discussions│                │
│  │                                                  │                │
│  │  🎓 Department Chatroom                          │                │
│  │     • CSE-Announcements (One-way, admin only)    │                │
│  │     • CSE-Discussion (Two-way)                   │                │
│  │     • Members: All CSE students + faculty        │                │
│  └─────────────────────────────────────────────────┘                │
│                                                                      │
│  Access Rules:                                                       │
│  ├── Only students of that class/section can access                 │
│  ├── Class coordinators have moderator access                        │
│  ├── Teaching staff assigned to that section                         │
│  ├── HOD has read access to all dept chatrooms                       │
│  └── Admin can monitor all chatrooms                                 │
│                                                                      │
│  Powered by: Supabase Realtime (WebSocket channels)                 │
│  Features: Text, file sharing, reply threads, pin messages,         │
│            @mentions, read receipts                                   │
└──────────────────────────────────────────────────────────────────────┘
```

### Module 3: Live Meeting System

```
┌──────────────────────────────────────────────────────────────────────┐
│              LIVE MEETING SYSTEM                                      │
│                                                                      │
│  Powered by: 100ms WebRTC SDK (or LiveKit)                          │
│                                                                      │
│  Meeting Types:                                                      │
│  ├── 📹 Live Class (faculty → students, screen share)               │
│  ├── 📋 Doubt Session (interactive, students can speak)             │
│  ├── 👥 Department Meeting (HOD + faculty)                          │
│  └── 📢 All-Hands (Admin → entire institution)                      │
│                                                                      │
│  Features:                                                           │
│  ├── Video/Audio toggle                                              │
│  ├── Screen sharing                                                  │
│  ├── Chat during meeting                                             │
│  ├── Hand raise                                                      │
│  ├── Attendance auto-marked for participants                         │
│  ├── Whiteboard (drawing)                                            │
│  └── Recordings stored in R2 per tenant                              │
│                                                                      │
│  Flow:                                                               │
│  Faculty schedules → Push notification → "Join" button activates    │
│  → Meeting starts → Auto-record → Recording available after         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.12 Extended Platform Modules (Fully Documented)

The following 17 modules are fully documented with database schemas, API endpoints, workflows, and ASCII wireframes in Parts 9-13:

```
┌──────────────────────────────────────────────────────────────────────┐
│         EXTENDED MODULES – FULLY DOCUMENTED IN PARTS 9-13             │
│                                                                      │
│  Part 9: Academic Enhancement                                        │
│  ├── 📅 Academic Calendar                                           │
│  │   Institution events, holidays, exam schedules, cultural fests   │
│  │   Multiple views (month/week/day), push reminders, iCal export   │
│  ├── 📝 Exam Timetable                                              │
│  │   Internal/semester/supplementary exams, hall ticket generation   │
│  │   Seating arrangements, invigilation duty, conflict detection    │
│  ├── 📚 Study Materials                                             │
│  │   Faculty uploads organized by course + unit, student bookmarks  │
│  │   Offline downloads, new material notifications                  │
│  └── 📄 Research Paper Repository                                   │
│      Upload, DOI linking, citation tracking, search, analytics      │
│                                                                      │
│  Part 10: Campus Life & Governance                                   │
│  ├── 🎪 Campus Event Ticketing                                     │
│  │   Free/paid events, approval workflow, QR check-in, certificates │
│  │   Feedback surveys, attendance analytics                         │
│  ├── 📋 Student Grievance Portal                                   │
│  │   Anonymous complaints, auto-categorization, SLA timers          │
│  │   Admin assignment, escalation paths, resolution feedback        │
│  ├── 📊 Campus Polls & Surveys                                     │
│  │   Single/multiple choice, rating, text questions                 │
│  │   Anonymous responses, targeting by dept/year/section            │
│  └── 👨‍👩‍👧 Parent Portal                                               │
│      Read-only child monitoring, AI risk alerts, multi-child        │
│      Monthly report generation, notification preferences            │
│                                                                      │
│  Part 11: Campus Operations                                         │
│  ├── 🏠 Hostel Management                                          │
│  │   Room allocation, mess menu + feedback, visitor management      │
│  │   Leave/gate pass (QR), maintenance complaints, laundry          │
│  └── 📦 Inventory Management                                       │
│      Asset registry with QR tags, check-out/in, depreciation       │
│      Maintenance scheduling, procurement workflow (3-quote system)  │
│                                                                      │
│  Part 12: Career & Alumni                                            │
│  ├── 💼 Placement Portal                                           │
│  │   Company profiles, drive scheduling, multi-round selection      │
│  │   Offer management, NAAC-ready placement statistics              │
│  ├── 📋 Internship Tracker                                         │
│  │   Hour logging, progress reports, faculty review                 │
│  │   AICTE compliance (240 hrs minimum), completion certificates    │
│  └── 🎓 Alumni Network                                             │
│      Directory, mentorship matching, job referral board             │
│      Donation portal (Razorpay), event invitations                  │
│                                                                      │
│  Part 13: Advanced AI & Analytics                                    │
│  ├── 🤖 AI Chatbot (Campus Assistant)                              │
│  │   13 intent types, NLP classification, database query resolver   │
│  │   Conversation history, FAQ knowledge base                       │
│  ├── 📖 Learning Path Recommendations                              │
│  │   Elective suggestions, skill gap analysis, career alignment     │
│  │   Collaborative + content-based filtering                        │
│  ├── 📊 Faculty Performance Dashboard                              │
│  │   Teaching hours, research output, student feedback scores       │
│  │   Assignment verification speed, engagement metrics              │
│  └── 🏛️ Departmental Comparison Analytics                          │
│      Cross-department benchmarking (attendance, results, placement) │
│      NAAC/NBA-ready report export, AI-generated insights            │
│                                                                      │
│  Total Platform Modules: 30+                                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.13 Indian Education System Compatibility Matrix

CampusSphere is built **India-first**. Every feature is designed to work with Indian education regulations, boards, payment systems, and infrastructure constraints.

```
┌──────────────────────────────────────────────────────────────────────────────┐
│              INDIAN EDUCATION SYSTEM COMPATIBILITY                           │
├──────────────────────┬───────────────────────────────────────────────────────┤
│ Feature              │ Implementation Details                                │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Board Support        │ CBSE, ICSE, State Boards (all 28 states + 8 UTs),   │
│                      │ NIOS, IB, Cambridge, IGCSE                            │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Higher Ed Compat.    │ UGC, AICTE, NAAC, NBA-compliant report formats       │
│                      │ AISHE data export, NIRF parameter tracking            │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Grading Systems      │ CGPA (10-point), Percentage, Grade (A-F),            │
│                      │ Semester system, Annual system, CBCS,                 │
│                      │ Internal + External split (e.g., 40+60)              │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Academic Calendar    │ Configurable: June-May / April-March / Aug-Jul       │
│                      │ Semester breaks, exam periods, festivals,             │
│                      │ Gazetted holiday auto-import                          │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Languages            │ English, Hindi + 12 regional languages:               │
│                      │ Tamil, Telugu, Kannada, Malayalam, Marathi,            │
│                      │ Bengali, Gujarati, Punjabi, Odia, Assamese,           │
│                      │ Urdu (RTL support ready), Sanskrit                    │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Fee Structure        │ Tuition, Hostel, Transport, Lab, Library,            │
│                      │ Exam fees, Scholarship deductions, EWS waivers       │
│                      │ Installment plans, Late fee calculation,              │
│                      │ Government fee caps (applies to aided colleges)       │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Payment Methods      │ UPI (GPay, PhonePe, Paytm, BHIM), Debit Card,       │
│                      │ Credit Card, Net Banking, Wallets, NEFT/RTGS,        │
│                      │ Bank Challan (offline), DD acceptance                 │
│                      │ Gateway configurable per institution                  │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Attendance Rules     │ 75% minimum (UGC mandate), Configurable per          │
│                      │ institution, Medical leave adjustment,                │
│                      │ OD (On Duty) marking, Condonation request             │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ SMS Compliance       │ DLT-registered templates (TRAI mandate since 2021),  │
│                      │ Entity ID + Template ID for every SMS,                │
│                      │ Content template pre-approved                         │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ GST Compliance       │ 18% GST on SaaS subscription (B2B),                  │
│                      │ GST invoice generation, HSN code: 998314,            │
│                      │ GSTIN validation for institutional billing            │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Data Residency       │ Supabase hosted in Mumbai/Singapore region,           │
│                      │ Cloudflare R2 edge-cached globally,                  │
│                      │ Compliant with IT Act 2000, DPDP Act 2023            │
│                      │ Student data never leaves Indian jurisdiction         │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Accessibility        │ WCAG 2.1 AA, Screen reader support,                  │
│                      │ High contrast mode, Font scaling,                    │
│                      │ GIGW (Guidelines for Indian Govt Websites) aware      │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Low Bandwidth        │ < 200KB initial app load (Flutter AOT compiled),     │
│                      │ Offline mode for attendance + chatrooms,              │
│                      │ Image compression on upload (WebP),                   │
│                      │ API response gzip compression                         │
├──────────────────────┼───────────────────────────────────────────────────────┤
│ Device Support       │ Android 6.0+ (covers 99% of Indian smartphones),     │
│                      │ iOS 14+, Web (Chrome, Firefox, Safari, Edge)          │
│                      │ Works on devices with 2GB RAM                         │
└──────────────────────┴───────────────────────────────────────────────────────┘
```

---

## 1.14 Environment Variables & Secrets Registry

All secrets are stored in **Cloudflare Workers Secrets** (encrypted at rest) and loaded via the Hono `Env` type.

```
┌──────────────────────────────────────────────────────────────────────┐
│   ENVIRONMENT VARIABLES & SECRETS REGISTRY                           │
│                                                                      │
│   ═══ Supabase ═══                                                   │
│   SUPABASE_URL           = https://xxx.supabase.co                  │
│   SUPABASE_ANON_KEY      = eyJ... (public, row-level access)        │
│   SUPABASE_SERVICE_KEY   = eyJ... (admin, bypasses RLS) ⚠️ SECRET  │
│                                                                      │
│   ═══ Authentication ═══                                             │
│   JWT_SECRET             = 64-char random string ⚠️ SECRET          │
│   JWT_ACCESS_EXPIRY      = 15m                                       │
│   JWT_REFRESH_EXPIRY     = 7d                                        │
│   OTP_SECRET             = 32-char HMAC key ⚠️ SECRET               │
│   OTP_EXPIRY             = 300  (5 minutes, in seconds)             │
│                                                                      │
│   ═══ Upstash Redis ═══                                              │
│   UPSTASH_REDIS_URL      = https://xxx.upstash.io                   │
│   UPSTASH_REDIS_TOKEN    = xxx ⚠️ SECRET                            │
│                                                                      │
│   ═══ Cloudflare ═══                                                 │
│   R2_BUCKET_NAME         = campussphere-files                        │
│   R2_ACCESS_KEY          = xxx ⚠️ SECRET                            │
│   R2_SECRET_KEY          = xxx ⚠️ SECRET                            │
│   R2_PUBLIC_URL          = https://files.campussphere.in             │
│   KV_NAMESPACE_ID        = xxx                                       │
│                                                                      │
│   ═══ Payment Gateways ═══                                           │
│   RAZORPAY_KEY_ID        = rzp_live_xxx ⚠️ SECRET                   │
│   RAZORPAY_KEY_SECRET    = xxx ⚠️ SECRET                            │
│   RAZORPAY_WEBHOOK_SECRET= xxx ⚠️ SECRET                            │
│   (Other gateways stored per-tenant in encrypted DB columns)        │
│                                                                      │
│   ═══ Communication ═══                                              │
│   RESEND_API_KEY         = re_xxx ⚠️ SECRET                         │
│   RESEND_FROM_EMAIL      = noreply@campussphere.in                  │
│   MSG91_AUTH_KEY         = xxx ⚠️ SECRET                             │
│   MSG91_SENDER_ID        = CMPSPH                                   │
│   MSG91_DLT_ENTITY_ID    = 1234567890 (TRAI DLT registered)        │
│   FCM_SERVER_KEY         = xxx ⚠️ SECRET                            │
│   FCM_PROJECT_ID         = campussphere-prod                        │
│                                                                      │
│   ═══ Video Meetings ═══                                             │
│   HMS_ACCESS_KEY         = xxx ⚠️ SECRET                            │
│   HMS_SECRET             = xxx ⚠️ SECRET                            │
│   HMS_TEMPLATE_ID        = xxx                                       │
│                                                                      │
│   ═══ AI Service ═══                                                 │
│   AI_SERVICE_URL         = https://ai.campussphere.in               │
│   AI_SERVICE_API_KEY     = xxx ⚠️ SECRET                            │
│                                                                      │
│   ═══ Monitoring ═══                                                 │
│   SENTRY_DSN             = https://xxx@sentry.io/xxx                │
│   LOGFLARE_API_KEY       = xxx ⚠️ SECRET                            │
│   LOGFLARE_SOURCE_ID     = xxx                                       │
│                                                                      │
│   ═══ App Config ═══                                                 │
│   NODE_ENV               = production                                │
│   API_VERSION            = v1                                        │
│   CORS_ORIGINS           = *.campussphere.in,localhost:3000          │
│   RATE_LIMIT_MAX         = 100 (requests per minute per IP)         │
│   RATE_LIMIT_WINDOW      = 60 (seconds)                              │
│                                                                      │
│   Security Rules:                                                    │
│   ├── ⚠️ SECRET items are NEVER in source code or git               │
│   ├── Stored in Cloudflare Workers Secrets (encrypted at rest)      │
│   ├── Per-tenant gateway keys stored in Supabase (encrypted column) │
│   ├── .env.example contains only key names, never values            │
│   └── Rotation policy: 90 days for API keys, 180 days for secrets   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.15 Performance & Scalability Targets

```
┌──────────────────────────────────────────────────────────────────────┐
│   PERFORMANCE & SCALABILITY TARGETS                                  │
│                                                                      │
│   API Response Time:                                                 │
│   ├── P50 (median): < 50ms                                          │
│   ├── P95: < 150ms                                                   │
│   ├── P99: < 300ms                                                   │
│   └── Timeout: 10 seconds (hard limit)                              │
│                                                                      │
│   Mobile App:                                                        │
│   ├── Cold start: < 3 seconds on mid-range Android phone            │
│   ├── Warm start: < 1 second                                        │
│   ├── APK size: < 25MB                                               │
│   ├── App bundle: < 15MB (Google Play AAB)                           │
│   └── Offline queue: up to 100 items (before force-sync)            │
│                                                                      │
│   Database:                                                          │
│   ├── Max concurrent connections: 500 (Supabase Pro plan)           │
│   ├── Database size per tenant: < 5GB average                       │
│   ├── Query execution: < 100ms for indexed queries                  │
│   ├── Full-text search: < 200ms for student/faculty lookup          │
│   └── Backup RPO: 5 minutes (PITR)                                  │
│                                                                      │
│   Concurrency:                                                       │
│   ├── Cloudflare Workers: handles 100K+ req/sec globally            │
│   ├── Supabase Realtime: 10,000+ concurrent WebSocket connections   │
│   ├── 100ms WebRTC: 1,000 participants per room                    │
│   └── Upstash Redis: 10,000 commands/second                        │
│                                                                      │
│   Scale Targets (by year):                                           │
│   ├── Year 1: 50 tenants, 100K students, 5K faculty                │
│   ├── Year 2: 200 tenants, 400K students, 20K faculty              │
│   ├── Year 3: 500 tenants, 1M students, 50K faculty                │
│   └── Infrastructure auto-scales (no capacity planning needed)      │
│                                                                      │
│   File Storage:                                                      │
│   ├── Max file upload: 25MB per file (assignments, materials)       │
│   ├── Profile photo: auto-compressed to 200KB WebP                  │
│   ├── R2 storage per tenant: 50GB (Starter), unlimited (Enterprise) │
│   └── CDN cache TTL: 1 hour for assets, 5 min for profile images   │
│                                                                      │
│   Availability:                                                      │
│   ├── Target: 99.9% uptime (< 8.76 hours downtime/year)            │
│   ├── Cloudflare Workers: 99.99% SLA                                │
│   ├── Supabase Pro: 99.9% SLA                                       │
│   ├── Maintenance window: Sunday 2-4 AM IST (if needed)             │
│   └── Zero-downtime deployments via Cloudflare blue/green           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.16 Glossary of Terms

This glossary defines every key term used throughout the CampusSphere roadmap, ensuring clarity for both human developers and AI agents interpreting this documentation.

| Term | Definition |
|---|---|
| **Tenant** | An institution (college/university/school) registered on CampusSphere. Each tenant has isolated data. |
| **RLS** | Row-Level Security. PostgreSQL feature that automatically filters rows based on the current user's context. |
| **White-Label** | The ability to rebrand the platform with an institution's name, logo, colors, and domain. |
| **Edge** | Computing at the network edge (close to the user). Cloudflare Workers run at 300+ edge locations worldwide. |
| **Worker** | A Cloudflare Worker – a V8 isolate that runs JavaScript/TypeScript at the edge with no cold starts. |
| **Hono** | A lightweight, fast web framework designed for Cloudflare Workers (like Express, but for edge). |
| **Supabase** | An open-source Firebase alternative providing PostgreSQL, Auth, Realtime, and Storage. |
| **R2** | Cloudflare's S3-compatible object storage with zero egress fees. Used for files and documents. |
| **KV** | Cloudflare Key-Value store. Used for edge-cached tenant configs and feature flags. |
| **Upstash Redis** | Serverless Redis service. Used for caching, rate limiting, and token blacklisting. |
| **JWT** | JSON Web Token. Used for stateless authentication. Contains user_id, role, and tenant_id. |
| **RBAC** | Role-Based Access Control. Permissions are granted based on the user's role (student, faculty, etc.). |
| **DLT** | Distributed Ledger Technology (TRAI). Required registration for sending SMS in India since 2021. |
| **UPI** | Unified Payments Interface. India's instant payment system (Google Pay, PhonePe, Paytm). |
| **OD** | On Duty. When a student is absent from class for official work (event, sports, etc.). |
| **CGPA** | Cumulative Grade Point Average. Aggregate academic performance score (typically 10-point scale). |
| **CBCS** | Choice-Based Credit System. UGC-mandated system allowing students to choose elective courses. |
| **NAAC** | National Assessment and Accreditation Council. Accredits higher education institutions in India. |
| **NBA** | National Board of Accreditation. Accredits specific programs (mainly engineering). |
| **AICTE** | All India Council for Technical Education. Regulatory body for technical education. |
| **AISHE** | All India Survey on Higher Education. Annual data submission required by Ministry of Education. |
| **NIRF** | National Institutional Ranking Framework. Uses institution data for national rankings. |
| **DPDP Act** | Digital Personal Data Protection Act 2023. India's data privacy law (like GDPR). |
| **IST** | Indian Standard Time (UTC+5:30). All timestamps in CampusSphere default to IST. |
| **FCM** | Firebase Cloud Messaging. Google's free push notification service for Android and iOS. |
| **100ms** | WebRTC-based video conferencing SDK. Used for live classes and meetings. |
| **Riverpod** | A state management library for Flutter/Dart. Successor to Provider. |
| **GoRouter** | A declarative routing library for Flutter with deep link support. |
| **Dio** | An HTTP client for Dart/Flutter with interceptor support. |
| **shadcn/ui** | A component library for React using Tailwind CSS. Copy-paste, customizable components. |
| **Drizzle ORM** | A TypeScript ORM for SQL databases. Type-safe, lightweight, edge-compatible. |
| **Zod** | A TypeScript-first schema validation library. Used for API request/response validation. |
| **Cron Trigger** | Cloudflare's scheduled job system. Runs code on a schedule (e.g., daily at 6 AM IST). |
| **PITR** | Point-in-Time Recovery. Database backup feature allowing restore to any moment in time. |
| **WAF** | Web Application Firewall. Protects against OWASP Top 10 vulnerabilities (XSS, SQLi, etc.). |
| **SLA** | Service Level Agreement. Defines expected response/resolution times (used in grievance module). |
| **EWS** | Economically Weaker Section. Government category eligible for fee waivers. |
| **GIGW** | Guidelines for Indian Government Websites. Web accessibility standard for government of India sites. |

---

## Complete Document Index

```
┌──────────────────────────────────────────────────────────────────────┐
│   CAMPUSSPHERE – COMPLETE ROADMAP INDEX (13 Parts)                   │
│                                                                      │
│   Part 1:  Vision, Architecture & Tech Stack (THIS DOCUMENT)        │
│   Part 2:  Database Schema & API Design                              │
│   Part 3:  Core Modules (Attendance, Dashboard, Timetable)          │
│   Part 4:  Fee Management, Payments & White-Label Engine             │
│   Part 5:  AI/ML Analytics Layer & Predictive Engine                │
│   Part 6:  Complete ASCII UI Wireframes                              │
│   Part 7:  Deployment, DevOps, Security & Compliance                 │
│   Part 8:  Business Model, Monetization & Timeline                   │
│   Part 9:  Academic Enhancement (Calendar, Exams, Materials, Papers)│
│   Part 10: Campus Life & Governance (Events, Grievance, Polls)      │
│   Part 11: Campus Operations (Hostel, Inventory)                     │
│   Part 12: Career & Alumni (Placement, Internship, Alumni)          │
│   Part 13: Advanced AI & Analytics (Chatbot, Learning, Performance) │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.17 Security Architecture

### Defense-in-Depth Layers

```
┌──────────────────────────────────────────────────────────────────────┐
│   SECURITY – DEFENSE-IN-DEPTH (7 LAYERS)                            │
│                                                                      │
│   Layer 1: Cloudflare Edge (Network)                                 │
│   ├── DDoS mitigation (layer 3/4/7, automatic)                     │
│   ├── WAF rules (OWASP Top 10: SQLi, XSS, CSRF, RCE)              │
│   ├── Bot management (block scrapers, credential stuffing)          │
│   ├── Rate limiting: 100 req/min per IP, 1000 req/min per tenant   │
│   ├── Geo-blocking (optional: restrict to India-only)               │
│   └── SSL/TLS 1.3 enforced (no plaintext traffic)                  │
│                                                                      │
│   Layer 2: Application (Hono Worker)                                 │
│   ├── CORS: strict origin whitelist per tenant                      │
│   ├── CSRF: SameSite=Strict cookies, Origin header check            │
│   ├── Input validation: Zod schemas on every endpoint               │
│   ├── SQL injection: parameterized queries only (never raw SQL)     │
│   ├── XSS: Content-Security-Policy headers, sanitized output       │
│   ├── File upload: type validation, size limits, virus scan         │
│   └── Security headers: HSTS, X-Frame-Options, X-Content-Type     │
│                                                                      │
│   Layer 3: Authentication                                            │
│   ├── JWT with HMAC-SHA256: access (15m) + refresh (7d)            │
│   ├── Refresh token rotation (one-time use, stored in Redis)        │
│   ├── Token blacklisting on logout (Redis SET, check on every req) │
│   ├── OTP via SMS/email for login (6-digit, 5-min expiry)          │
│   ├── Biometric unlock (optional, Flutter local_auth package)       │
│   ├── Multi-device management (see all sessions, revoke remotely)  │
│   └── Account lockout after 5 failed attempts (30-min cooldown)    │
│                                                                      │
│   Layer 4: Authorization (RBAC)                                      │
│   ├── Role-based middleware on every route                           │
│   ├── Scope-based: students see only their data                     │
│   ├── Hierarchy: student < coordinator < faculty < HOD < admin      │
│   ├── API key scoping for third-party integrations                  │
│   └── Audit log: who did what, when, from where                    │
│                                                                      │
│   Layer 5: Data Isolation (Multi-Tenancy)                            │
│   ├── PostgreSQL RLS on EVERY table with tenant_id                  │
│   ├── SET app.tenant_id before any query execution                  │
│   ├── RLS cannot be bypassed from application layer                 │
│   ├── Cross-tenant data access is architecturally impossible        │
│   └── Super Admin uses separate service role (bypasses RLS)         │
│                                                                      │
│   Layer 6: Data Protection                                           │
│   ├── Encryption at rest: Supabase (AES-256), R2 (AES-256)        │
│   ├── Encryption in transit: TLS 1.3 everywhere                    │
│   ├── PII fields: hashed (Aadhaar), encrypted (phone, email)       │
│   ├── Password hashing: bcrypt (12 rounds)                          │
│   ├── DPDP Act compliance: consent tracking, data portability       │
│   └── Right to erasure: soft delete → hard delete after 30 days    │
│                                                                      │
│   Layer 7: Monitoring & Response                                     │
│   ├── Sentry: real-time error tracking with stack traces            │
│   ├── Logflare: structured logging with Cloudflare integration     │
│   ├── Anomaly detection: unusual login patterns flagged             │
│   ├── Alerting: Slack + email for 5xx spikes, auth failures        │
│   └── Incident response: documented playbook in Part 7             │
└──────────────────────────────────────────────────────────────────────┘
```

### Authentication Flow – Complete Visual

```
┌──────────────────────────────────────────────────────────────────────┐
│   AUTHENTICATION FLOW                                                │
│                                                                      │
│   A) First-time Login (OTP):                                         │
│      Student opens app → Enters college email/phone                 │
│      → POST /v1/auth/otp/send { email_or_phone }                   │
│      → Worker: generate 6-digit OTP                                 │
│         → Store in Redis: SET otp:{email}:{code} EX 300            │
│         → Send via MSG91 SMS or Resend email                        │
│      → Student enters OTP                                            │
│      → POST /v1/auth/otp/verify { email_or_phone, code }           │
│      → Worker: check Redis GET otp:{email}:{code}                   │
│         → Match? → Generate JWT pair (access + refresh)             │
│         → Redis DEL otp:{email}:{code}                               │
│      → Return: { access_token, refresh_token, user }                │
│                                                                      │
│   B) Returning User:                                                 │
│      App has stored refresh_token in Flutter Secure Storage         │
│      → POST /v1/auth/token/refresh { refresh_token }               │
│      → Worker: verify refresh token                                  │
│         → Check not in blacklist                                     │
│         → Rotate: blacklist old refresh, issue new pair             │
│      → Return: { new_access_token, new_refresh_token }              │
│                                                                      │
│   C) Logout:                                                         │
│      → POST /v1/auth/logout { refresh_token }                       │
│      → Worker: add access_token to Redis blacklist                  │
│         → SET blacklist:token:{jti} EX {remaining_ttl}              │
│         → Delete refresh token from Redis                            │
│      → App: clear local storage, navigate to login                  │
│                                                                      │
│   D) Biometric (optional):                                           │
│      → Enabled in settings → uses Flutter local_auth                │
│      → Biometric verifies → uses stored refresh_token               │
│      → Same flow as (B) above                                       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 1.18 Error Handling & API Response Convention

### Standard API Response Format

Every API endpoint in CampusSphere returns a **consistent JSON response format**. This ensures the Flutter app, admin dashboard, and third-party integrations can reliably parse responses.

```
┌──────────────────────────────────────────────────────────────────────┐
│   API RESPONSE FORMAT                                                │
│                                                                      │
│   ═══ Success Response ═══                                           │
│   {                                                                  │
│     "success": true,                                                 │
│     "data": { ... },          // Requested resource or result       │
│     "message": "Operation completed",                               │
│     "meta": {                  // Pagination info (if applicable)   │
│       "page": 1,                                                     │
│       "per_page": 20,                                                │
│       "total": 145,                                                  │
│       "total_pages": 8                                               │
│     }                                                                │
│   }                                                                  │
│                                                                      │
│   ═══ Error Response ═══                                             │
│   {                                                                  │
│     "success": false,                                                │
│     "error": {                                                       │
│       "code": "ATTENDANCE_OUTSIDE_CAMPUS",                          │
│       "message": "You are not within the campus geo-fence.",        │
│       "details": {                                                   │
│         "your_distance": "2.3 km",                                  │
│         "max_allowed": "200 m"                                      │
│       }                                                              │
│     }                                                                │
│   }                                                                  │
│                                                                      │
│   ═══ HTTP Status Code Usage ═══                                    │
│   200  OK              → GET success, UPDATE success                │
│   201  Created         → POST success (new resource created)        │
│   204  No Content      → DELETE success (no body returned)          │
│   400  Bad Request     → Validation error (Zod) or business rule    │
│   401  Unauthorized    → Missing or invalid JWT                     │
│   403  Forbidden       → Valid JWT but insufficient role/scope      │
│   404  Not Found       → Resource doesn't exist (or RLS hides it)  │
│   409  Conflict        → Duplicate entry (e.g., re-marking attend.)│
│   422  Unprocessable   → Semantic error (e.g., deadline passed)    │
│   429  Too Many Req.   → Rate limit exceeded                        │
│   500  Server Error    → Unhandled exception → logged to Sentry    │
│                                                                      │
│   ═══ Error Codes (enumerated) ═══                                  │
│   AUTH_INVALID_OTP, AUTH_EXPIRED_TOKEN, AUTH_ACCOUNT_LOCKED          │
│   TENANT_NOT_FOUND, TENANT_SUSPENDED, TENANT_PLAN_EXCEEDED         │
│   ATTENDANCE_OUTSIDE_CAMPUS, ATTENDANCE_NO_ACTIVE_CLASS             │
│   ATTENDANCE_ALREADY_MARKED, ATTENDANCE_PROXY_DETECTED              │
│   ASSIGNMENT_DEADLINE_PASSED, ASSIGNMENT_NOT_FOUND                   │
│   FEE_ALREADY_PAID, FEE_PAYMENT_FAILED, FEE_INVALID_AMOUNT        │
│   CHATROOM_ACCESS_DENIED, CHATROOM_RATE_LIMITED                     │
│   MEETING_NOT_STARTED, MEETING_ROOM_FULL                            │
│   FILE_TOO_LARGE, FILE_TYPE_NOT_ALLOWED                             │
│   GENERAL_VALIDATION_ERROR, GENERAL_SERVER_ERROR                    │
└──────────────────────────────────────────────────────────────────────┘
```

### Error Handling in Flutter (Client-Side)

```
┌──────────────────────────────────────────────────────────────────────┐
│   FLUTTER ERROR HANDLING STRATEGY                                    │
│                                                                      │
│   Dio Interceptor catches all API errors:                            │
│                                                                      │
│   class ApiErrorInterceptor extends Interceptor {                    │
│     onError(DioException err, handler) {                            │
│                                                                      │
│       switch (err.response?.statusCode) {                           │
│                                                                      │
│         case 401:                                                    │
│           // Token expired → try refresh                             │
│           // If refresh fails → redirect to login                   │
│           → AuthService.attemptRefresh()                            │
│                                                                      │
│         case 403:                                                    │
│           // Show "Access Denied" snackbar                          │
│           → "You don't have permission for this action"             │
│                                                                      │
│         case 429:                                                    │
│           // Rate limited → show retry after countdown              │
│           → "Too many requests. Retry in {seconds}s"                │
│                                                                      │
│         case 500:                                                    │
│           // Server error → show friendly message                   │
│           → "Something went wrong. Please try again."               │
│           → Log to Sentry with stack trace                          │
│                                                                      │
│         default:                                                     │
│           // Parse error.code from response body                    │
│           // Show localized error message from error code           │
│           → ErrorMessageMapper.getMessage(error.code, locale)       │
│       }                                                              │
│     }                                                                │
│   }                                                                  │
│                                                                      │
│   Key Principle:                                                     │
│   ├── User NEVER sees raw error messages or stack traces            │
│   ├── Every error code maps to a user-friendly localized string     │
│   ├── Network errors → "No internet. Working offline." + queue      │
│   └── Unexpected errors → generic message + Sentry capture          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Complete Document Index

```
┌──────────────────────────────────────────────────────────────────────┐
│   CAMPUSSPHERE – COMPLETE ROADMAP INDEX (13 Parts)                   │
│                                                                      │
│   Part 1:  Vision, Architecture & Tech Stack (THIS DOCUMENT)        │
│   Part 2:  Database Schema & API Design                              │
│   Part 3:  Core Modules (Attendance, Dashboard, Timetable)          │
│   Part 4:  Fee Management, Payments & White-Label Engine             │
│   Part 5:  AI/ML Analytics Layer & Predictive Engine                │
│   Part 6:  Complete ASCII UI Wireframes                              │
│   Part 7:  Deployment, DevOps, Security & Compliance                 │
│   Part 8:  Business Model, Monetization & Timeline                   │
│   Part 9:  Academic Enhancement (Calendar, Exams, Materials, Papers)│
│   Part 10: Campus Life & Governance (Events, Grievance, Polls)      │
│   Part 11: Campus Operations (Hostel, Inventory)                     │
│   Part 12: Career & Alumni (Placement, Internship, Alumni)          │
│   Part 13: Advanced AI & Analytics (Chatbot, Learning, Performance) │
└──────────────────────────────────────────────────────────────────────┘
```

---

> **→ Continue to [Part 2: Database Schema & API Design](./Roadmap_Part2_Database_API.md)**
