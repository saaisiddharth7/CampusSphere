# CampusSphere – Complete Roadmap

## Part 9: Academic Enhancement Modules – Calendar, Exam Timetables, Study Materials & Research Papers

> **Document Series:** Part 9 of 13
> **Continues from:** [Part 8: Business Model & Timeline](./Roadmap_Part8_Business_Timeline.md)

---

## 9.1 Academic Calendar Module

### Overview

The Academic Calendar is an institution-wide event and schedule management system synchronized across student, faculty, and admin apps. It serves as the single source of truth for all date-based academic activities.

### Feature Breakdown

```
┌──────────────────────────────────────────────────────────────────────┐
│              ACADEMIC CALENDAR – FEATURES                             │
│                                                                      │
│  Calendar Types:                                                     │
│  ├── 📅 Academic Calendar (semester dates, exam windows)            │
│  ├── 🎓 Exam Schedule (internal, semester, supplementary)           │
│  ├── 🏖️ Holiday Calendar (national, state, institutional)           │
│  ├── 🎪 Events (cultural fests, tech fests, workshops)              │
│  └── 📋 Custom (admin-defined recurring events)                     │
│                                                                      │
│  Scoping:                                                            │
│  ├── Institution-wide (visible to everyone)                         │
│  ├── Department-specific (only that dept sees it)                   │
│  ├── Program-specific (B.Tech vs M.Tech events)                    │
│  ├── Section-specific (class tests, tutorials)                      │
│  └── Personal (student/faculty personal reminders)                  │
│                                                                      │
│  Features:                                                           │
│  ├── Month/Week/Day/Agenda views                                    │
│  ├── Color-coded by event type                                      │
│  ├── Push reminders (1 day before, 1 hour before)                   │
│  ├── iCal export / Google Calendar sync                             │
│  ├── Recurring events (weekly labs, monthly meetings)               │
│  ├── Conflict detection (overlapping exams/events)                  │
│  └── Admin approval workflow for student-proposed events            │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/010_academic_calendar.sql

CREATE TABLE calendar_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  created_by UUID NOT NULL REFERENCES users(id),

  title TEXT NOT NULL,
  description TEXT,
  event_type TEXT NOT NULL CHECK (event_type IN (
    'academic', 'exam', 'holiday', 'cultural', 'sports',
    'workshop', 'seminar', 'placement', 'meeting', 'custom'
  )),

  -- Timing
  start_date DATE NOT NULL,
  end_date DATE,                                  -- NULL for single-day events
  start_time TIME,                                -- NULL for all-day events
  end_time TIME,
  is_all_day BOOLEAN DEFAULT true,
  timezone TEXT DEFAULT 'Asia/Kolkata',

  -- Recurrence
  is_recurring BOOLEAN DEFAULT false,
  recurrence_rule TEXT,                           -- iCal RRULE format
  recurrence_end DATE,

  -- Scoping
  scope TEXT DEFAULT 'institution' CHECK (scope IN (
    'institution', 'department', 'program', 'section', 'personal'
  )),
  department_id UUID REFERENCES departments(id),
  program_id UUID REFERENCES programs(id),
  section_id UUID REFERENCES sections(id),

  -- Location
  venue TEXT,
  is_online BOOLEAN DEFAULT false,
  meeting_link TEXT,                              -- If online event

  -- Status
  status TEXT DEFAULT 'published' CHECK (status IN ('draft', 'pending_approval', 'published', 'cancelled')),
  priority TEXT DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),

  -- Visual
  color TEXT,                                     -- Hex color for calendar UI
  attachment_urls JSONB DEFAULT '[]',             -- R2 URLs for event docs

  -- Notification
  notify_before JSONB DEFAULT '[1440, 60]',       -- Minutes before: [1 day, 1 hour]

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Calendar event RSVPs (for events that need registration)
CREATE TABLE calendar_rsvps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  event_id UUID NOT NULL REFERENCES calendar_events(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  rsvp_status TEXT DEFAULT 'going' CHECK (rsvp_status IN ('going', 'maybe', 'not_going')),
  checked_in BOOLEAN DEFAULT false,
  checked_in_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(event_id, user_id)
);

CREATE INDEX idx_calendar_tenant_date ON calendar_events(tenant_id, start_date, end_date);
CREATE INDEX idx_calendar_scope ON calendar_events(tenant_id, scope, department_id);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  ACADEMIC CALENDAR ENDPOINTS                                             │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/calendar/events              Create event (admin/faculty)    │
│  GET    /v1/calendar/events              List events (filtered by scope) │
│  GET    /v1/calendar/events/:id          Get event details               │
│  PUT    /v1/calendar/events/:id          Update event                    │
│  DELETE /v1/calendar/events/:id          Cancel/delete event             │
│  GET    /v1/calendar/month/:year/:month  Get month view events           │
│  GET    /v1/calendar/today               Today's events                  │
│  GET    /v1/calendar/upcoming            Next 7 days                     │
│  POST   /v1/calendar/events/:id/rsvp     RSVP to event                  │
│  POST   /v1/calendar/events/:id/checkin  QR check-in at event           │
│  GET    /v1/calendar/export/ical         Export as iCal file             │
│  GET    /v1/calendar/holidays            List holidays for academic year │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Academic Calendar (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Academic Calendar        📅  + ▼  │
├───────────────────────────────────────┤
│                                       │
│  [Month ▼] [Week] [Day] [Agenda]     │
│                                       │
│        ◄  February 2026  ►           │
│  Mo  Tu  We  Th  Fr  Sa  Su         │
│   2   3   4   5   6   7   8         │
│   9  10  11  12  13  14  15         │
│  16  17  18  19 [20] 21  22         │
│  23  24 •25 •26  27 •28   1         │
│                                       │
│  Color Legend:                        │
│  🔴 Exam  🟢 Holiday  🔵 Event       │
│  🟡 Deadline  🟣 Meeting             │
│                                       │
│  ── Feb 20 (Today) ──────────────── │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🔵 09:00 – Tech Talk Series   │  │
│  │  "Intro to Cloud Computing"    │  │
│  │  📍 Seminar Hall 1  | CSE Dept  │  │
│  │  👥 42 going                    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🟡 11:59 PM – Assignment Due   │  │
│  │  "ER Diagram – Library System"  │  │
│  │  DBMS (CS301)                   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ── Feb 25 (Tue) ────────────────── │
│  ┌─────────────────────────────────┐  │
│  │  🔴 Internal Exam 1 Begins     │  │
│  │  All departments               │  │
│  │  📍 Respective exam halls       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ── Feb 28 (Fri) ────────────────── │
│  ┌─────────────────────────────────┐  │
│  │  🟢 National Science Day       │  │
│  │  Holiday (full day)             │  │
│  └─────────────────────────────────┘  │
│                                       │
├─────┬──────┬──────┬──────┬──────┤    │
│ 🏠  │  📅  │  📍  │  💬  │  👤  │    │
└─────┴──────┴──────┴──────┴──────┘    │
```

---

## 9.2 Exam Timetable Module

### Overview

A dedicated exam scheduling system that handles internal assessments, semester exams, supplementary exams, and practicals. Separate from the regular class timetable, with special features like seating arrangement, hall ticket generation, and invigilation duty assignment.

### Feature Breakdown

```
┌──────────────────────────────────────────────────────────────────────┐
│              EXAM TIMETABLE – FEATURES                                │
│                                                                      │
│  Exam Types Supported:                                               │
│  ├── Internal Assessment 1, 2, 3 (CIE – Continuous Internal Eval)  │
│  ├── Semester End Examination (SEE)                                  │
│  ├── Supplementary / Re-exam                                         │
│  ├── Lab Practical / Viva                                            │
│  └── Online Quiz / MCQ Test                                          │
│                                                                      │
│  Admin Capabilities:                                                 │
│  ├── Create exam schedule per department/program/semester            │
│  ├── Assign exam halls + seating arrangement                        │
│  ├── Assign invigilation duties to faculty                          │
│  ├── Auto-generate hall tickets (PDF with QR)                       │
│  ├── Mark exam attendance separately                                 │
│  └── Publish results with grade mapping                             │
│                                                                      │
│  Student Features:                                                   │
│  ├── View exam schedule per semester                                │
│  ├── Download hall ticket (PDF from R2)                              │
│  ├── Countdown timer to next exam                                    │
│  ├── Subject-wise syllabus coverage indicator                       │
│  └── Push notification: "CS301 Exam tomorrow at 10 AM, Hall B-201" │
│                                                                      │
│  Conflict Detection:                                                 │
│  ├── Same student has 2 exams at same time → flag                   │
│  ├── Faculty invigilation clash → auto-suggest swap                 │
│  └── Hall capacity exceeded → alert admin                           │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/011_exams.sql

-- Exam Sessions (e.g., "Internal 1 – Feb 2026", "Sem End – May 2026")
CREATE TABLE exam_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name TEXT NOT NULL,                             -- "Internal Assessment 1"
  exam_type TEXT NOT NULL CHECK (exam_type IN (
    'internal_1', 'internal_2', 'internal_3',
    'semester', 'supplementary', 'practical', 'quiz'
  )),
  academic_year TEXT NOT NULL,
  semester INT,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'in_progress', 'completed', 'results_published')),
  instructions TEXT,                              -- General exam instructions
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Exam Timetable Entries (specific exam slots)
CREATE TABLE exam_timetable_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  exam_session_id UUID NOT NULL REFERENCES exam_sessions(id) ON DELETE CASCADE,
  course_id UUID NOT NULL REFERENCES courses(id),
  department_id UUID NOT NULL REFERENCES departments(id),
  program_id UUID REFERENCES programs(id),
  semester INT NOT NULL,

  -- Schedule
  exam_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  duration_minutes INT NOT NULL,                  -- 90 (internal) / 180 (semester)

  -- Venue
  exam_hall TEXT,
  building TEXT,
  max_capacity INT,

  -- Settings
  max_marks DECIMAL NOT NULL,
  passing_marks DECIMAL,
  is_open_book BOOLEAN DEFAULT false,

  -- Syllabus Coverage
  syllabus_units TEXT[],                          -- ["Unit 1", "Unit 2", "Unit 3"]

  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, exam_session_id, course_id, exam_date)
);

-- Exam Seating Arrangement
CREATE TABLE exam_seating (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  exam_entry_id UUID NOT NULL REFERENCES exam_timetable_entries(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES students(id),
  seat_number TEXT NOT NULL,
  hall TEXT NOT NULL,
  row_number INT,
  column_number INT,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(exam_entry_id, student_id)
);

-- Invigilation Duties
CREATE TABLE exam_invigilation (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  exam_entry_id UUID NOT NULL REFERENCES exam_timetable_entries(id) ON DELETE CASCADE,
  faculty_id UUID NOT NULL REFERENCES faculty(id),
  hall TEXT NOT NULL,
  role TEXT DEFAULT 'invigilator' CHECK (role IN ('chief_invigilator', 'invigilator', 'flying_squad')),
  confirmed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(exam_entry_id, faculty_id)
);

-- Hall Tickets
CREATE TABLE hall_tickets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  exam_session_id UUID NOT NULL REFERENCES exam_sessions(id),
  ticket_number TEXT NOT NULL,
  pdf_url TEXT,                                   -- R2 URL
  qr_code_data TEXT,                              -- For verification
  is_eligible BOOLEAN DEFAULT true,               -- Blocked if att < 75% or fees unpaid
  blocked_reason TEXT,
  generated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, student_id, exam_session_id)
);

CREATE INDEX idx_exam_tt_session ON exam_timetable_entries(tenant_id, exam_session_id);
CREATE INDEX idx_exam_tt_date ON exam_timetable_entries(tenant_id, exam_date);
CREATE INDEX idx_hall_tickets_student ON hall_tickets(tenant_id, student_id);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  EXAM TIMETABLE ENDPOINTS                                                │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/exams/sessions               Create exam session             │
│  GET    /v1/exams/sessions               List exam sessions              │
│  PUT    /v1/exams/sessions/:id           Update session                  │
│  POST   /v1/exams/sessions/:id/publish   Publish timetable              │
│  CRUD   /v1/exams/timetable             Exam timetable entries          │
│  GET    /v1/exams/timetable/student      Student's exam schedule         │
│  GET    /v1/exams/timetable/faculty      Faculty invigilation schedule   │
│  POST   /v1/exams/seating/generate      Auto-generate seating           │
│  GET    /v1/exams/seating/:entryId      Get seating arrangement          │
│  POST   /v1/exams/invigilation/assign    Assign invigilation duties     │
│  GET    /v1/exams/hall-ticket/:sessionId Generate/get hall ticket        │
│  GET    /v1/exams/hall-ticket/:id/pdf    Download hall ticket PDF        │
│  POST   /v1/exams/hall-ticket/verify     QR verify hall ticket          │
│  GET    /v1/exams/conflicts              Detect scheduling conflicts     │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Exam Timetable (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Exam Schedule           📥 Hall   │
│                             Ticket    │
├───────────────────────────────────────┤
│                                       │
│  🔴 Internal Assessment 1            │
│  Feb 25 – Mar 01, 2026               │
│  Status: Published ✅                 │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Date    │ Subject  │ Time       │  │
│  ├─────────┼──────────┼────────────┤  │
│  │ Feb 25  │ DBMS     │ 10:00-11:30│  │
│  │ (Tue)   │ CS301    │ Hall: B-201│  │
│  │         │          │ Seat: R3C5 │  │
│  ├─────────┼──────────┼────────────┤  │
│  │ Feb 26  │ OS       │ 10:00-11:30│  │
│  │ (Wed)   │ CS302    │ Hall: B-202│  │
│  │         │          │ Seat: R2C8 │  │
│  ├─────────┼──────────┼────────────┤  │
│  │ Feb 27  │ Math III │ 02:00-03:30│  │
│  │ (Thu)   │ MA201    │ Hall: A-101│  │
│  │         │          │ Seat: R5C3 │  │
│  ├─────────┼──────────┼────────────┤  │
│  │ Feb 28  │ 🟢 HOLIDAY (Nat. Sci)│  │
│  ├─────────┼──────────┼────────────┤  │
│  │ Mar 01  │ DS       │ 10:00-11:30│  │
│  │ (Sat)   │ CS201    │ Hall: B-201│  │
│  │         │          │ Seat: R3C5 │  │
│  └─────────┴──────────┴────────────┘  │
│                                       │
│  ⏰ Next Exam: DBMS – Feb 25 (5 days) │
│                                       │
│  📋 Syllabus Coverage:                │
│  ├── DBMS: Unit 1-3 (ER, Relational, │
│  │   Normalization, SQL)              │
│  ├── OS: Unit 1-2 (Process, Threads) │
│  └── Math: Unit 1-3 (Matrices,       │
│      Transforms, Series)             │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📥 DOWNLOAD HALL TICKET (PDF)  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ⚠️ Eligibility: ✅ All subjects       │
│  (Attendance ≥ 75%, Fees paid)        │
│                                       │
└───────────────────────────────────────┘
```

### Wireframe: Hall Ticket (PDF)

```
┌──────────────────────────────────────────────────┐
│  ┌──────────┐                                    │
│  │  [LOGO]  │  XYZ Engineering College           │
│  │          │  (Affiliated to Anna University)    │
│  └──────────┘  Coimbatore, Tamil Nadu - 641014   │
│                                                   │
│  ═══════════════════════════════════════          │
│           HALL TICKET / ADMIT CARD                │
│       Internal Assessment 1 – Feb 2026            │
│  ═══════════════════════════════════════          │
│                                                   │
│  Name:         Rahul Kumar                 ┌────┐│
│  Roll No:      21CS101                     │ QR ││
│  Reg No:       RA2021003011030             │CODE││
│  Department:   Computer Science & Engg.    └────┘│
│  Program:      B.Tech (CSE)                      │
│  Semester:     3rd | Batch: 2024-28              │
│                                                   │
│  ┌────────────────────────────────────────────┐  │
│  │ Date     Subject     Time       Hall  Seat │  │
│  ├────────────────────────────────────────────┤  │
│  │ Feb 25   CS301-DBMS  10:00-11:30 B201 R3C5│  │
│  │ Feb 26   CS302-OS    10:00-11:30 B202 R2C8│  │
│  │ Feb 27   MA201-Math  02:00-03:30 A101 R5C3│  │
│  │ Mar 01   CS201-DS    10:00-11:30 B201 R3C5│  │
│  │ Mar 02   HS201-Eng   10:00-11:30 B201 R3C5│  │
│  │ Mar 04   CS201L-Lab  09:00-12:00 CL-1  —  │  │
│  └────────────────────────────────────────────┘  │
│                                                   │
│  Instructions:                                    │
│  1. Report 15 minutes before exam start time     │
│  2. Carry this hall ticket + college ID           │
│  3. Electronic devices are not allowed            │
│  4. Use blue/black pen only                       │
│                                                   │
│  ──────────────     ──────────────                │
│  Student Signature   Controller of Examinations   │
│                                                   │
│              Powered by CampusSphere              │
└──────────────────────────────────────────────────┘
```

---

## 9.3 Study Materials Module (Faculty-Shared Resources)

### Overview

Faculty can upload and organize study materials (notes, slides, PDFs, videos, code files) per subject and unit. Students access materials organized by their courses, creating a structured digital learning library.

### Feature Breakdown

```
┌──────────────────────────────────────────────────────────────────────┐
│              STUDY MATERIALS – FEATURES                               │
│                                                                      │
│  Faculty Can:                                                        │
│  ├── Upload materials per course + unit/module                      │
│  ├── Organize into folders (Unit 1, Unit 2, etc.)                   │
│  ├── Support file types: PDF, PPT, DOCX, MP4, ZIP, code files      │
│  ├── Add text notes / markdown descriptions                         │
│  ├── Add external links (YouTube, Google Drive, etc.)               │
│  ├── Set visibility (publish date, section-specific)                │
│  ├── Pin important materials                                         │
│  └── Usage analytics (views, downloads per material)                │
│                                                                      │
│  Students Can:                                                       │
│  ├── Browse materials by subject → unit/module                      │
│  ├── Download/view materials                                         │
│  ├── Bookmark materials for quick access                            │
│  ├── Get notified when new material is uploaded                     │
│  └── Offline download for later viewing                             │
│                                                                      │
│  Organization Hierarchy:                                             │
│  Course → Module/Unit → Materials                                    │
│  Example:                                                            │
│  CS301-DBMS                                                          │
│  ├── Unit 1: Introduction to DBMS                                   │
│  │   ├── 📄 DBMS_Unit1_Notes.pdf                                   │
│  │   ├── 📊 DBMS_Ch1_Slides.pptx                                  │
│  │   └── 🔗 YouTube: "DBMS Basics" (external link)                │
│  ├── Unit 2: ER Modeling                                             │
│  │   ├── 📄 ER_Diagram_Tutorial.pdf                                │
│  │   └── 📄 ER_Practice_Problems.pdf                               │
│  └── Unit 3: Normalization                                           │
│      ├── 📄 Normalization_Notes.pdf                                 │
│      └── 📦 Normalization_Examples.zip                              │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/012_study_materials.sql

-- Course Modules / Units (organizational structure)
CREATE TABLE course_modules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  name TEXT NOT NULL,                             -- "Unit 1: Introduction to DBMS"
  module_number INT NOT NULL,                     -- 1, 2, 3...
  description TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, course_id, module_number)
);

-- Study Materials
CREATE TABLE study_materials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  course_id UUID NOT NULL REFERENCES courses(id),
  module_id UUID REFERENCES course_modules(id),
  uploaded_by UUID NOT NULL REFERENCES faculty(id),

  title TEXT NOT NULL,
  description TEXT,
  material_type TEXT NOT NULL CHECK (material_type IN (
    'pdf', 'ppt', 'document', 'video', 'image', 'code',
    'archive', 'link', 'note'
  )),

  -- Content
  file_url TEXT,                                  -- R2 URL for uploaded files
  file_size_bytes BIGINT,
  file_name TEXT,                                 -- Original filename
  external_url TEXT,                              -- For YouTube, Google Drive links
  text_content TEXT,                              -- For markdown notes

  -- Metadata
  tags TEXT[],                                    -- ["normalization", "3NF", "BCNF"]
  is_pinned BOOLEAN DEFAULT false,
  is_published BOOLEAN DEFAULT true,
  publish_date TIMESTAMPTZ,
  section_ids UUID[],                             -- If limited to specific sections

  -- Analytics
  view_count INT DEFAULT 0,
  download_count INT DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Bookmarks (students bookmark materials)
CREATE TABLE material_bookmarks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  material_id UUID NOT NULL REFERENCES study_materials(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(student_id, material_id)
);

CREATE INDEX idx_materials_course ON study_materials(tenant_id, course_id, module_id);
CREATE INDEX idx_materials_faculty ON study_materials(tenant_id, uploaded_by);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  STUDY MATERIALS ENDPOINTS                                               │
├──────────────────────────────────────────────────────────────────────────┤
│  CRUD   /v1/courses/:courseId/modules        Course modules/units        │
│  POST   /v1/materials                        Upload study material       │
│  GET    /v1/materials?courseId=X&moduleId=Y   List materials (filtered)   │
│  GET    /v1/materials/:id                    Get material details         │
│  PUT    /v1/materials/:id                    Update material              │
│  DELETE /v1/materials/:id                    Delete material              │
│  GET    /v1/materials/:id/download           Get pre-signed download URL │
│  POST   /v1/materials/:id/bookmark           Bookmark material           │
│  DELETE /v1/materials/:id/bookmark           Remove bookmark             │
│  GET    /v1/materials/bookmarks              List bookmarked materials   │
│  GET    /v1/materials/analytics/:courseId     Material usage analytics    │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Study Materials (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Study Materials         🔍  📥    │
├───────────────────────────────────────┤
│                                       │
│  [All Subjects ▼]                     │
│                                       │
│  📚 CS301 – DBMS (Prof. Lakshmi P)   │
│  ──────────────────────────────────── │
│                                       │
│  📁 Unit 1: Introduction to DBMS     │
│  ┌─────────────────────────────────┐  │
│  │  📄 DBMS_Unit1_Notes.pdf        │  │
│  │  2.1 MB | Prof. Lakshmi P       │  │
│  │  Feb 10 | 👁 145 views          │  │
│  │  [📥 Download] [🔖 Bookmark]   │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │  📊 DBMS_Ch1_Slides.pptx       │  │
│  │  5.3 MB | Prof. Lakshmi P       │  │
│  │  Feb 12 | 👁 98 views           │  │
│  │  [📥 Download] [🔖 Bookmark]   │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │  🔗 YouTube: "DBMS Basics"     │  │
│  │  External link | Added Feb 10   │  │
│  │  [🔗 Open Link]                │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📁 Unit 2: ER Modeling              │
│  ┌─────────────────────────────────┐  │
│  │  📌 ER_Diagram_Tutorial.pdf     │  │
│  │  3.4 MB | Pinned by Prof.       │  │
│  │  Feb 15 | 👁 210 views          │  │
│  │  [📥 Download] [🔖 Bookmark]   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📁 Unit 3: Normalization      NEW 🔴│
│  ┌─────────────────────────────────┐  │
│  │  📄 Normalization_Notes.pdf     │  │
│  │  1.8 MB | Uploaded today        │  │
│  │  [📥 Download] [🔖 Bookmark]   │  │
│  └─────────────────────────────────┘  │
│                                       │
├─────┬──────┬──────┬──────┬──────┤    │
│ 🏠  │  📅  │  📍  │  💬  │  👤  │    │
└─────┴──────┴──────┴──────┴──────┘    │
```

---

## 9.4 Research Paper Repository

### Overview

A digital library for faculty and PG/PhD students to upload, share, and discover research papers within the institution. Supports paper indexing, citation tracking, and collaboration.

### Database Schema

```sql
-- supabase/migrations/013_research_papers.sql

CREATE TABLE research_papers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  -- Authors
  primary_author_id UUID NOT NULL REFERENCES users(id),
  co_authors JSONB DEFAULT '[]',                  -- [{userId, name, affiliation}]

  -- Paper Details
  title TEXT NOT NULL,
  abstract TEXT NOT NULL,
  keywords TEXT[] NOT NULL,
  domain TEXT,                                    -- "Machine Learning", "VLSI", etc.
  department_id UUID REFERENCES departments(id),

  -- Publication
  published_in TEXT,                              -- Journal/Conference name
  publication_date DATE,
  doi TEXT,                                       -- Digital Object Identifier
  isbn TEXT,
  volume TEXT,
  pages TEXT,
  publisher TEXT,
  publication_type TEXT CHECK (publication_type IN (
    'journal', 'conference', 'thesis', 'working_paper', 'preprint'
  )),

  -- File
  pdf_url TEXT NOT NULL,                          -- R2 URL
  file_size_bytes BIGINT,

  -- Status
  status TEXT DEFAULT 'published' CHECK (status IN ('draft', 'under_review', 'published', 'archived')),
  is_public BOOLEAN DEFAULT true,                 -- Visible to all in institution

  -- Metrics
  view_count INT DEFAULT 0,
  download_count INT DEFAULT 0,
  citation_count INT DEFAULT 0,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_research_tenant ON research_papers(tenant_id, department_id);
CREATE INDEX idx_research_keywords ON research_papers USING GIN(keywords);
CREATE INDEX idx_research_author ON research_papers(tenant_id, primary_author_id);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  RESEARCH PAPER ENDPOINTS                                                │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/research                    Upload research paper            │
│  GET    /v1/research                    List papers (search + filter)    │
│  GET    /v1/research/:id                Get paper details                │
│  PUT    /v1/research/:id                Update paper metadata            │
│  DELETE /v1/research/:id                Delete paper                     │
│  GET    /v1/research/:id/download       Download PDF                     │
│  GET    /v1/research/search?q=keyword    Full-text search               │
│  GET    /v1/research/author/:userId     Papers by author                 │
│  GET    /v1/research/department/:deptId  Papers by department           │
│  GET    /v1/research/stats              Repository statistics           │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Research Repository (Web/Admin)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  📚 Research Repository                                                  │
│  ───────────────────────────────                                        │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  🔍 Search papers...     [Dept ▼] [Type ▼] [Year ▼] [+ Upload]  │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  Repository Stats: 234 papers | 42 faculty | 8 departments             │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  📄 Deep Learning Approaches for Crop Disease Detection           │ │
│  │  Dr. Lakshmi P, Prof. Kumar V                                     │ │
│  │  IEEE Conference on AgriTech 2025 | CSE Dept                      │ │
│  │  Tags: deep-learning, agriculture, CNN                             │ │
│  │  📊 56 views | 23 downloads | DOI: 10.1109/xyz                   │ │
│  │  [📥 Download PDF] [📋 Cite]                                      │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  📄 Energy Efficient Routing in IoT Sensor Networks               │ │
│  │  Dr. Rajan S                                                       │ │
│  │  Springer Journal of Network Computing 2025 | ECE Dept            │ │
│  │  Tags: IoT, routing, energy-efficiency                             │ │
│  │  📊 34 views | 12 downloads                                       │ │
│  │  [📥 Download PDF] [📋 Cite]                                      │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  [1] [2] [3] ... [Next ►]                                              │
└─────────────────────────────────────────────────────────────────────────┘
```

---

> **→ Continue to [Part 10: Campus Life & Governance Modules](./Roadmap_Part10_CampusLife_Governance.md)**
