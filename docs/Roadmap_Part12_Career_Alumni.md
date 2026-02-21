# CampusSphere – Complete Roadmap

## Part 12: Career & Alumni Modules – Placement Portal, Internship Tracker & Alumni Network

> **Document Series:** Part 12 of 13
> **Continues from:** [Part 11: Campus Operations](./Roadmap_Part11_Campus_Operations.md)

---

## 12.1 Placement Portal

### Overview

A comprehensive campus placement management system connecting students, placement coordinators, and recruiting companies. Handles the complete placement lifecycle from company onboarding to offer acceptance.

### Placement Lifecycle

```
┌──────────────────────────────────────────────────────────────────────┐
│              PLACEMENT LIFECYCLE                                      │
│                                                                      │
│  1. COMPANY REGISTRATION                                             │
│  Placement cell adds company profile                                 │
│  ├── Company info (name, industry, website, package range)          │
│  ├── Job descriptions (JD) for offered roles                        │
│  ├── Eligibility criteria (CGPA, backlogs, departments)             │
│  └── Drive date, type (on-campus/off-campus/virtual)                │
│                                                                      │
│  2. STUDENT REGISTRATION                                             │
│  Eligible students register for drive                                │
│  ├── Auto-filter based on CGPA + backlogs + department              │
│  ├── Students upload updated resume                                  │
│  ├── Application deadline enforced                                   │
│  └── Placement coordinator approves registrations                   │
│                                                                      │
│  3. SELECTION ROUNDS                                                 │
│  Multi-round process tracked in system                               │
│  ├── Round 1: Aptitude Test (online/offline)                        │
│  ├── Round 2: Technical Interview                                   │
│  ├── Round 3: HR Interview                                          │
│  ├── Each round: Shortlist published → qualified move forward       │
│  └── Status: Applied → Shortlisted → Interviewed → Selected/Reject │
│                                                                      │
│  4. OFFER MANAGEMENT                                                 │
│  ├── Offer letter uploaded by placement cell                        │
│  ├── Student accepts/declines within deadline                       │
│  ├── Offer details: role, package, location, joining date           │
│  └── Placed students blocked from lower-tier companies              │
│                                                                      │
│  5. ANALYTICS & REPORTS                                              │
│  ├── Department-wise placement stats                                │
│  ├── Package distribution (highest, lowest, average, median)        │
│  ├── Year-over-year comparison                                      │
│  ├── Company visit history                                           │
│  └── NAAC/NBA-ready placement reports                               │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/020_placement.sql

-- Companies
CREATE TABLE placement_companies (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  company_name TEXT NOT NULL,
  industry TEXT,
  website TEXT,
  logo_url TEXT,
  description TEXT,
  headquarters TEXT,
  company_type TEXT CHECK (company_type IN ('product', 'service', 'startup', 'mnc', 'psu', 'government')),
  contact_person TEXT,
  contact_email TEXT,
  contact_phone TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Placement Drives
CREATE TABLE placement_drives (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  company_id UUID NOT NULL REFERENCES placement_companies(id),
  academic_year TEXT NOT NULL,

  -- Job Details
  job_title TEXT NOT NULL,
  job_description TEXT,
  job_type TEXT CHECK (job_type IN ('full_time', 'internship_ppo', 'contract')),
  package_lpa DECIMAL(10,2),                      -- CTC in LPA
  stipend_monthly DECIMAL(10,2),                  -- If internship
  location TEXT,
  bond_years INT DEFAULT 0,

  -- Eligibility
  eligible_departments UUID[],
  eligible_programs UUID[],
  min_cgpa DECIMAL(3,1),
  max_backlogs INT DEFAULT 0,
  graduation_year INT,

  -- Schedule
  drive_type TEXT DEFAULT 'on_campus' CHECK (drive_type IN ('on_campus', 'off_campus', 'virtual', 'pool')),
  drive_date DATE,
  registration_deadline TIMESTAMPTZ,

  -- Rounds
  rounds JSONB DEFAULT '[]',                      -- [{roundNum, name, date, venue, mode}]

  -- Status
  status TEXT DEFAULT 'upcoming' CHECK (status IN ('upcoming', 'registration_open', 'registration_closed', 'in_progress', 'completed', 'cancelled')),
  total_registrations INT DEFAULT 0,
  total_shortlisted INT DEFAULT 0,
  total_selected INT DEFAULT 0,

  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Student Applications
CREATE TABLE placement_applications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  drive_id UUID NOT NULL REFERENCES placement_drives(id),
  student_id UUID NOT NULL REFERENCES students(id),

  resume_url TEXT,                                -- R2 URL
  cover_letter TEXT,

  -- Status tracking
  status TEXT DEFAULT 'applied' CHECK (status IN (
    'applied', 'shortlisted', 'round_1', 'round_2', 'round_3',
    'selected', 'rejected', 'offer_received', 'offer_accepted',
    'offer_declined', 'withdrawn'
  )),
  current_round INT DEFAULT 0,

  -- Offer
  offer_letter_url TEXT,
  offered_package_lpa DECIMAL(10,2),
  offered_role TEXT,
  offered_location TEXT,
  offer_deadline TIMESTAMPTZ,
  offer_response TEXT CHECK (offer_response IN ('pending', 'accepted', 'declined')),

  applied_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(drive_id, student_id)
);

-- Placement Statistics (pre-computed for reports)
CREATE TABLE placement_stats (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  academic_year TEXT NOT NULL,
  department_id UUID REFERENCES departments(id),
  total_eligible INT,
  total_placed INT,
  highest_package DECIMAL(10,2),
  lowest_package DECIMAL(10,2),
  average_package DECIMAL(10,2),
  median_package DECIMAL(10,2),
  total_companies INT,
  total_offers INT,
  computed_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_drives_tenant ON placement_drives(tenant_id, academic_year, status);
CREATE INDEX idx_applications ON placement_applications(tenant_id, student_id, status);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  PLACEMENT PORTAL ENDPOINTS                                              │
├──────────────────────────────────────────────────────────────────────────┤
│  CRUD   /v1/placement/companies           Company profiles               │
│  POST   /v1/placement/drives              Create placement drive         │
│  GET    /v1/placement/drives              List drives (upcoming/past)    │
│  GET    /v1/placement/drives/:id          Drive details + rounds         │
│  PUT    /v1/placement/drives/:id          Update drive                   │
│  POST   /v1/placement/drives/:id/apply    Student applies                │
│  GET    /v1/placement/drives/:id/applicants  List applicants             │
│  POST   /v1/placement/drives/:id/shortlist   Update shortlist            │
│  POST   /v1/placement/drives/:id/round-result  Post round results       │
│  POST   /v1/placement/drives/:id/offer    Send offer to student         │
│  PUT    /v1/placement/applications/:id/respond  Accept/decline offer    │
│  GET    /v1/placement/my-applications     Student's all applications    │
│  GET    /v1/placement/stats               Placement statistics          │
│  GET    /v1/placement/stats/department    Dept-wise stats               │
│  GET    /v1/placement/reports/export      Export NAAC/NBA report        │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Placement Portal (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Placement Portal        🔍        │
├───────────────────────────────────────┤
│                                       │
│  [Upcoming Drives] [My Apps] [Placed] │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🏢 Infosys Technologies       │  │
│  │  Role: System Engineer          │  │
│  │  💰 Package: 3.6 LPA           │  │
│  │  📅 Drive: Mar 10 (On-campus)   │  │
│  │  📋 Eligible: CSE, ECE, IT      │  │
│  │     CGPA ≥ 6.5 | 0 backlogs    │  │
│  │  ⏰ Apply by: Mar 5             │  │
│  │  👥 82 registered               │  │
│  │  Status: ✅ You're eligible      │  │
│  │  ┌─────────────────┐           │  │
│  │  │  📝 APPLY NOW    │           │  │
│  │  └─────────────────┘           │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🏢 TCS Digital                 │  │
│  │  Role: Digital Lead (Fresher)   │  │
│  │  💰 Package: 7.0 LPA           │  │
│  │  📅 Drive: Mar 15 (Virtual)     │  │
│  │  📋 CSE, IT | CGPA ≥ 7.5       │  │
│  │  ⏰ Apply by: Mar 10            │  │
│  │  ❌ Not eligible (CGPA: 7.2)    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🏢 Zoho Corporation           │  │
│  │  Role: Software Developer       │  │
│  │  💰 Package: 6.5 LPA           │  │
│  │  📅 Drive: Mar 20              │  │
│  │  You applied ✅ | Status:       │  │
│  │  🟡 Round 1 (Aptitude) – Mar 12│  │
│  │  [View Details →]              │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ── My Placement Stats ──            │
│  Applied: 5 | Shortlisted: 3        │
│  Offers: 0 | Status: Active 🟢      │
│                                       │
└───────────────────────────────────────┘
```

### Wireframe: Placement Stats (Admin Dashboard)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  📊 Placement Statistics – 2025-26                                       │
│  ──────────────────────────────────                                     │
│                                                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐    │
│  │ Eligible │ │ Placed   │ │ Highest  │ │ Average  │ │ Companies│    │
│  │ 420      │ │ 312      │ │ 42 LPA   │ │ 6.8 LPA  │ │ 45       │    │
│  │          │ │ (74.3%)  │ │ (Google) │ │          │ │ visited  │    │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘    │
│                                                                         │
│  Department-wise Breakdown:                                             │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ Department │ Eligible │ Placed │ Highest │ Avg Pkg │ % Placed    │ │
│  ├────────────┼──────────┼────────┼─────────┼─────────┼─────────────┤ │
│  │ CSE        │ 120      │ 108    │ 42 LPA  │ 8.2 LPA │ 90.0% ████ │ │
│  │ IT         │ 80       │ 68     │ 12 LPA  │ 6.5 LPA │ 85.0% ████ │ │
│  │ ECE        │ 100      │ 72     │ 18 LPA  │ 5.8 LPA │ 72.0% ███  │ │
│  │ MECH       │ 60       │ 34     │ 8 LPA   │ 4.5 LPA │ 56.7% ██   │ │
│  │ CIVIL      │ 60       │ 30     │ 6 LPA   │ 4.0 LPA │ 50.0% ██   │ │
│  └────────────┴──────────┴────────┴─────────┴─────────┴─────────────┘ │
│                                                                         │
│  [📥 Export NAAC Report] [📊 Year-over-Year] [📤 Share with Mgmt]     │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 12.2 Internship Tracker

### Overview

Track internship activities for students as required by universities and AICTE. Includes internship registration, mentor assignment, progress tracking through monthly reports, hour logging, and final evaluation.

### Database Schema

```sql
-- supabase/migrations/021_internship.sql

CREATE TABLE internships (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),

  -- Company
  company_name TEXT NOT NULL,
  company_website TEXT,
  industry TEXT,
  location TEXT,
  is_remote BOOLEAN DEFAULT false,

  -- Internship Details
  role TEXT NOT NULL,
  description TEXT,
  domain TEXT,                                    -- "Web Development", "Data Science"
  internship_type TEXT CHECK (internship_type IN ('mandatory', 'voluntary', 'summer', 'semester_long', 'research')),
  stipend_monthly DECIMAL(10,2),

  -- Schedule
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  total_hours_required INT DEFAULT 240,           -- AICTE: 240 hours minimum
  total_hours_logged DECIMAL(6,1) DEFAULT 0,

  -- Mentors
  company_mentor_name TEXT,
  company_mentor_email TEXT,
  company_mentor_phone TEXT,
  faculty_mentor_id UUID REFERENCES faculty(id),

  -- Documents
  offer_letter_url TEXT,
  noc_url TEXT,                                   -- No Objection Certificate
  completion_certificate_url TEXT,
  final_report_url TEXT,

  -- Status
  status TEXT DEFAULT 'registered' CHECK (status IN (
    'registered', 'approved', 'ongoing', 'report_pending',
    'completed', 'certified', 'rejected', 'abandoned'
  )),

  -- Evaluation
  company_rating INT CHECK (company_rating BETWEEN 1 AND 10),
  company_feedback TEXT,
  faculty_rating INT CHECK (faculty_rating BETWEEN 1 AND 10),
  faculty_feedback TEXT,
  final_grade TEXT,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Monthly / Weekly Progress Reports
CREATE TABLE internship_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  internship_id UUID NOT NULL REFERENCES internships(id) ON DELETE CASCADE,
  report_number INT NOT NULL,                     -- 1, 2, 3...
  report_period TEXT,                             -- "Week 1-2" or "Month 1"

  -- Content
  activities_performed TEXT NOT NULL,
  learnings TEXT,
  challenges TEXT,
  next_plan TEXT,
  hours_logged DECIMAL(5,1) NOT NULL,

  -- Attachments
  attachment_urls JSONB DEFAULT '[]',

  -- Faculty Review
  faculty_remarks TEXT,
  faculty_approved BOOLEAN DEFAULT false,
  faculty_approved_at TIMESTAMPTZ,

  submitted_at TIMESTAMPTZ DEFAULT now()
);

-- Internship Hour Log (daily)
CREATE TABLE internship_hours (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  internship_id UUID NOT NULL REFERENCES internships(id) ON DELETE CASCADE,
  log_date DATE NOT NULL,
  hours DECIMAL(4,1) NOT NULL,
  description TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(internship_id, log_date)
);

CREATE INDEX idx_internship_student ON internships(tenant_id, student_id, status);
CREATE INDEX idx_internship_mentor ON internships(tenant_id, faculty_mentor_id);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  INTERNSHIP TRACKER ENDPOINTS                                            │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/internships                    Register internship           │
│  GET    /v1/internships                    List (student's / all)        │
│  GET    /v1/internships/:id                Details                       │
│  PUT    /v1/internships/:id                Update internship             │
│  PUT    /v1/internships/:id/approve         Faculty/admin approve        │
│  POST   /v1/internships/:id/reports        Submit progress report        │
│  GET    /v1/internships/:id/reports        List reports                   │
│  PUT    /v1/internships/:id/reports/:rId/approve  Faculty approves       │
│  POST   /v1/internships/:id/hours          Log daily hours               │
│  GET    /v1/internships/:id/hours          Hour log summary              │
│  POST   /v1/internships/:id/complete       Submit completion docs        │
│  POST   /v1/internships/:id/evaluate       Final evaluation              │
│  GET    /v1/internships/stats              Internship statistics         │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Internship Tracker (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← My Internship                       │
├───────────────────────────────────────┤
│                                       │
│  🏢 Zoho Corporation                   │
│  Role: Junior Software Developer       │
│  📅 Jan 15 – Apr 15, 2026             │
│  📍 Chennai (On-site)                  │
│  💰 ₹15,000/month                     │
│  Status: 🟢 Ongoing                   │
│                                       │
│  ⏱️ Hours Progress:                    │
│  ┌─────────────────────────────────┐  │
│  │  168 / 240 hours logged         │  │
│  │  ██████████████████░░░░░ 70%   │  │
│  │  72 hours remaining             │  │
│  │  On track ✅ (14 days left)      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌────────┐┌────────┐┌────────┐      │
│  │  ⏱️    ││  📝    ││  📄    │      │
│  │ Log    ││ Submit ││ Upload │      │
│  │ Hours  ││ Report ││ Docs   │      │
│  └────────┘└────────┘└────────┘      │
│                                       │
│  📝 Progress Reports:                 │
│  ┌─────────────────────────────────┐  │
│  │  Report 3 (Month 2)            │  │
│  │  ⏳ Pending faculty review       │  │
│  │  Submitted: Feb 15              │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │  Report 2 (Month 1)            │  │
│  │  ✅ Approved by Dr. Rajan S     │  │
│  │  "Good progress on REST APIs."  │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │  Report 1 (Weeks 1-2)          │  │
│  │  ✅ Approved                    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  👨‍🏫 Faculty Mentor: Dr. Rajan S      │
│  🏢 Company Mentor: Aravind K        │
│                                       │
└───────────────────────────────────────┘
```

---

## 12.3 Alumni Network

### Overview

Connect alumni with current students and the institution. Features an alumni directory, mentorship matching, job referral board, donation portal, and event invitations.

### Database Schema

```sql
-- supabase/migrations/022_alumni.sql

CREATE TABLE alumni_profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID REFERENCES users(id),              -- If registered on platform
  student_id UUID REFERENCES students(id),        -- Original student record

  -- Personal
  name TEXT NOT NULL,
  email TEXT,
  phone TEXT,
  linkedin_url TEXT,
  profile_photo_url TEXT,

  -- Academic
  graduation_year INT NOT NULL,
  department_id UUID REFERENCES departments(id),
  program TEXT,
  roll_number TEXT,

  -- Professional
  current_company TEXT,
  current_role TEXT,
  industry TEXT,
  location TEXT,
  years_of_experience INT,
  career_history JSONB DEFAULT '[]',              -- [{company, role, from, to}]

  -- Skills
  skills TEXT[],
  areas_of_expertise TEXT[],

  -- Preferences
  open_to_mentor BOOLEAN DEFAULT false,
  open_to_refer BOOLEAN DEFAULT false,
  open_to_donate BOOLEAN DEFAULT false,
  open_to_guest_lecture BOOLEAN DEFAULT false,
  visibility TEXT DEFAULT 'public' CHECK (visibility IN ('public', 'alumni_only', 'private')),

  is_verified BOOLEAN DEFAULT false,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Mentorship
CREATE TABLE mentorship_connections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  alumni_id UUID NOT NULL REFERENCES alumni_profiles(id),
  student_id UUID NOT NULL REFERENCES students(id),
  status TEXT DEFAULT 'requested' CHECK (status IN ('requested', 'accepted', 'declined', 'active', 'completed')),
  student_message TEXT,
  meeting_count INT DEFAULT 0,
  started_at TIMESTAMPTZ,
  ended_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(alumni_id, student_id)
);

-- Job Referrals
CREATE TABLE alumni_referrals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  posted_by UUID NOT NULL REFERENCES alumni_profiles(id),
  company_name TEXT NOT NULL,
  role TEXT NOT NULL,
  description TEXT,
  location TEXT,
  job_type TEXT CHECK (job_type IN ('full_time', 'internship', 'contract', 'freelance')),
  package_range TEXT,
  apply_link TEXT,
  eligible_departments UUID[],
  eligible_years INT[],                           -- Graduation years
  is_active BOOLEAN DEFAULT true,
  applications_count INT DEFAULT 0,
  posted_at TIMESTAMPTZ DEFAULT now()
);

-- Donations
CREATE TABLE alumni_donations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  alumni_id UUID NOT NULL REFERENCES alumni_profiles(id),
  amount DECIMAL(12,2) NOT NULL,
  currency TEXT DEFAULT 'INR',
  purpose TEXT,                                   -- "Scholarship Fund", "Lab Equipment"
  fund_name TEXT,
  payment_id TEXT,
  payment_status TEXT DEFAULT 'pending' CHECK (payment_status IN ('pending', 'completed', 'failed', 'refunded')),
  receipt_url TEXT,
  is_anonymous BOOLEAN DEFAULT false,
  donated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_alumni_tenant ON alumni_profiles(tenant_id, graduation_year);
CREATE INDEX idx_alumni_dept ON alumni_profiles(tenant_id, department_id);
CREATE INDEX idx_referrals ON alumni_referrals(tenant_id, is_active);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  ALUMNI NETWORK ENDPOINTS                                                │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/alumni/register              Alumni self-registration        │
│  GET    /v1/alumni/directory             Browse alumni directory         │
│  GET    /v1/alumni/:id                   Alumni profile                  │
│  PUT    /v1/alumni/:id                   Update profile                  │
│  POST   /v1/alumni/:id/verify            Admin verifies alumni          │
│  GET    /v1/alumni/search?q=&dept=&year= Search alumni                  │
│  POST   /v1/alumni/mentorship/request    Student requests mentorship    │
│  PUT    /v1/alumni/mentorship/:id        Accept/decline                 │
│  GET    /v1/alumni/mentorship/my         My mentorship connections      │
│  POST   /v1/alumni/referrals             Post job referral              │
│  GET    /v1/alumni/referrals             Browse referrals                │
│  POST   /v1/alumni/referrals/:id/apply   Apply for referral             │
│  POST   /v1/alumni/donations             Make donation                   │
│  GET    /v1/alumni/donations/history     Donation history               │
│  GET    /v1/alumni/stats                 Alumni network stats           │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Alumni Directory (Web)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🎓 Alumni Network – XYZ Engineering College                             │
│  ───────────────────────────────────────────                             │
│                                                                         │
│  [Directory] [Job Referrals] [Mentorship] [Donate] [Events]            │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  🔍 Search alumni...  [Dept ▼] [Batch ▼] [Location ▼] [Skill ▼] │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  Total Alumni: 2,845 registered | 1,204 mentors available              │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  ┌────┐                                                           │ │
│  │  │ 👤 │  Aravind Krishnan (Batch 2018)                           │ │
│  │  └────┘  🏢 Google | Senior Software Engineer | Bangalore        │ │
│  │          🎓 B.Tech CSE                                            │ │
│  │          Skills: Python, ML, Cloud                                │ │
│  │          ✅ Open to: Mentorship, Referrals                        │ │
│  │          [🤝 Request Mentorship]  [💼 View Referrals]             │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  ┌────┐                                                           │ │
│  │  │ 👤 │  Priya Sharma (Batch 2020)                               │ │
│  │  └────┘  🏢 Microsoft | Product Manager | Hyderabad              │ │
│  │          🎓 B.Tech IT                                             │ │
│  │          ✅ Open to: Guest Lectures, Mentorship                   │ │
│  │          [🤝 Request Mentorship]                                   │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ── Job Referrals (12 active) ──                                        │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  💼 SDE-1 at Amazon | Posted by Aravind K (2018)                  │ │
│  │  📍 Chennai | 💰 18-24 LPA | CSE, IT eligible                    │ │
│  │  [📝 Apply via Referral]                                          │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

> **→ Continue to [Part 13: Advanced AI & Analytics](./Roadmap_Part13_Advanced_AI_Analytics.md)**
