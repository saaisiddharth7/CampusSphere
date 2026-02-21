# CampusSphere – Complete Roadmap

## Part 2: Database Schema & API Design

> **Document Series:** Part 2 of 8
> **Continues from:** [Part 1: Architecture & Tech Stack](./Roadmap_Part1_Architecture_TechStack.md)

---

## 2.1 Entity-Relationship Overview

```
┌──────────────────────────────────────────────────────────────────────┐
│              ENTITY RELATIONSHIP DIAGRAM (Simplified)                 │
│                                                                      │
│  ┌──────────┐      ┌──────────────┐      ┌──────────────┐          │
│  │ tenants  │──┐   │  departments │──┐   │   courses    │          │
│  │ (t_001)  │  │   │  (CSE, ECE)  │  │   │  (CS301..)   │          │
│  └──────────┘  │   └──────────────┘  │   └──────────────┘          │
│                │          │               │       │                  │
│                │   ┌──────┴──────┐  ┌─────┴────┐  │                  │
│                │   │  programs   │  │ sections │  │                  │
│                │   │  (B.Tech)   │  │  (A, B)  │  │                  │
│                │   └─────────────┘  └──────────┘  │                  │
│                │                         │         │                  │
│                ▼                         │         │                  │
│  ┌──────────────────┐                   │         │                  │
│  │      users       │                   │         │                  │
│  │  (all roles)     │                   │         │                  │
│  │  tenant_id (FK)  │                   │         │                  │
│  └────────┬─────────┘                   │         │                  │
│           │                              │         │                  │
│    ┌──────┴──────┐                      │         │                  │
│    │             │                      │         │                  │
│  ┌─▼──────┐  ┌──▼───────┐              │         │                  │
│  │students│  │ faculty   │              │         │                  │
│  │        │  │           │              │         │                  │
│  └────┬───┘  └────┬──────┘              │         │                  │
│       │           │                      │         │                  │
│       │    ┌──────┴──────┐   ┌──────────┴─────┐   │                  │
│       │    │ timetable    │   │  attendance    │   │                  │
│       │    │ _entries     │   │  _records      │   │                  │
│       │    └─────────────┘   └────────────────┘   │                  │
│       │                                           │                  │
│  ┌────┴──────────┐  ┌────────────────┐   ┌───────┴────────┐        │
│  │ fee_records   │  │ exam_results   │   │  assignments   │        │
│  │               │  │                │   │  (NEW)          │        │
│  └────┬──────────┘  └────────────────┘   └───────┬────────┘        │
│       │                                          │                   │
│  ┌────┴──────────┐                      ┌───────┴────────┐         │
│  │  payments     │                      │  submissions   │         │
│  │               │                      │  (NEW)          │         │
│  └───────────────┘                      └────────────────┘         │
│                                                                      │
│  ┌──────────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │  chatrooms (NEW) │  │  messages    │  │  meetings    │          │
│  │                  │  │  (NEW)        │  │  (NEW)        │          │
│  └──────────────────┘  └──────────────┘  └──────────────┘          │
│                                                                      │
│  All tables have: tenant_id (for RLS), created_at, updated_at       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 2.2 Supabase Schema (SQL Migrations)

### Core Tables

```sql
-- supabase/migrations/001_tenants.sql

-- Tenants (Institutions)
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,                      -- subdomain slug
  custom_domain TEXT UNIQUE,                      -- optional custom domain
  logo_url TEXT,                                  -- R2 URL
  favicon_url TEXT,
  primary_color TEXT DEFAULT '#1E40AF',
  secondary_color TEXT DEFAULT '#3B82F6',
  accent_color TEXT DEFAULT '#F59E0B',
  font_family TEXT DEFAULT 'Inter',
  app_name TEXT,                                  -- White-label app name

  -- Institution Details
  institution_type TEXT CHECK (institution_type IN ('college', 'university', 'school', 'polytechnic', 'coaching')),
  board TEXT,                                     -- CBSE, ICSE, State Board, AICTE, etc.
  affiliation TEXT,                               -- Anna University, JNTU, etc.
  state TEXT NOT NULL,
  city TEXT,
  address TEXT,
  pincode TEXT,
  phone TEXT,
  email TEXT,
  website TEXT,

  -- Subscription & Billing
  plan TEXT DEFAULT 'trial' CHECK (plan IN ('trial', 'starter', 'pro', 'enterprise')),
  razorpay_subscription_id TEXT,                  -- SaaS billing via Razorpay
  subscription_status TEXT DEFAULT 'trialing',
  trial_ends_at TIMESTAMPTZ,
  billing_email TEXT,

  -- Education Payment Gateway (configurable per tenant)
  edu_payment_gateway TEXT DEFAULT 'razorpay' CHECK (edu_payment_gateway IN ('razorpay', 'cashfree', 'payu', 'ccavenue', 'custom')),
  edu_gateway_key_id TEXT,
  edu_gateway_key_secret TEXT,                    -- encrypted at rest
  edu_gateway_webhook_secret TEXT,

  -- Module Activation
  modules_enabled JSONB DEFAULT '{"attendance": true, "academics": true, "fees": true, "timetable": true, "assignments": true, "chatrooms": true, "meetings": false, "ai_analytics": false, "library": false, "hostel": false, "transport": false, "placement": false}',

  -- Limits
  max_students INT DEFAULT 500,
  max_faculty INT DEFAULT 50,
  storage_limit_gb INT DEFAULT 10,

  -- Academic Config
  academic_year_start INT DEFAULT 6,              -- June
  grading_system TEXT DEFAULT 'cgpa_10',           -- cgpa_10, percentage, grade_af
  attendance_minimum DECIMAL DEFAULT 75.0,

  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Index for subdomain/domain lookup
CREATE INDEX idx_tenants_slug ON tenants(slug);
CREATE INDEX idx_tenants_domain ON tenants(custom_domain) WHERE custom_domain IS NOT NULL;
```

```sql
-- supabase/migrations/002_users.sql

-- Users (unified table for all roles)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,

  email TEXT,
  phone TEXT NOT NULL,
  password_hash TEXT NOT NULL,                     -- bcrypt
  role TEXT NOT NULL CHECK (role IN ('student', 'faculty', 'hod', 'coordinator', 'admin', 'super_admin')),

  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  avatar_url TEXT,                                -- R2 URL
  gender TEXT CHECK (gender IN ('male', 'female', 'other')),
  date_of_birth DATE,
  address TEXT,
  city TEXT,
  state TEXT,
  pincode TEXT,
  aadhaar_encrypted TEXT,                         -- AES-256 encrypted

  -- Device Management
  device_id TEXT,                                 -- for single-device enforcement
  device_info JSONB,
  fcm_token TEXT,                                 -- Firebase push token

  -- Status
  is_active BOOLEAN DEFAULT true,
  is_email_verified BOOLEAN DEFAULT false,
  is_phone_verified BOOLEAN DEFAULT false,
  last_login_at TIMESTAMPTZ,
  login_count INT DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),

  UNIQUE(tenant_id, phone),
  UNIQUE(tenant_id, email)
);

-- Students (extends users)
CREATE TABLE students (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  roll_number TEXT NOT NULL,
  registration_number TEXT,
  department_id UUID NOT NULL,
  program_id UUID NOT NULL,
  section_id UUID,
  current_semester INT NOT NULL,
  batch_year INT NOT NULL,                        -- e.g., 2024
  admission_type TEXT,                            -- merit, management, sports, lateral
  category TEXT,                                  -- GEN, OBC, SC, ST, EWS
  scholarship_holder BOOLEAN DEFAULT false,
  scholarship_amount DECIMAL DEFAULT 0,
  hostel_resident BOOLEAN DEFAULT false,
  parent_name TEXT,
  parent_phone TEXT,
  parent_email TEXT,
  blood_group TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, roll_number)
);

-- Faculty (extends users)
CREATE TABLE faculty (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  employee_id TEXT NOT NULL,
  department_id UUID NOT NULL,
  designation TEXT,                               -- Professor, Asst. Prof, Assoc. Prof
  specialization TEXT,
  qualification TEXT,                             -- M.Tech, Ph.D, etc.
  experience_years INT,
  is_hod BOOLEAN DEFAULT false,
  is_coordinator BOOLEAN DEFAULT false,
  coordinator_section_id UUID,                    -- which section they coordinate
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, employee_id)
);

CREATE INDEX idx_users_tenant ON users(tenant_id);
CREATE INDEX idx_students_tenant ON students(tenant_id);
CREATE INDEX idx_faculty_tenant ON faculty(tenant_id);
```

```sql
-- supabase/migrations/003_academic.sql

-- Departments
CREATE TABLE departments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name TEXT NOT NULL,
  code TEXT NOT NULL,                             -- CSE, ECE, ME
  hod_user_id UUID REFERENCES users(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, code)
);

-- Programs (B.Tech, M.Tech, BCA, etc.)
CREATE TABLE programs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  department_id UUID NOT NULL REFERENCES departments(id),
  name TEXT NOT NULL,
  code TEXT NOT NULL,
  duration_years INT NOT NULL,
  total_semesters INT NOT NULL,
  degree_type TEXT,                               -- UG, PG, Diploma, PhD
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, code)
);

-- Sections
CREATE TABLE sections (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  department_id UUID NOT NULL REFERENCES departments(id),
  program_id UUID NOT NULL REFERENCES programs(id),
  name TEXT NOT NULL,                             -- A, B, C
  semester INT NOT NULL,
  batch_year INT NOT NULL,
  coordinator_id UUID REFERENCES faculty(id),
  max_students INT DEFAULT 60,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, department_id, program_id, name, semester, batch_year)
);

-- Courses / Subjects
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  department_id UUID NOT NULL REFERENCES departments(id),
  code TEXT NOT NULL,                             -- CS301, MA201
  name TEXT NOT NULL,
  credits INT NOT NULL,
  course_type TEXT DEFAULT 'theory' CHECK (course_type IN ('theory', 'lab', 'project', 'elective')),
  semester INT NOT NULL,
  program_id UUID REFERENCES programs(id),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, code)
);

-- Faculty-Course-Section Assignment
CREATE TABLE faculty_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  faculty_id UUID NOT NULL REFERENCES faculty(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  section_id UUID NOT NULL REFERENCES sections(id),
  academic_year TEXT NOT NULL,                    -- "2025-26"
  semester INT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, faculty_id, course_id, section_id, academic_year)
);
```

```sql
-- supabase/migrations/004_attendance.sql

CREATE TABLE attendance_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  section_id UUID NOT NULL REFERENCES sections(id),
  faculty_id UUID REFERENCES faculty(id),
  timetable_entry_id UUID,

  date DATE NOT NULL,
  period_number INT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('present', 'absent', 'od', 'leave', 'late', 'medical')),

  -- Verification
  marked_by TEXT CHECK (marked_by IN ('student_gps', 'student_qr', 'faculty_manual', 'faculty_bulk', 'system', 'meeting_auto')),
  latitude DECIMAL,
  longitude DECIMAL,
  distance_from_campus DECIMAL,
  device_id TEXT,
  is_within_geofence BOOLEAN,

  -- Override
  is_overridden BOOLEAN DEFAULT false,
  overridden_by UUID REFERENCES users(id),
  override_reason TEXT,

  -- Sync
  is_synced BOOLEAN DEFAULT true,                 -- false if marked offline
  synced_at TIMESTAMPTZ,

  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, student_id, course_id, date, period_number)
);

CREATE INDEX idx_attendance_student ON attendance_records(tenant_id, student_id, date);
CREATE INDEX idx_attendance_course ON attendance_records(tenant_id, course_id, date);
CREATE INDEX idx_attendance_section ON attendance_records(tenant_id, section_id, date);
```

```sql
-- supabase/migrations/005_fees.sql

-- Fee Structures
CREATE TABLE fee_structures (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name TEXT NOT NULL,                             -- "B.Tech 1st Year Tuition"
  academic_year TEXT NOT NULL,
  department_id UUID REFERENCES departments(id),
  program_id UUID REFERENCES programs(id),
  semester INT,
  fee_type TEXT NOT NULL CHECK (fee_type IN ('tuition', 'hostel', 'transport', 'lab', 'library', 'exam', 'misc')),
  amount DECIMAL NOT NULL,
  due_date DATE NOT NULL,
  late_fee_per_day DECIMAL DEFAULT 0,
  installments_allowed BOOLEAN DEFAULT false,
  max_installments INT DEFAULT 1,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Fee Records (assigned to individual students)
CREATE TABLE fee_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  fee_structure_id UUID NOT NULL REFERENCES fee_structures(id),
  total_amount DECIMAL NOT NULL,
  scholarship_discount DECIMAL DEFAULT 0,
  net_amount DECIMAL NOT NULL,                    -- total - scholarship
  amount_paid DECIMAL DEFAULT 0,
  balance DECIMAL NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'partial', 'paid', 'overdue', 'waived')),
  due_date DATE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Payments
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  fee_record_id UUID NOT NULL REFERENCES fee_records(id),
  amount DECIMAL NOT NULL,
  gateway TEXT NOT NULL,                          -- razorpay, cashfree, payu, etc.
  gateway_order_id TEXT,
  gateway_payment_id TEXT,
  gateway_signature TEXT,
  payment_method TEXT,                            -- upi, card, netbanking, wallet
  status TEXT DEFAULT 'created' CHECK (status IN ('created', 'authorized', 'captured', 'failed', 'refunded')),
  receipt_number TEXT,
  receipt_url TEXT,                                -- R2 URL for PDF receipt
  refund_id TEXT,
  refund_amount DECIMAL,
  metadata JSONB,                                 -- gateway-specific response
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_payments_student ON payments(tenant_id, student_id);
CREATE INDEX idx_payments_status ON payments(tenant_id, status);
```

### NEW: Assignment & Submission Tables

```sql
-- supabase/migrations/006_assignments.sql

-- Assignments (created by faculty)
CREATE TABLE assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  faculty_id UUID NOT NULL REFERENCES faculty(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  section_id UUID NOT NULL REFERENCES sections(id),

  title TEXT NOT NULL,
  description TEXT,                               -- Rich text / markdown
  assignment_type TEXT DEFAULT 'file_upload' CHECK (assignment_type IN ('file_upload', 'text', 'both', 'quiz')),
  attachment_urls JSONB DEFAULT '[]',             -- Array of R2 URLs (question papers, reference material)
  max_marks DECIMAL,

  -- Deadline
  deadline TIMESTAMPTZ NOT NULL,
  allow_late_submission BOOLEAN DEFAULT false,
  late_penalty_per_day DECIMAL DEFAULT 0,         -- marks deducted per day
  max_late_days INT DEFAULT 0,

  -- Settings
  allow_resubmission BOOLEAN DEFAULT true,
  max_file_size_mb INT DEFAULT 10,
  allowed_file_types TEXT[] DEFAULT ARRAY['pdf', 'doc', 'docx', 'zip', 'jpg', 'png'],
  is_published BOOLEAN DEFAULT true,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Submissions (by students)
CREATE TABLE submissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  assignment_id UUID NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id),

  -- Submission Content
  text_content TEXT,                              -- For text-type submissions
  file_urls JSONB DEFAULT '[]',                   -- Array of R2 URLs
  submitted_at TIMESTAMPTZ DEFAULT now(),
  is_late BOOLEAN DEFAULT false,
  late_days INT DEFAULT 0,

  -- Verification by Faculty
  status TEXT DEFAULT 'submitted' CHECK (status IN ('submitted', 'verified', 'rejected', 'resubmit_requested')),
  verified_by UUID REFERENCES faculty(id),
  verified_at TIMESTAMPTZ,
  marks_awarded DECIMAL,
  faculty_remarks TEXT,

  -- Versioning (for resubmissions)
  version INT DEFAULT 1,
  previous_submission_id UUID REFERENCES submissions(id),

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),

  UNIQUE(tenant_id, assignment_id, student_id, version)
);

CREATE INDEX idx_assignments_faculty ON assignments(tenant_id, faculty_id);
CREATE INDEX idx_assignments_course ON assignments(tenant_id, course_id, section_id);
CREATE INDEX idx_assignments_deadline ON assignments(tenant_id, deadline);
CREATE INDEX idx_submissions_assignment ON submissions(tenant_id, assignment_id);
CREATE INDEX idx_submissions_student ON submissions(tenant_id, student_id);
CREATE INDEX idx_submissions_status ON submissions(tenant_id, status);
```

### NEW: Chatroom & Messaging Tables

```sql
-- supabase/migrations/007_chatrooms.sql

-- Chatrooms
CREATE TABLE chatrooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name TEXT NOT NULL,
  description TEXT,
  room_type TEXT NOT NULL CHECK (room_type IN ('subject', 'section', 'department', 'custom')),

  -- Linked entities (based on type)
  course_id UUID REFERENCES courses(id),          -- for subject chatrooms
  section_id UUID REFERENCES sections(id),        -- for section chatrooms
  department_id UUID REFERENCES departments(id),  -- for department chatrooms

  -- Settings
  is_announcement_only BOOLEAN DEFAULT false,     -- only admins/faculty can post
  is_active BOOLEAN DEFAULT true,
  created_by UUID REFERENCES users(id),

  created_at TIMESTAMPTZ DEFAULT now()
);

-- Chatroom Members
CREATE TABLE chatroom_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  chatroom_id UUID NOT NULL REFERENCES chatrooms(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  role TEXT DEFAULT 'member' CHECK (role IN ('member', 'moderator', 'admin')),
  is_muted BOOLEAN DEFAULT false,
  joined_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(chatroom_id, user_id)
);

-- Messages
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  chatroom_id UUID NOT NULL REFERENCES chatrooms(id) ON DELETE CASCADE,
  sender_id UUID NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,
  message_type TEXT DEFAULT 'text' CHECK (message_type IN ('text', 'file', 'image', 'system')),
  file_url TEXT,                                  -- R2 URL for file/image messages
  reply_to_id UUID REFERENCES messages(id),       -- Thread support
  is_pinned BOOLEAN DEFAULT false,
  is_deleted BOOLEAN DEFAULT false,
  edited_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_messages_chatroom ON messages(tenant_id, chatroom_id, created_at DESC);
CREATE INDEX idx_chatroom_members_user ON chatroom_members(tenant_id, user_id);

-- Read Receipts
CREATE TABLE message_read_receipts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  chatroom_id UUID NOT NULL REFERENCES chatrooms(id),
  user_id UUID NOT NULL REFERENCES users(id),
  last_read_message_id UUID REFERENCES messages(id),
  last_read_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(chatroom_id, user_id)
);
```

### NEW: Meeting Tables

```sql
-- supabase/migrations/008_meetings.sql

CREATE TABLE meetings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  created_by UUID NOT NULL REFERENCES users(id),

  title TEXT NOT NULL,
  description TEXT,
  meeting_type TEXT NOT NULL CHECK (meeting_type IN ('live_class', 'doubt_session', 'department_meeting', 'all_hands')),

  -- Linked entities
  course_id UUID REFERENCES courses(id),
  section_id UUID REFERENCES sections(id),
  department_id UUID REFERENCES departments(id),

  -- Schedule
  scheduled_at TIMESTAMPTZ NOT NULL,
  duration_minutes INT DEFAULT 45,
  ended_at TIMESTAMPTZ,

  -- WebRTC Room (100ms / LiveKit)
  room_id TEXT,                                   -- 100ms room ID
  room_token TEXT,                                -- temporary, used at join time

  -- Recording
  is_recorded BOOLEAN DEFAULT true,
  recording_url TEXT,                             -- R2 URL

  -- Status
  status TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'live', 'ended', 'cancelled')),

  -- Attendance
  auto_mark_attendance BOOLEAN DEFAULT true,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Meeting Participants
CREATE TABLE meeting_participants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  meeting_id UUID NOT NULL REFERENCES meetings(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  role TEXT DEFAULT 'participant' CHECK (role IN ('host', 'co_host', 'participant')),
  joined_at TIMESTAMPTZ,
  left_at TIMESTAMPTZ,
  duration_seconds INT,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(meeting_id, user_id)
);

CREATE INDEX idx_meetings_tenant ON meetings(tenant_id, scheduled_at);
CREATE INDEX idx_meetings_creator ON meetings(tenant_id, created_by);
```

### RLS Policies

```sql
-- supabase/migrations/009_rls_policies.sql

-- Enable RLS on all tables
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE faculty ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE programs ENABLE ROW LEVEL SECURITY;
ALTER TABLE sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE courses ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE fee_structures ENABLE ROW LEVEL SECURITY;
ALTER TABLE fee_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE chatrooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE chatroom_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE meetings ENABLE ROW LEVEL SECURITY;
ALTER TABLE meeting_participants ENABLE ROW LEVEL SECURITY;

-- Tenant Isolation Policy (applies to ALL tenant-scoped tables)
-- The JWT issued by our custom auth includes tenant_id as a claim

-- Example: Users table policy
CREATE POLICY "Users see own tenant only" ON users
  FOR ALL
  USING (tenant_id = (current_setting('app.tenant_id'))::uuid);

-- Example: Students see only their own data
CREATE POLICY "Students see own data" ON students
  FOR SELECT
  USING (
    tenant_id = (current_setting('app.tenant_id'))::uuid
    AND (
      user_id = (current_setting('app.user_id'))::uuid
      OR (current_setting('app.user_role')) IN ('faculty', 'hod', 'coordinator', 'admin', 'super_admin')
    )
  );

-- Messages: only chatroom members can read
CREATE POLICY "Chatroom members read messages" ON messages
  FOR SELECT
  USING (
    tenant_id = (current_setting('app.tenant_id'))::uuid
    AND chatroom_id IN (
      SELECT chatroom_id FROM chatroom_members
      WHERE user_id = (current_setting('app.user_id'))::uuid
    )
  );

-- Submissions: students see own, faculty see all in their course
CREATE POLICY "Submission access" ON submissions
  FOR SELECT
  USING (
    tenant_id = (current_setting('app.tenant_id'))::uuid
    AND (
      student_id IN (SELECT id FROM students WHERE user_id = (current_setting('app.user_id'))::uuid)
      OR (current_setting('app.user_role')) IN ('faculty', 'hod', 'admin')
    )
  );
```

---

## 2.3 Timetable & Notification Tables

```sql
-- Timetable Entries
CREATE TABLE timetable_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  section_id UUID NOT NULL REFERENCES sections(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  faculty_id UUID NOT NULL REFERENCES faculty(id),
  day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6), -- 0=Mon
  period_number INT NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  room TEXT,
  academic_year TEXT NOT NULL,
  semester INT NOT NULL,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, section_id, day_of_week, period_number, academic_year)
);

-- Exam Results
CREATE TABLE exam_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  exam_type TEXT CHECK (exam_type IN ('internal_1', 'internal_2', 'internal_3', 'semester', 'supplementary', 'assignment')),
  max_marks DECIMAL NOT NULL,
  marks_obtained DECIMAL NOT NULL,
  grade TEXT,
  grade_point DECIMAL,
  semester INT NOT NULL,
  academic_year TEXT NOT NULL,
  entered_by UUID REFERENCES faculty(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, student_id, course_id, exam_type, academic_year)
);

-- Notifications
CREATE TABLE notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID NOT NULL REFERENCES users(id),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  type TEXT CHECK (type IN ('attendance', 'fee', 'assignment', 'result', 'meeting', 'chatroom', 'general', 'system')),
  data JSONB,                                     -- deep link data
  channels JSONB DEFAULT '["in_app"]',            -- ["in_app", "push", "email", "sms", "whatsapp"]
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_notifications_user ON notifications(tenant_id, user_id, is_read, created_at DESC);

-- Platform Billing (for SaaS subscription tracking)
CREATE TABLE platform_invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  razorpay_invoice_id TEXT,
  razorpay_payment_id TEXT,
  amount DECIMAL NOT NULL,
  gst_amount DECIMAL,                             -- 18% GST
  total_amount DECIMAL NOT NULL,
  status TEXT DEFAULT 'pending',
  billing_period_start DATE,
  billing_period_end DATE,
  paid_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);
```

---

## 2.4 REST API Design (Hono on Cloudflare Workers)

### API Structure

```
Base URL: https://api.campussphere.in/v1
Authentication: Bearer <JWT>
Content-Type: application/json
Tenant Resolution: Automatic from JWT claim or X-Tenant-ID header
Rate Limiting: 100 req/min (student), 300 req/min (faculty), 500 req/min (admin)
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  AUTH ENDPOINTS                                                          │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/auth/login              Login with phone + password          │
│  POST   /v1/auth/login/otp          Login with phone + OTP              │
│  POST   /v1/auth/send-otp           Send OTP to phone                   │
│  POST   /v1/auth/refresh            Refresh access token                │
│  POST   /v1/auth/logout             Blacklist token in Redis             │
│  POST   /v1/auth/forgot-password    Initiate reset via Resend email     │
│  POST   /v1/auth/reset-password     Reset password with token           │
│  GET    /v1/auth/me                 Get current user profile             │
│  PUT    /v1/auth/device             Register device for push/fingerprint│
├──────────────────────────────────────────────────────────────────────────┤
│  ATTENDANCE ENDPOINTS                                                    │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/attendance/mark         Student marks attendance (GPS)      │
│  POST   /v1/attendance/mark-qr      Student marks via QR code           │
│  POST   /v1/attendance/bulk         Faculty bulk marks attendance       │
│  GET    /v1/attendance/today        Student's today's attendance        │
│  GET    /v1/attendance/history      Student's attendance history        │
│  GET    /v1/attendance/summary      Subject-wise attendance summary     │
│  GET    /v1/attendance/class/:id    Faculty: class attendance list      │
│  PUT    /v1/attendance/:id/override Admin/Faculty override attendance   │
│  POST   /v1/attendance/sync         Sync offline attendance records     │
├──────────────────────────────────────────────────────────────────────────┤
│  ASSIGNMENT ENDPOINTS  (NEW)                                             │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/assignments             Faculty creates assignment          │
│  GET    /v1/assignments             List assignments (filtered)         │
│  GET    /v1/assignments/:id         Get assignment details              │
│  PUT    /v1/assignments/:id         Update assignment                   │
│  DELETE /v1/assignments/:id         Delete assignment                   │
│  POST   /v1/assignments/:id/submit  Student submits assignment          │
│  GET    /v1/assignments/:id/submissions   Faculty views submissions     │
│  PUT    /v1/submissions/:id/verify  Faculty verifies submission         │
│  PUT    /v1/submissions/:id/reject  Faculty rejects / requests resub    │
│  GET    /v1/submissions/tracker     Student's submission dashboard      │
│  GET    /v1/assignments/:id/download-all  Download all submissions ZIP  │
├──────────────────────────────────────────────────────────────────────────┤
│  CHATROOM ENDPOINTS  (NEW)                                               │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/chatrooms               List user's chatrooms               │
│  GET    /v1/chatrooms/:id           Get chatroom details + members      │
│  GET    /v1/chatrooms/:id/messages  Get messages (paginated)            │
│  POST   /v1/chatrooms/:id/messages  Send message (also via Realtime)    │
│  PUT    /v1/messages/:id            Edit message                        │
│  DELETE /v1/messages/:id            Delete message                      │
│  POST   /v1/messages/:id/pin       Pin message                         │
│  PUT    /v1/chatrooms/:id/read     Update read receipt                  │
│  POST   /v1/chatrooms/:id/upload   Upload file to chatroom (R2)        │
├──────────────────────────────────────────────────────────────────────────┤
│  MEETING ENDPOINTS  (NEW)                                                │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/meetings               Schedule a meeting                   │
│  GET    /v1/meetings               List upcoming meetings               │
│  GET    /v1/meetings/:id           Get meeting details                  │
│  PUT    /v1/meetings/:id           Update meeting                       │
│  DELETE /v1/meetings/:id           Cancel meeting                       │
│  POST   /v1/meetings/:id/join     Get room token to join (100ms)       │
│  POST   /v1/meetings/:id/end      End meeting + save recording         │
│  GET    /v1/meetings/:id/participants  Get participant list             │
│  GET    /v1/meetings/:id/recording Get recording URL                    │
├──────────────────────────────────────────────────────────────────────────┤
│  ACADEMIC ENDPOINTS                                                      │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/timetable               Student/Faculty timetable           │
│  GET    /v1/timetable/today         Today's schedule                    │
│  GET    /v1/courses                 List courses                        │
│  GET    /v1/results                 Student exam results                │
│  POST   /v1/results/entry          Faculty enters grades               │
│  GET    /v1/departments             List departments                    │
│  GET    /v1/sections                List sections                       │
├──────────────────────────────────────────────────────────────────────────┤
│  FEE ENDPOINTS                                                           │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/fees                    Student's fee records               │
│  GET    /v1/fees/:id                Fee record details                  │
│  POST   /v1/fees/pay               Initiate payment (create order)     │
│  POST   /v1/fees/verify            Verify payment signature             │
│  GET    /v1/fees/receipts           List payment receipts               │
│  GET    /v1/fees/receipts/:id/pdf  Download receipt PDF                 │
│  POST   /v1/webhooks/payment       Payment gateway webhook              │
├──────────────────────────────────────────────────────────────────────────┤
│  ADMIN ENDPOINTS                                                         │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/admin/dashboard         Admin dashboard stats               │
│  CRUD   /v1/admin/students          Student management                  │
│  CRUD   /v1/admin/faculty           Faculty management                  │
│  CRUD   /v1/admin/departments       Department management               │
│  CRUD   /v1/admin/timetable         Timetable management                │
│  CRUD   /v1/admin/fee-structures    Fee structure management            │
│  POST   /v1/admin/notifications     Send notifications                  │
│  GET    /v1/admin/reports/:type     Generate reports                    │
│  POST   /v1/admin/import/students   Bulk CSV import                     │
│  PUT    /v1/admin/settings          Update institution settings         │
│  PUT    /v1/admin/branding          Update white-label config           │
├──────────────────────────────────────────────────────────────────────────┤
│  NOTIFICATION ENDPOINTS                                                  │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/notifications           List notifications                  │
│  PUT    /v1/notifications/:id/read  Mark as read                        │
│  PUT    /v1/notifications/read-all  Mark all as read                    │
│  GET    /v1/notifications/unread-count  Unread count                    │
├──────────────────────────────────────────────────────────────────────────┤
│  AI/ANALYTICS ENDPOINTS                                                  │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/ai/attendance-prediction/:studentId   Predict attendance    │
│  GET    /v1/ai/dropout-risk/:studentId           Get dropout risk      │
│  GET    /v1/ai/department-insights/:deptId         Dept AI insights     │
│  GET    /v1/ai/performance-trend/:studentId       Performance trends   │
├──────────────────────────────────────────────────────────────────────────┤
│  SUPER ADMIN ENDPOINTS (Platform-Level)                                  │
├──────────────────────────────────────────────────────────────────────────┤
│  CRUD   /v1/super/tenants           Manage institutions                 │
│  GET    /v1/super/analytics         Platform-wide analytics             │
│  GET    /v1/super/billing           Revenue & subscription reports      │
│  POST   /v1/super/tenants/:id/activate   Activate tenant               │
│  POST   /v1/super/tenants/:id/suspend    Suspend tenant                │
│  GET    /v1/super/health            Platform health check               │
├──────────────────────────────────────────────────────────────────────────┤
│  FILE UPLOAD ENDPOINT                                                    │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/upload                  Upload file to R2, returns URL      │
│  GET    /v1/files/:key              Get pre-signed download URL         │
└──────────────────────────────────────────────────────────────────────────┘
```

### Sample API: Mark Attendance (Hono)

```typescript
// workers/src/modules/attendance/attendance.routes.ts
import { Hono } from 'hono';
import { authMiddleware } from '../../middleware/auth.middleware';
import { rbac } from '../../middleware/rbac.middleware';
import { zValidator } from '@hono/zod-validator';
import { z } from 'zod';

const markAttendanceSchema = z.object({
  courseId: z.string().uuid(),
  latitude: z.number().min(-90).max(90),
  longitude: z.number().min(-180).max(180),
  deviceId: z.string(),
  timetableEntryId: z.string().uuid().optional(),
});

const attendance = new Hono();

attendance.post(
  '/mark',
  authMiddleware,
  rbac(['student']),
  zValidator('json', markAttendanceSchema),
  async (c) => {
    const { tenantId, userId } = c.get('auth');
    const body = c.req.valid('json');
    const supabase = c.get('supabase');

    // 1. Get campus coordinates from tenant config
    const { data: tenant } = await supabase
      .from('tenants')
      .select('campus_lat, campus_lng, campus_radius')
      .eq('id', tenantId)
      .single();

    // 2. Calculate distance using Haversine formula
    const distance = haversineDistance(
      body.latitude, body.longitude,
      tenant.campus_lat, tenant.campus_lng
    );

    if (distance > tenant.campus_radius) {
      return c.json({
        success: false,
        error: 'Outside campus geofence',
        distance: Math.round(distance),
        maxAllowed: tenant.campus_radius,
      }, 403);
    }

    // 3. Check time window
    const now = new Date();
    const { data: timetableEntry } = await supabase
      .from('timetable_entries')
      .select('start_time, end_time')
      .eq('id', body.timetableEntryId)
      .single();

    // Allow marking within first 10 minutes of class
    // ... time validation logic ...

    // 4. Check device fingerprint
    const { data: student } = await supabase
      .from('students')
      .select('id')
      .eq('user_id', userId)
      .single();

    // 5. Insert attendance record
    const { data: record, error } = await supabase
      .from('attendance_records')
      .insert({
        tenant_id: tenantId,
        student_id: student.id,
        course_id: body.courseId,
        date: new Date().toISOString().split('T')[0],
        period_number: timetableEntry.period_number,
        status: 'present',
        marked_by: 'student_gps',
        latitude: body.latitude,
        longitude: body.longitude,
        distance_from_campus: Math.round(distance),
        device_id: body.deviceId,
        is_within_geofence: true,
      })
      .select()
      .single();

    if (error) {
      return c.json({ success: false, error: error.message }, 400);
    }

    return c.json({
      success: true,
      data: {
        id: record.id,
        status: 'present',
        markedAt: record.created_at,
        distance: Math.round(distance),
      },
      message: 'Attendance marked successfully ✅',
    });
  }
);

export { attendance };
```

### Hono App Entry Point

```typescript
// workers/src/index.ts
import { Hono } from 'hono';
import { cors } from 'hono/cors';
import { logger } from 'hono/logger';
import { tenantMiddleware } from './middleware/tenant.middleware';
import { authRoutes } from './modules/auth/auth.routes';
import { attendance } from './modules/attendance/attendance.routes';
import { assignments } from './modules/assignments/assignment.routes';
import { chatrooms } from './modules/chatroom/chatroom.routes';
import { meetings } from './modules/meetings/meeting.routes';
import { fees } from './modules/fees/fee.routes';
import { admin } from './modules/admin/admin.routes';
import { notifications } from './modules/notification/notification.routes';
import { upload } from './modules/upload/upload.routes';

type Bindings = {
  SUPABASE_URL: string;
  SUPABASE_SERVICE_KEY: string;
  UPSTASH_REDIS_URL: string;
  UPSTASH_REDIS_TOKEN: string;
  R2_BUCKET: R2Bucket;
  RESEND_API_KEY: string;
  MSG91_AUTH_KEY: string;
  JWT_SECRET: string;
  JWT_REFRESH_SECRET: string;
  HMAC_100MS_SECRET: string;
};

const app = new Hono<{ Bindings: Bindings }>();

// Global middleware
app.use('*', logger());
app.use('*', cors({
  origin: (origin) => origin, // Tenant-specific CORS handled in tenant middleware
  credentials: true,
}));
app.use('/v1/*', tenantMiddleware);

// Routes
app.route('/v1/auth', authRoutes);
app.route('/v1/attendance', attendance);
app.route('/v1/assignments', assignments);
app.route('/v1/chatrooms', chatrooms);
app.route('/v1/meetings', meetings);
app.route('/v1/fees', fees);
app.route('/v1/admin', admin);
app.route('/v1/notifications', notifications);
app.route('/v1/upload', upload);

// Health check
app.get('/health', (c) => c.json({ status: 'ok', service: 'campussphere-api' }));

export default app;
```

---

> **→ Continue to [Part 3: Core Modules](./Roadmap_Part3_Core_Modules.md)**
