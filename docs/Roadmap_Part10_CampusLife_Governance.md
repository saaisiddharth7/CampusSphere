# CampusSphere – Complete Roadmap

## Part 10: Campus Life & Governance Modules – Events, Grievance, Polls & Parent Portal

> **Document Series:** Part 10 of 13
> **Continues from:** [Part 9: Academic Enhancement](./Roadmap_Part9_Academic_Enhancement.md)

---

## 10.1 Campus Event Ticketing Module

### Overview

A complete event management system for campus activities – tech fests, cultural events, workshops, seminars, guest lectures, and sports meets. Supports event creation, student registration, QR-based check-in, and optional fee collection through the existing payment gateway.

### Workflow

```
┌──────────────────────────────────────────────────────────────────────┐
│              EVENT LIFECYCLE                                          │
│                                                                      │
│  1. CREATE                                                           │
│  Admin/Faculty/Club Coordinator creates event                       │
│  ├── Title, description, date/time, venue, capacity                 │
│  ├── Poster image (R2 upload)                                        │
│  ├── Registration type: Open / Approval-required / Invite-only      │
│  ├── Fee: Free / ₹X (via institutional payment gateway)            │
│  └── Departments/programs eligible (or open to all)                 │
│                                                                      │
│  2. PUBLISH                                                          │
│  Event published → appears in calendar + notifications sent         │
│  ├── Push notification to eligible students                          │
│  └── Auto-posted in relevant chatrooms                              │
│                                                                      │
│  3. REGISTER                                                         │
│  Students register for event                                         │
│  ├── Free events: instant registration                              │
│  ├── Paid events: payment → registration confirmed                  │
│  ├── Approval required: admin reviews → approves/rejects            │
│  └── Capacity full: waitlist with auto-promotion                    │
│                                                                      │
│  4. CHECK-IN                                                         │
│  On event day                                                        │
│  ├── Student shows QR code at venue                                  │
│  ├── Volunteer/security scans QR → marks checked-in                 │
│  ├── Live attendance counter shown to organizer                      │
│  └── Optional: selfie check-in with geo-fencing                    │
│                                                                      │
│  5. POST-EVENT                                                       │
│  ├── Participation certificate auto-generated (PDF)                 │
│  ├── Feedback survey triggered automatically                        │
│  ├── Event photos/recordings shared                                  │
│  └── Analytics: registrations vs check-ins vs feedback              │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/014_campus_events.sql

CREATE TABLE campus_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  created_by UUID NOT NULL REFERENCES users(id),

  title TEXT NOT NULL,
  description TEXT,
  event_category TEXT NOT NULL CHECK (event_category IN (
    'tech_fest', 'cultural', 'sports', 'workshop', 'seminar',
    'guest_lecture', 'hackathon', 'competition', 'social', 'other'
  )),

  -- Schedule
  start_datetime TIMESTAMPTZ NOT NULL,
  end_datetime TIMESTAMPTZ NOT NULL,
  registration_deadline TIMESTAMPTZ,

  -- Venue
  venue TEXT NOT NULL,
  is_online BOOLEAN DEFAULT false,
  meeting_link TEXT,

  -- Capacity
  max_capacity INT,
  current_registrations INT DEFAULT 0,
  enable_waitlist BOOLEAN DEFAULT true,

  -- Registration Type
  registration_type TEXT DEFAULT 'open' CHECK (registration_type IN (
    'open', 'approval_required', 'invite_only'
  )),

  -- Fee
  is_paid BOOLEAN DEFAULT false,
  fee_amount DECIMAL(10,2),
  fee_currency TEXT DEFAULT 'INR',

  -- Media
  poster_url TEXT,                                -- R2 URL
  gallery_urls JSONB DEFAULT '[]',

  -- Eligibility
  eligible_departments UUID[],                    -- Empty = all
  eligible_programs UUID[],
  eligible_semesters INT[],

  -- Certificate
  generate_certificate BOOLEAN DEFAULT false,
  certificate_template_url TEXT,

  -- Status
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'registration_closed', 'ongoing', 'completed', 'cancelled')),

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE event_registrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  event_id UUID NOT NULL REFERENCES campus_events(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),

  registration_status TEXT DEFAULT 'registered' CHECK (registration_status IN (
    'registered', 'pending_approval', 'approved', 'rejected', 'waitlisted', 'cancelled'
  )),
  payment_status TEXT DEFAULT 'not_required' CHECK (payment_status IN (
    'not_required', 'pending', 'paid', 'refunded'
  )),
  payment_id UUID,                                -- Link to payments table
  qr_code TEXT,                                   -- Unique QR for check-in
  checked_in BOOLEAN DEFAULT false,
  checked_in_at TIMESTAMPTZ,
  certificate_url TEXT,                           -- R2 URL after event
  feedback_submitted BOOLEAN DEFAULT false,

  registered_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(event_id, user_id)
);

CREATE INDEX idx_events_tenant ON campus_events(tenant_id, start_datetime);
CREATE INDEX idx_event_reg ON event_registrations(tenant_id, event_id);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  CAMPUS EVENTS ENDPOINTS                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/events                       Create event                    │
│  GET    /v1/events                       List events (upcoming/past)     │
│  GET    /v1/events/:id                   Event details                   │
│  PUT    /v1/events/:id                   Update event                    │
│  POST   /v1/events/:id/publish           Publish event                   │
│  POST   /v1/events/:id/register          Register for event             │
│  POST   /v1/events/:id/cancel-reg        Cancel registration            │
│  GET    /v1/events/:id/registrations     List registrations              │
│  POST   /v1/events/:id/approve/:regId    Approve registration           │
│  POST   /v1/events/:id/checkin           QR check-in                    │
│  POST   /v1/events/:id/complete          Mark event completed           │
│  GET    /v1/events/:id/certificate       Generate/download certificate  │
│  GET    /v1/events/:id/analytics         Event analytics                │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Event Listing (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Campus Events            🔍       │
├───────────────────────────────────────┤
│                                       │
│  [Upcoming] [Registered] [Past]       │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  ┌───────────────────────────┐  │  │
│  │  │      [EVENT POSTER]       │  │  │
│  │  │    🎪 TechVista 2026      │  │  │
│  │  │    Annual Tech Fest       │  │  │
│  │  └───────────────────────────┘  │  │
│  │  🎪 TechVista 2026 – Tech Fest │  │
│  │  📅 Mar 15-17 | 📍 Main Campus │  │
│  │  💰 ₹200 | 👥 340/500 regs    │  │
│  │  🔴 Registration closing soon!  │  │
│  │  ┌─────────────────┐           │  │
│  │  │  🎟️ REGISTER     │           │  │
│  │  └─────────────────┘           │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🎤 AI Workshop – Hands-on     │  │
│  │  📅 Feb 28, 2-5 PM             │  │
│  │  📍 Computer Lab 1 | CSE Dept  │  │
│  │  💰 Free | 👥 28/40 seats      │  │
│  │  ✅ You're registered (#23)     │  │
│  │  [📱 Show QR] [❌ Cancel]       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🏏 Inter-Department Cricket    │  │
│  │  📅 Mar 5-8 | 📍 Sports Ground │  │
│  │  💰 Free | 👥 Teams of 11      │  │
│  │  🟡 Approval required           │  │
│  │  ┌─────────────────┐           │  │
│  │  │  🎟️ APPLY        │           │  │
│  │  └─────────────────┘           │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

---

## 10.2 Student Grievance Portal

### Overview

An anonymous and transparent complaint management system where students can submit grievances, track resolution progress, and rate the resolution. Supports SLA timers, escalation paths, and categorized routing.

### Workflow

```
┌──────────────────────────────────────────────────────────────────────┐
│              GRIEVANCE LIFECYCLE                                      │
│                                                                      │
│  Student Submits Grievance (optionally anonymous)                    │
│       │                                                              │
│       ▼                                                              │
│  Auto-categorized + Assigned to relevant admin                       │
│  ├── Academic → Department admin                                    │
│  ├── Infrastructure → Facilities team                               │
│  ├── Hostel → Warden                                                │
│  ├── Faculty → HOD                                                   │
│  ├── Fee/Financial → Accounts                                        │
│  ├── Harassment → Anti-ragging cell (HIGH priority)                 │
│  └── Other → General admin                                          │
│       │                                                              │
│       ▼                                                              │
│  SLA Timer Starts (category-based):                                  │
│  ├── Harassment/Safety → 24 hours                                   │
│  ├── Academic → 72 hours                                             │
│  ├── Infrastructure → 5 days                                        │
│  └── Other → 7 days                                                 │
│       │                                                              │
│       ▼                                                              │
│  Admin Reviews + Takes Action                                        │
│  ├── In Progress → Updates shared with student                      │
│  ├── Needs More Info → Student responds                             │
│  └── Resolved → Student rates resolution (1-5 stars)               │
│       │                                                              │
│       ▼                                                              │
│  Auto-Escalation (if SLA breached):                                  │
│  ├── Level 1 missed → Notify HOD                                    │
│  ├── Level 2 missed → Notify Principal/Dean                        │
│  └── Level 3 missed → Notify Super Admin (CampusSphere)            │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/015_grievance.sql

CREATE TABLE grievances (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  ticket_number TEXT NOT NULL,                    -- Auto: "GRV-2026-0001"
  submitted_by UUID NOT NULL REFERENCES users(id),
  is_anonymous BOOLEAN DEFAULT false,

  category TEXT NOT NULL CHECK (category IN (
    'academic', 'infrastructure', 'hostel', 'faculty',
    'fee_financial', 'harassment', 'ragging', 'food',
    'transport', 'library', 'examination', 'other'
  )),
  sub_category TEXT,
  severity TEXT DEFAULT 'medium' CHECK (severity IN ('low', 'medium', 'high', 'critical')),

  subject TEXT NOT NULL,
  description TEXT NOT NULL,
  attachment_urls JSONB DEFAULT '[]',             -- Screenshots, evidence

  -- Assignment
  assigned_to UUID REFERENCES users(id),
  department_id UUID REFERENCES departments(id),

  -- SLA
  sla_due_at TIMESTAMPTZ NOT NULL,
  escalation_level INT DEFAULT 0,                 -- 0=none, 1=HOD, 2=Dean, 3=Super

  -- Status
  status TEXT DEFAULT 'open' CHECK (status IN (
    'open', 'in_progress', 'needs_info', 'resolved', 'closed', 'escalated', 'reopened'
  )),
  resolution_notes TEXT,
  resolved_at TIMESTAMPTZ,

  -- Feedback
  satisfaction_rating INT CHECK (satisfaction_rating BETWEEN 1 AND 5),
  feedback TEXT,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE grievance_comments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  grievance_id UUID NOT NULL REFERENCES grievances(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  comment TEXT NOT NULL,
  is_internal BOOLEAN DEFAULT false,              -- Internal admin notes
  attachment_urls JSONB DEFAULT '[]',
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_grievance_tenant ON grievances(tenant_id, status);
CREATE INDEX idx_grievance_assigned ON grievances(tenant_id, assigned_to, status);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  GRIEVANCE PORTAL ENDPOINTS                                              │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/grievances                   Submit grievance                │
│  GET    /v1/grievances                   List my grievances (student)    │
│  GET    /v1/grievances/admin             List assigned grievances        │
│  GET    /v1/grievances/:id               Get grievance details           │
│  PUT    /v1/grievances/:id/status        Update status                   │
│  POST   /v1/grievances/:id/assign        Assign/reassign                │
│  POST   /v1/grievances/:id/comment       Add comment/update              │
│  POST   /v1/grievances/:id/resolve       Mark resolved                  │
│  POST   /v1/grievances/:id/rate          Rate resolution (student)       │
│  POST   /v1/grievances/:id/reopen        Reopen grievance               │
│  POST   /v1/grievances/:id/escalate      Manual escalation              │
│  GET    /v1/grievances/stats             Grievance analytics             │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Submit Grievance (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Submit Grievance                    │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Category: [Academic         ▼]  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Subject:                        │  │
│  │ Lab equipment not working       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Description:                    │  │
│  │ The computers in Lab 2 (systems │  │
│  │ 15-20) have had hardware issues │  │
│  │ for the past 2 weeks. We are    │  │
│  │ unable to complete our DS lab   │  │
│  │ assignments. Multiple students  │  │
│  │ are affected.                   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📎 Attachments (optional):           │
│  ├── photo_lab2_system15.jpg ✅      │
│  └── [+ Add more]                    │
│                                       │
│  ☑ Submit Anonymously                │
│  (Your identity hidden from staff)    │
│                                       │
│  Severity:                            │
│  ○ Low  ◉ Medium  ○ High  ○ Critical│
│                                       │
│  ⏱️ Expected SLA: 5 business days     │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │        📤 SUBMIT GRIEVANCE      │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

### Wireframe: Grievance Tracker (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← My Grievances                       │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📋 GRV-2026-0042              │  │
│  │  Lab equipment not working      │  │
│  │  Category: Infrastructure       │  │
│  │  Status: 🟡 In Progress        │  │
│  │  ⏱️ SLA: 2 days remaining       │  │
│  │                                 │  │
│  │  Progress: ───────●─────── 60% │  │
│  │  └─ Admin: "IT team dispatched  │  │
│  │     to inspect Lab 2 systems."  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📋 GRV-2026-0038              │  │
│  │  Water cooler broken – Block B  │  │
│  │  Category: Infrastructure       │  │
│  │  Status: ✅ Resolved            │  │
│  │  Resolved in: 3 days            │  │
│  │  Your Rating: ⭐⭐⭐⭐ (4/5)  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📋 GRV-2026-0031              │  │
│  │  Unfair internal marks          │  │
│  │  Category: Academic (Anonymous) │  │
│  │  Status: 🔴 Escalated (HOD)    │  │
│  │  ⏱️ SLA: Overdue by 1 day       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │     📝 SUBMIT NEW GRIEVANCE     │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

---

## 10.3 Campus Polls & Surveys

### Overview

A quick polling and survey system for faculty, admins, and authorized student coordinators. Used for event preferences, course feedback, mess menu voting, and institutional decision-making.

### Database Schema

```sql
-- supabase/migrations/016_polls_surveys.sql

CREATE TABLE polls (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  created_by UUID NOT NULL REFERENCES users(id),

  title TEXT NOT NULL,
  description TEXT,
  poll_type TEXT DEFAULT 'single_choice' CHECK (poll_type IN (
    'single_choice', 'multiple_choice', 'rating', 'text_response', 'survey'
  )),

  -- Options (for choice-based polls)
  options JSONB NOT NULL DEFAULT '[]',            -- [{id, text, imageUrl}]

  -- Settings
  is_anonymous BOOLEAN DEFAULT true,
  show_results_before_end BOOLEAN DEFAULT false,
  allow_change_vote BOOLEAN DEFAULT false,
  max_selections INT DEFAULT 1,                   -- For multiple choice

  -- Targeting
  target_audience TEXT DEFAULT 'all' CHECK (target_audience IN (
    'all', 'students', 'faculty', 'department', 'section', 'custom'
  )),
  target_department_ids UUID[],
  target_section_ids UUID[],

  -- Schedule
  start_time TIMESTAMPTZ DEFAULT now(),
  end_time TIMESTAMPTZ NOT NULL,

  -- Status
  status TEXT DEFAULT 'active' CHECK (status IN ('draft', 'active', 'closed', 'archived')),
  total_responses INT DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE poll_responses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  poll_id UUID NOT NULL REFERENCES polls(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  selected_options JSONB NOT NULL,                -- [optionId] or {rating: 4} or {text: "..."}
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(poll_id, user_id)
);

CREATE INDEX idx_polls_tenant ON polls(tenant_id, status);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  POLLS & SURVEYS ENDPOINTS                                               │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/polls                       Create poll/survey               │
│  GET    /v1/polls                       List active polls                │
│  GET    /v1/polls/:id                   Get poll with results            │
│  PUT    /v1/polls/:id                   Update poll                      │
│  POST   /v1/polls/:id/vote             Submit vote/response             │
│  GET    /v1/polls/:id/results           Get live results                 │
│  POST   /v1/polls/:id/close            Close poll early                  │
│  GET    /v1/polls/:id/export            Export responses (CSV)           │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Active Poll (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Polls & Surveys                    │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📊 Best Elective for Next Sem? │  │
│  │  Prof. Lakshmi | Ends Mar 1     │  │
│  │  Anonymous | 128 responses      │  │
│  │                                 │  │
│  │  ○ Machine Learning       42%   │  │
│  │    ████████████████░░░░░░       │  │
│  │  ○ Cyber Security         31%   │  │
│  │    ████████████░░░░░░░░░░       │  │
│  │  ○ Cloud Computing        18%   │  │
│  │    ███████░░░░░░░░░░░░░░░       │  │
│  │  ○ Blockchain              9%   │  │
│  │    ████░░░░░░░░░░░░░░░░░░       │  │
│  │                                 │  │
│  │  ┌─────────────────┐           │  │
│  │  │   📊 VOTE NOW    │           │  │
│  │  └─────────────────┘           │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📋 Mess Menu Rating (Weekly)   │  │
│  │  Hostel Warden | Ends Feb 22    │  │
│  │  ⭐ Rate 1-5 | 56 responses     │  │
│  │  ✅ You voted (⭐⭐⭐)          │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📝 Course Feedback – DBMS      │  │
│  │  Admin (end-of-semester survey) │  │
│  │  13 questions | ~5 min          │  │
│  │  ┌─────────────────┐           │  │
│  │  │  📝 TAKE SURVEY  │           │  │
│  │  └─────────────────┘           │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

---

## 10.4 Parent Portal

### Overview

A read-only portal for parents/guardians to monitor their child's academic progress, attendance, fee status, and AI-generated risk alerts. Parents log in with a separate linked account and see a simplified dashboard.

### Feature Breakdown

```
┌──────────────────────────────────────────────────────────────────────┐
│              PARENT PORTAL – FEATURES                                 │
│                                                                      │
│  Access:                                                             │
│  ├── Separate login (phone + OTP) linked to student account         │
│  ├── Read-only access (cannot modify any data)                      │
│  ├── Multi-child support (parent with 2+ children in same college) │
│  └── Available on mobile app + web                                  │
│                                                                      │
│  Dashboard Shows:                                                    │
│  ├── 📊 Attendance: Overall % + subject-wise + trend graph          │
│  ├── 📈 Academic Results: CGPA, semester grades, rank               │
│  ├── 💰 Fee Status: Paid/pending/overdue with amounts              │
│  ├── 📝 Assignment Compliance: Submission rate                      │
│  ├── 🤖 AI Risk Alerts: Dropout risk, attendance prediction        │
│  └── 🔔 Notifications: Exam dates, fee reminders, low attendance   │
│                                                                      │
│  Privacy Controls:                                                   │
│  ├── Student can enable/disable parent access (over 18)             │
│  ├── Some data hidden by default (chatroom activity, etc.)          │
│  └── Admin can mandate parent portal for minors                      │
│                                                                      │
│  Notifications Sent to Parents:                                      │
│  ├── 🔴 Attendance drops below 75%                                  │
│  ├── 🟠 Assignment not submitted past deadline                      │
│  ├── 🔴 Fee payment overdue                                         │
│  ├── 🔴 Exam eligibility blocked                                    │
│  ├── 📊 Monthly progress report (auto email via Resend)             │
│  └── 🤖 AI alert: dropout risk elevated                              │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/017_parent_portal.sql

CREATE TABLE parent_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  -- Parent Info
  name TEXT NOT NULL,
  phone TEXT NOT NULL,
  email TEXT,
  relationship TEXT CHECK (relationship IN ('father', 'mother', 'guardian', 'other')),

  -- Auth (custom JWT, same auth system)
  password_hash TEXT NOT NULL,
  is_active BOOLEAN DEFAULT true,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, phone)
);

CREATE TABLE parent_student_links (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  parent_id UUID NOT NULL REFERENCES parent_accounts(id),
  student_id UUID NOT NULL REFERENCES students(id),
  is_primary BOOLEAN DEFAULT true,                -- Primary guardian
  student_consent BOOLEAN DEFAULT true,           -- Student approved sharing
  linked_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(parent_id, student_id)
);

-- Parent notification preferences
CREATE TABLE parent_notification_prefs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID NOT NULL REFERENCES parent_accounts(id),
  student_id UUID NOT NULL REFERENCES students(id),
  notify_attendance_drop BOOLEAN DEFAULT true,
  notify_fee_overdue BOOLEAN DEFAULT true,
  notify_assignment_missed BOOLEAN DEFAULT true,
  notify_exam_eligibility BOOLEAN DEFAULT true,
  notify_monthly_report BOOLEAN DEFAULT true,
  notify_ai_alerts BOOLEAN DEFAULT true,
  channel TEXT DEFAULT 'all' CHECK (channel IN ('sms', 'email', 'push', 'whatsapp', 'all')),
  UNIQUE(parent_id, student_id)
);

CREATE INDEX idx_parent_links ON parent_student_links(tenant_id, student_id);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  PARENT PORTAL ENDPOINTS                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/parent/auth/login           Parent login (phone + OTP)      │
│  GET    /v1/parent/children             List linked children             │
│  GET    /v1/parent/child/:studentId/dashboard   Child dashboard          │
│  GET    /v1/parent/child/:studentId/attendance   Attendance details      │
│  GET    /v1/parent/child/:studentId/results      Exam results            │
│  GET    /v1/parent/child/:studentId/fees         Fee status              │
│  GET    /v1/parent/child/:studentId/assignments  Assignment status       │
│  GET    /v1/parent/child/:studentId/ai-alerts    AI risk alerts          │
│  GET    /v1/parent/child/:studentId/report       Monthly report PDF     │
│  PUT    /v1/parent/notifications        Update notification prefs       │
│  POST   /v1/admin/parents/link          Admin links parent to student   │
│  POST   /v1/admin/parents/import        Bulk import parent accounts     │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Parent Dashboard (Mobile)

```
┌───────────────────────────────────────┐
│  ← Parent Portal          🔔   👤    │
├───────────────────────────────────────┤
│                                       │
│  👋 Welcome, Mr. Kumar                │
│  Viewing: Rahul Kumar (21CS101)       │
│  [Switch Child ▼]                     │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📊 Attendance                  │  │
│  │  Overall: 78.5%                 │  │
│  │  ██████████████████░░░░ 78.5%  │  │
│  │  ⚠️ Just 3.5% above minimum     │  │
│  │  Lowest: Math III (65%)         │  │
│  │                                 │  │
│  │  Last 7 days: 4/6 present      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌────────────┐ ┌──────────────────┐ │
│  │  📈 CGPA   │ │  📝 Assignments  │ │
│  │   7.8      │ │  85% submitted   │ │
│  │  ↑ from 7.5│ │  2 pending       │ │
│  └────────────┘ └──────────────────┘ │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  💰 Fee Status                  │  │
│  │  Semester 3: ₹16,375 pending   │  │
│  │  Due: Mar 15, 2026              │  │
│  │  ⚠️ Overdue in 23 days          │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🤖 AI Insights                 │  │
│  │  Dropout Risk: 🟢 LOW (12%)    │  │
│  │  Predicted next CGPA: 8.0 📈   │  │
│  │  Focus areas: Math III          │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📊 Exam Schedule              │  │
│  │  Internal 1: Feb 25-Mar 1      │  │
│  │  Eligibility: ✅ All subjects   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📥 DOWNLOAD MONTHLY REPORT     │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

---

> **→ Continue to [Part 11: Campus Operations Modules](./Roadmap_Part11_Campus_Operations.md)**
