# CampusSphere – Complete Roadmap

## Part 13: Advanced AI & Analytics – Chatbot, Learning Paths, Faculty Performance & Departmental Comparison

> **Document Series:** Part 13 of 13 (Final)
> **Continues from:** [Part 12: Career & Alumni](./Roadmap_Part12_Career_Alumni.md)

---

## 13.1 AI Chatbot (Campus Assistant)

### Overview

A natural language chatbot embedded in the mobile app and admin dashboard that answers student/faculty queries using platform data. Powered by a combination of intent classification + database queries, with optional LLM integration for complex queries.

### Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│              AI CHATBOT ARCHITECTURE                                  │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  User Message                                                  │  │
│  │  "When is my next DBMS class?"                                 │  │
│  └──────────────────────┬─────────────────────────────────────────┘  │
│                          │                                           │
│                          ▼                                           │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Intent Classifier (FastAPI + scikit-learn / LLM)              │  │
│  │  ─────────────────────────────────────────                     │  │
│  │  Detected Intent: TIMETABLE_QUERY                              │  │
│  │  Entities: {subject: "DBMS", time: "next"}                     │  │
│  │                                                                │  │
│  │  Supported Intents:                                            │  │
│  │  ├── TIMETABLE_QUERY    → "When is my next X class?"          │  │
│  │  ├── ATTENDANCE_QUERY   → "What's my attendance in X?"        │  │
│  │  ├── FEE_QUERY          → "How much fee is pending?"          │  │
│  │  ├── ASSIGNMENT_QUERY   → "Any pending assignments?"          │  │
│  │  ├── EXAM_QUERY         → "When is my next exam?"             │  │
│  │  ├── RESULT_QUERY       → "What was my CGPA?"                 │  │
│  │  ├── MEETING_QUERY      → "Any upcoming live classes?"        │  │
│  │  ├── HOSTEL_QUERY       → "What's today's mess menu?"         │  │
│  │  ├── PLACEMENT_QUERY    → "Upcoming placement drives?"        │  │
│  │  ├── MATERIAL_QUERY     → "Study notes for DBMS Unit 3?"     │  │
│  │  ├── LEAVE_QUERY        → "My leave request status?"          │  │
│  │  ├── GENERAL_FAQ        → "What's the library timing?"        │  │
│  │  └── UNKNOWN            → Fallback response                   │  │
│  └──────────────────────┬─────────────────────────────────────────┘  │
│                          │                                           │
│                          ▼                                           │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Query Resolver (Worker API / FastAPI)                          │  │
│  │  ─────────────────────────────────                              │  │
│  │  1. Map intent → Supabase query                                │  │
│  │  2. Execute query with student context (tenant, user ID)       │  │
│  │  3. Format response in natural language                        │  │
│  │                                                                │  │
│  │  Example: TIMETABLE_QUERY + {subject: "DBMS"}                 │  │
│  │  → SELECT * FROM timetable_entries                             │  │
│  │    WHERE course.name ILIKE '%DBMS%'                            │  │
│  │    AND day_of_week = EXTRACT(DOW FROM CURRENT_DATE)            │  │
│  │    AND section_id = student.section_id                         │  │
│  │  → "Your next DBMS class is today at 2:00 PM in Room 302      │  │
│  │     with Prof. Lakshmi P."                                     │  │
│  └──────────────────────┬─────────────────────────────────────────┘  │
│                          │                                           │
│                          ▼                                           │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Response to User                                              │  │
│  │  "📅 Your next DBMS class is today at 2:00 PM                 │  │
│  │   📍 Room 302 | 👩‍🏫 Prof. Lakshmi P                            │  │
│  │   📊 Your DBMS attendance: 85.2%"                              │  │
│  └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/023_chatbot.sql

-- Chatbot Conversation History
CREATE TABLE chatbot_conversations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  user_id UUID NOT NULL REFERENCES users(id),
  started_at TIMESTAMPTZ DEFAULT now(),
  last_message_at TIMESTAMPTZ DEFAULT now(),
  message_count INT DEFAULT 0
);

CREATE TABLE chatbot_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  conversation_id UUID NOT NULL REFERENCES chatbot_conversations(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('user', 'assistant')),
  content TEXT NOT NULL,
  intent TEXT,                                    -- Classified intent
  confidence DECIMAL(3,2),                        -- 0.00 to 1.00
  metadata JSONB DEFAULT '{}',                    -- Query details, entities
  created_at TIMESTAMPTZ DEFAULT now()
);

-- FAQ Knowledge Base (per tenant, admin-managed)
CREATE TABLE chatbot_faqs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  category TEXT,
  keywords TEXT[],
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_chatbot_conv ON chatbot_conversations(tenant_id, user_id);
CREATE INDEX idx_chatbot_faq ON chatbot_faqs USING GIN(keywords);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  AI CHATBOT ENDPOINTS                                                    │
├──────────────────────────────────────────────────────────────────────────┤
│  POST   /v1/chatbot/message             Send message, get response       │
│  GET    /v1/chatbot/conversations       List my conversations            │
│  GET    /v1/chatbot/conversations/:id   Conversation history             │
│  DELETE /v1/chatbot/conversations/:id   Delete conversation              │
│  CRUD   /v1/chatbot/faqs               Admin manages FAQ knowledge base │
│  GET    /v1/chatbot/analytics           Chatbot usage analytics         │
│  GET    /v1/chatbot/intents/stats       Most asked intent types         │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Chatbot (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Campus Assistant 🤖               │
├───────────────────────────────────────┤
│                                       │
│  🤖 Hi Rahul! I'm your campus        │
│  assistant. Ask me anything about     │
│  your classes, attendance, fees,      │
│  assignments, or campus life!         │
│                                       │
│             You               11:30   │
│             ┌────────────────────┐    │
│             │ When is my next    │    │
│             │ DBMS class?        │    │
│             └────────────────────┘    │
│                                       │
│  🤖 Assistant                 11:30   │
│  ┌─────────────────────────────────┐  │
│  │  📅 Your next DBMS class:       │  │
│  │  Today at 2:00 PM               │  │
│  │  📍 Room 302                    │  │
│  │  👩‍🏫 Prof. Lakshmi P              │  │
│  │  📊 Your DBMS attendance: 85.2% │  │
│  └─────────────────────────────────┘  │
│                                       │
│             You               11:31   │
│             ┌────────────────────┐    │
│             │ Any pending        │    │
│             │ assignments?       │    │
│             └────────────────────┘    │
│                                       │
│  🤖 Assistant                 11:31   │
│  ┌─────────────────────────────────┐  │
│  │  📝 You have 2 pending:        │  │
│  │                                 │  │
│  │  1. DB Normalization (DBMS)     │  │
│  │     Due: Feb 28 (5 days left)  │  │
│  │     Status: Not submitted       │  │
│  │                                 │  │
│  │  2. Process Scheduling (OS)     │  │
│  │     Due: Mar 1 (6 days left)   │  │
│  │     Status: Not submitted       │  │
│  │                                 │  │
│  │  💡 Tip: Submit DB Normal.      │  │
│  │  first – it's due sooner!       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  Quick Actions:                       │
│  [📊 Attendance] [💰 Fees] [📝 Assign]│
│                                       │
├───────────────────────────────────────┤
│ ┌──────────────────────────┐   📤    │
│ │ Ask me anything...       │         │
│ └──────────────────────────┘         │
└───────────────────────────────────────┘
```

---

## 13.2 Learning Path Recommendations

### Overview

AI-powered course and elective recommendations based on a student's academic performance, interests, career goals, and market demand. Uses collaborative filtering (students with similar profiles) and content-based filtering (subject difficulty vs student strength).

### Recommendation Engine

```
┌──────────────────────────────────────────────────────────────────────┐
│              LEARNING PATH ENGINE                                     │
│                                                                      │
│  Input Signals:                                                      │
│  ├── Student's grade history (subject-wise)                         │
│  ├── Attendance patterns per subject                                │
│  ├── Assignment submission rates per subject                        │
│  ├── Elective preferences (survey data)                             │
│  ├── Career goal (if specified: ML, Web Dev, Systems, etc.)        │
│  ├── Placement data (which skills get better packages)              │
│  └── Peer data (what similar students chose)                        │
│                                                                      │
│  Recommendation Types:                                               │
│  ├── 📚 Elective Selection                                          │
│  │   "Based on your A+ in DBMS and B in Math, we recommend         │
│  │    Machine Learning over Cryptography for next semester."        │
│  │                                                                   │
│  ├── 📖 Study Material Suggestions                                  │
│  │   "You scored B in Normalization. Here are 3 recommended         │
│  │    materials from your study materials library."                  │
│  │                                                                   │
│  ├── 🎯 Skill Gap Analysis                                          │
│  │   "For your goal of 'Full Stack Developer', you need:            │
│  │    ✅ DSA (strong) | ⚠️ Web Dev (no course taken) |             │
│  │    ❌ Cloud (not started). Recommended: Take CS405 Cloud."       │
│  │                                                                   │
│  └── 💼 Career-aligned Suggestions                                  │
│      "Students with profiles like yours who chose ML elective       │
│       had 35% higher placement rates at product companies."         │
│                                                                      │
│  Algorithm: Hybrid Recommender                                       │
│  ├── Content-based: Subject difficulty vs student aptitude           │
│  ├── Collaborative: Similar students' choices + outcomes            │
│  └── Rule-based: Department prerequisites + credit requirements     │
└──────────────────────────────────────────────────────────────────────┘
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  LEARNING PATH ENDPOINTS                                                 │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/ai/learning-path/:studentId       Full learning path         │
│  GET    /v1/ai/elective-recommendations       Elective recommendations  │
│  GET    /v1/ai/study-material-suggestions     Suggested study materials  │
│  GET    /v1/ai/skill-gap/:studentId           Skill gap analysis        │
│  POST   /v1/ai/career-goal                    Set career goal            │
│  GET    /v1/ai/career-path/:goal              Career path roadmap       │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Learning Path (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← My Learning Path          🤖      │
├───────────────────────────────────────┤
│                                       │
│  🎯 Career Goal: Full Stack Developer│
│  [Change Goal]                        │
│                                       │
│  📊 Skill Assessment:                 │
│  ┌─────────────────────────────────┐  │
│  │  ✅ Strong                      │  │
│  │  DATA STRUCTURES   █████████ A+ │  │
│  │  DBMS              ████████  A  │  │
│  │  OS                ████████  A  │  │
│  │                                 │  │
│  │  ⚠️ Developing                  │  │
│  │  JAVA PROGRAMMING  ██████    B+ │  │
│  │  MATH III          █████     B  │  │
│  │                                 │  │
│  │  ❌ Not Started                 │  │
│  │  WEB TECHNOLOGIES  ░░░░░░░░    │  │
│  │  CLOUD COMPUTING   ░░░░░░░░    │  │
│  │  DEVOPS            ░░░░░░░░    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📚 Recommended Electives (Sem 4):    │
│  ┌─────────────────────────────────┐  │
│  │  1. 🌟 Web Technologies (CS405) │  │
│  │  Match: 92% | Critical for goal│  │
│  │  "Covers React, Node.js, REST"  │  │
│  │                                 │  │
│  │  2. ☁️ Cloud Computing (CS407)  │  │
│  │  Match: 85% | High demand skill│  │
│  │  "AWS, Docker, Kubernetes"      │  │
│  │                                 │  │
│  │  3. 🤖 Machine Learning (CS409)│  │
│  │  Match: 78% | Your DBMS+Math   │  │
│  │  skills are a good foundation   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📖 Suggested Materials:              │
│  ├── "Improve Math III (currently B)" │
│  │   📄 Unit 3 Notes (Prof. Kumar)   │
│  │   🔗 Khan Academy: Linear Algebra │
│  └── "Start Web Tech basics now"     │
│      🔗 freeCodeCamp: HTML/CSS/JS    │
│                                       │
└───────────────────────────────────────┘
```

---

## 13.3 Faculty Performance Dashboard

### Overview

A comprehensive faculty evaluation system tracking teaching effectiveness, research output, administrative duties, and student feedback. Used by HODs and admin for performance reviews and workload analysis.

### Metrics Tracked

```
┌──────────────────────────────────────────────────────────────────────┐
│              FACULTY PERFORMANCE METRICS                              │
│                                                                      │
│  Teaching Metrics:                                                   │
│  ├── Total teaching hours (from timetable)                          │
│  ├── Classes actually conducted vs scheduled                        │
│  ├── Average student attendance in their classes                    │
│  ├── Number of study materials uploaded                             │
│  ├── Assignment creation + verification speed                       │
│  ├── Meeting sessions conducted                                     │
│  └── Student feedback scores (from course feedback surveys)         │
│                                                                      │
│  Research Metrics:                                                   │
│  ├── Papers published (from Research Repository)                    │
│  ├── Citation count                                                  │
│  ├── h-index (if available)                                         │
│  ├── Conference presentations                                       │
│  ├── PhD scholars guided                                             │
│  └── Patents filed                                                   │
│                                                                      │
│  Administrative Metrics:                                             │
│  ├── Invigilation duties completed                                  │
│  ├── Committee memberships                                          │
│  ├── Student mentee count + meeting frequency                       │
│  ├── Grievance resolution rate (if assigned)                        │
│  └── Training/FDP attended                                           │
│                                                                      │
│  Engagement Metrics:                                                 │
│  ├── Chatroom activity (messages, responses)                        │
│  ├── Average response time to student queries                       │
│  ├── Assignment feedback quality (avg. remark length)               │
│  └── Login frequency                                                │
└──────────────────────────────────────────────────────────────────────┘
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  FACULTY PERFORMANCE ENDPOINTS                                           │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/analytics/faculty/:id/dashboard    Faculty performance        │
│  GET    /v1/analytics/faculty/:id/teaching     Teaching metrics           │
│  GET    /v1/analytics/faculty/:id/research     Research metrics           │
│  GET    /v1/analytics/faculty/:id/feedback     Student feedback scores   │
│  GET    /v1/analytics/faculty/department/:id   Department faculty stats  │
│  GET    /v1/analytics/faculty/rankings         Faculty rankings          │
│  GET    /v1/analytics/faculty/workload         Workload distribution     │
│  GET    /v1/analytics/faculty/export           Export performance report │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Faculty Performance (Admin Dashboard)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  📊 Faculty Performance Dashboard                                        │
│  ──────────────────────────────────                                     │
│                                                                         │
│  Faculty: Prof. Lakshmi P | CSE Department | Employee: FAC-042          │
│  [Select Faculty ▼]  [Semester ▼]  [📥 Export PDF]                     │
│                                                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐    │
│  │ Teaching │ │ Research │ │ Student  │ │ Assign.  │ │ Overall  │    │
│  │ Hours    │ │ Papers   │ │ Feedback │ │ Speed    │ │ Score    │    │
│  │ 186/192  │ │ 3 this yr│ │ 4.2/5.0  │ │ 2.1 days │ │ 8.5/10   │    │
│  │ 97% ✅   │ │ 12 total │ │ ████     │ │ avg vrfy │ │ ████████ │    │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘    │
│                                                                         │
│  📈 Teaching Effectiveness:                                              │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ Course        Students  Avg Att%  Feedback  Materials  Assigns.  │ │
│  ├────────────────────────────────────────────────────────────────────┤ │
│  │ DBMS (CSE-3A)    52      82.3%    4.3/5     12 files   4 given  │ │
│  │ DBMS (CSE-3B)    48      79.1%    4.1/5     12 files   4 given  │ │
│  │ DB Lab (CSE-3A)  52      90.2%    4.5/5     3 files    2 given  │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  📚 Research Output:                                                     │
│  ├── IEEE Conference Paper (2025): Crop Disease Detection               │
│  ├── Springer Journal (2025): Graph Database Optimization               │
│  └── Conference Presentation: ACM India (2025)                          │
│                                                                         │
│  ⚡ Assignment Verification Speed:                                       │
│  ├── Average time to verify: 2.1 days                                   │
│  ├── Fastest: 4 hours (ER Diagram assignment)                           │
│  ├── Slowest: 5 days (DB Normalization) ⚠️                              │
│  └── Pending verifications: 26 submissions                              │
│                                                                         │
│  💬 Engagement: 85 chatroom messages | Avg response time: 45 min       │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 13.4 Departmental Comparison Analytics

### Overview

Admin and HOD-level analytics comparing key metrics across departments. Used for institutional benchmarking, resource allocation decisions, and accreditation reporting.

### Comparison Dimensions

```
┌──────────────────────────────────────────────────────────────────────┐
│              DEPARTMENTAL COMPARISON – DIMENSIONS                     │
│                                                                      │
│  Academic Performance:                                               │
│  ├── Average CGPA by department                                     │
│  ├── Pass percentage                                                │
│  ├── Topper CGPA and rank holders                                   │
│  └── Subject-wise difficulty index                                  │
│                                                                      │
│  Attendance:                                                         │
│  ├── Average attendance % per department                            │
│  ├── Students below 75% (at-risk count)                             │
│  ├── Best/worst sections                                            │
│  └── Day-wise/period-wise patterns                                  │
│                                                                      │
│  Assignments & Engagement:                                           │
│  ├── Assignment submission rate                                     │
│  ├── Average grades on assignments                                  │
│  ├── Faculty verification speed                                     │
│  └── Chatroom activity level                                        │
│                                                                      │
│  Placement:                                                          │
│  ├── Placement percentage                                           │
│  ├── Average/median package                                         │
│  ├── Top recruiters per department                                  │
│  └── Higher studies percentage                                      │
│                                                                      │
│  Operations:                                                         │
│  ├── Student-teacher ratio                                          │
│  ├── Infrastructure utilization                                     │
│  ├── Grievance resolution rate                                      │
│  └── Fee collection percentage                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  DEPARTMENTAL COMPARISON ENDPOINTS                                       │
├──────────────────────────────────────────────────────────────────────────┤
│  GET    /v1/analytics/departments/compare      Compare all departments  │
│  GET    /v1/analytics/departments/:id/metrics   Single dept metrics     │
│  GET    /v1/analytics/departments/attendance    Attendance comparison    │
│  GET    /v1/analytics/departments/results       Results comparison       │
│  GET    /v1/analytics/departments/placement     Placement comparison    │
│  GET    /v1/analytics/departments/engagement    Engagement comparison   │
│  GET    /v1/analytics/departments/trend         Semester-over-semester  │
│  GET    /v1/analytics/departments/export        Export comparison report│
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Departmental Comparison (Admin Dashboard)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  📊 Departmental Comparison – 2025-26 (Sem 3)                            │
│  ──────────────────────────────────────────                              │
│                                                                         │
│  [Attendance ▼] [📊 Table] [📈 Chart] [📥 Export NAAC]                  │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ Department │ Students │ Att%  │ CGPA  │ Place% │ Fee%   │ Score  │ │
│  ├────────────┼──────────┼───────┼───────┼────────┼────────┼────────┤ │
│  │ CSE        │ 480      │ 82.3% │ 7.8   │ 90.0%  │ 94.2%  │ ⭐ 9.1│ │
│  │ IT         │ 360      │ 80.1% │ 7.5   │ 85.0%  │ 91.0%  │ ⭐ 8.5│ │
│  │ ECE        │ 420      │ 78.5% │ 7.2   │ 72.0%  │ 88.5%  │ ⭐ 7.8│ │
│  │ EEE        │ 300      │ 76.2% │ 7.0   │ 68.0%  │ 85.0%  │ ⭐ 7.2│ │
│  │ MECH       │ 480      │ 74.1% │ 6.8   │ 56.7%  │ 82.3%  │ ⭐ 6.5│ │
│  │ CIVIL      │ 360      │ 72.5% │ 6.5   │ 50.0%  │ 80.1%  │ ⭐ 6.0│ │
│  └────────────┴──────────┴───────┴───────┴────────┴────────┴────────┘ │
│                                                                         │
│  📈 Attendance Comparison (Bar Chart):                                   │
│  CSE   ████████████████████ 82.3%                                       │
│  IT    ███████████████████  80.1%                                       │
│  ECE   ██████████████████   78.5%                                       │
│  EEE   █████████████████    76.2%                                       │
│  MECH  ████████████████     74.1% ⚠️ Below UGC target                   │
│  CIVIL ███████████████      72.5% 🔴 Below UGC minimum                  │
│                                                                         │
│  Key Insights (AI Generated):                                            │
│  ├── 🔴 CIVIL & MECH departments below 75% attendance threshold        │
│  ├── 🟢 CSE has highest placement rate (90%) and CGPA (7.8)            │
│  ├── ⚠️ MECH fee collection at 82.3% — follow up needed                │
│  └── 📈 IT department improved 5.2% in attendance over last semester    │
│                                                                         │
│  [📥 Export Full Report] [📧 Email to HODs] [📊 NAAC SSR Format]       │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 13.5 Complete Document Index (Updated)

```
CORE PLATFORM:
Part 1:  Architecture & Tech Stack
Part 2:  Database Schema & API Design
Part 3:  Core Modules (Attendance, Assignments, Chat, Meet)
Part 4:  Fees, Payments & White-Label Engine
Part 5:  AI/ML Analytics Layer
Part 6:  UI Wireframes (Original Screens)
Part 7:  Deployment, DevOps & Security
Part 8:  Business Model & Timeline

EXTENDED MODULES:
Part 9:  Academic Enhancement (Calendar, Exams, Study Materials, Research)
Part 10: Campus Life & Governance (Events, Grievance, Polls, Parent Portal)
Part 11: Campus Operations (Hostel, Inventory)
Part 12: Career & Alumni (Placement, Internship, Alumni Network)
Part 13: Advanced AI & Analytics (Chatbot, Learning Paths, Faculty Perf, Dept comparison)
```

---

**🎯 CampusSphere: 30+ Modules. One Platform. Every Campus Need.**

*CampusSphere™ – White-Label AI-Powered Campus Management Platform*
