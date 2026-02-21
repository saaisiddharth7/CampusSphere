# CampusSphere – Complete Roadmap

## Part 6: Complete ASCII UI Wireframes

> **Document Series:** Part 6 of 8
> **Continues from:** [Part 5: AI/ML Analytics](./Roadmap_Part5_AI_Analytics.md)

---

## 6.1 Student Mobile App Wireframes (Flutter)

### Login Screen

```
┌───────────────────────────────────────┐
│              [Status Bar]             │
├───────────────────────────────────────┤
│                                       │
│         ┌───────────────┐             │
│         │  📚 LOGO      │             │
│         │ [Institution  │             │
│         │   Logo Here]  │             │
│         └───────────────┘             │
│                                       │
│         Welcome to                    │
│     [Institution Name]               │
│      Powered by CampusSphere          │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ 📱  Phone Number                │  │
│  │     +91 98765 43210             │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ 🔒  Password                    │  │
│  │     ••••••••            👁      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │         🔑 LOGIN                │  │
│  │    [Primary Color Button]       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │      📲 LOGIN WITH OTP          │  │
│  │    [Secondary Outline Button]   │  │
│  └─────────────────────────────────┘  │
│                                       │
│         Forgot Password?              │
│                                       │
│                                       │
│  ─────────── or ───────────           │
│                                       │
│  🇮🇳 Developed for Indian Education   │
│                                       │
├───────────────────────────────────────┤
│  [Tenant Slug: xyz.campussphere.in]   │
└───────────────────────────────────────┘
```

### Student Dashboard (Home)

```
┌───────────────────────────────────────┐
│  ← Dashboard          🔔 3   👤      │
├───────────────────────────────────────┤
│                                       │
│  Good Morning, Rahul! 👋              │
│  B.Tech CSE – 3rd Sem | 21CS101      │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📅 Today's Classes             │  │
│  │                                 │  │
│  │  🟢 09:00  Data Structures  301 │  │
│  │  🟢 10:00  DBMS             302 │  │
│  │  🟡 11:00  OS (current)    301  │  │
│  │  ⚪ 01:00  Mathematics     Lab2 │  │
│  │  ⚪ 02:00  English         303  │  │
│  │  ⚪ 03:00  DS Lab          CL-1 │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📊 Attendance: 78.5%          │  │
│  │  ██████████████████░░░░ 78.5%  │  │
│  │  ⚠️ 3.5% above UGC minimum      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌────────┐┌────────┐┌────────┐      │
│  │  📍    ││  💰    ││  📝    │      │
│  │ Mark   ││ Pay    ││ Assign.│      │
│  │ Att.   ││ Fees   ││ (3)    │      │
│  └────────┘└────────┘└────────┘      │
│  ┌────────┐┌────────┐┌────────┐      │
│  │  💬    ││  📹    ││  📊    │      │
│  │ Chat   ││ Meet   ││ Results│      │
│  │ (5 new)││ Today  ││        │      │
│  └────────┘└────────┘└────────┘      │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🕐 Recent Activity             │  │
│  │  📝 New: DB Normalization       │  │
│  │     Due Feb 28 (5 days)          │  │
│  │  📹 DBMS Doubt Session          │  │
│  │     Tomorrow 3 PM               │  │
│  │  💬 3 new in CSE-3A chat        │  │
│  │  💰 Fee reminder: ₹16,375       │  │
│  └─────────────────────────────────┘  │
│                                       │
├─────┬──────┬──────┬──────┬──────┤    │
│ 🏠  │  📅  │  📍  │  💬  │  👤  │    │
│Home │Time  │Attend│Chat  │Prof  │    │
└─────┴──────┴──────┴──────┴──────┘    │
```

### Mark Attendance Screen

```
┌───────────────────────────────────────┐
│  ← Mark Attendance                    │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📍 Current Class               │  │
│  │                                 │  │
│  │  Operating Systems (CS302)      │  │
│  │  Period 3 | 11:00 - 11:50       │  │
│  │  Room: 301 | Dr. Rajan S        │  │
│  │                                 │  │
│  │  ┌─────────────────────────┐   │  │
│  │  │     🗺️ MAP VIEW        │   │  │
│  │  │                         │   │  │
│  │  │    ┌──── Campus ────┐   │   │  │
│  │  │    │   Boundary     │   │   │  │
│  │  │    │      (200m)    │   │   │  │
│  │  │    │                │   │   │  │
│  │  │    │    📍 You      │   │  │  │
│  │  │    │   (42m away)   │   │   │  │
│  │  │    │                │   │   │  │
│  │  │    └────────────────┘   │   │  │
│  │  └─────────────────────────┘   │  │
│  │                                 │  │
│  │  ✅ Location: Within campus      │  │
│  │  ✅ Time: Within 10 min window   │  │
│  │  ✅ Device: Verified              │  │
│  │                                 │  │
│  │  ┌─────────────────────────┐   │  │
│  │  │   📍 MARK PRESENT       │   │  │
│  │  │   [Large Green Button]  │   │  │
│  │  └─────────────────────────┘   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ─── OR ───                           │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📷 Scan QR Code               │  │
│  │  [Opens Camera Scanner]        │  │
│  └─────────────────────────────────┘  │
│                                       │
│  Today: 2/3 classes attended ✅       │
│                                       │
└───────────────────────────────────────┘
```

### Assignment List Screen (Student)

```
┌───────────────────────────────────────┐
│  ← Assignments            🔍  📎     │
├───────────────────────────────────────┤
│                                       │
│  [Active ▼]  [All Subjects ▼]        │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📝 Database Normalization      │  │
│  │  DBMS (CS301) | Prof. Lakshmi   │  │
│  │  ⏰ Due: Feb 28, 11:59 PM       │  │
│  │  ⏳ 5 days remaining            │  │
│  │  Marks: /20                      │  │
│  │  Status: ⚪ Not Submitted       │  │
│  │  ┌─────────────────┐            │  │
│  │  │  📤 SUBMIT NOW   │            │  │
│  │  └─────────────────┘            │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📝 ER Diagram – Library System │  │
│  │  DBMS (CS301) | Prof. Lakshmi   │  │
│  │  ⏰ Due: Feb 20 (passed)        │  │
│  │  Marks: 18/20                    │  │
│  │  Status: ✅ Verified            │  │
│  │  "Good work! Clear design."      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📝 Process Synchronization     │  │
│  │  OS (CS302) | Dr. Rajan S       │  │
│  │  ⏰ Due: Mar 1, 11:59 PM        │  │
│  │  ⏳ 6 days remaining            │  │
│  │  Status: ⏳ Submitted (v1)      │  │
│  │  Awaiting verification...        │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📝 Linked List Implementation  │  │
│  │  DS (CS201) | Prof. Kumar V     │  │
│  │  ⏰ Due: Feb 15 (passed)        │  │
│  │  Status: 🔄 Resubmit Requested │  │
│  │  "Add doubly linked list code"  │  │
│  │  ┌─────────────────┐            │  │
│  │  │  🔄 RESUBMIT     │            │  │
│  │  └─────────────────┘            │  │
│  └─────────────────────────────────┘  │
│                                       │
├─────┬──────┬──────┬──────┬──────┤    │
│ 🏠  │  📅  │  📍  │  💬  │  👤  │    │
└─────┴──────┴──────┴──────┴──────┘    │
```

### Submit Assignment Screen

```
┌───────────────────────────────────────┐
│  ← Submit Assignment                  │
├───────────────────────────────────────┤
│                                       │
│  📝 Database Normalization            │
│  DBMS (CS301) | Prof. Lakshmi P       │
│  ⏰ Due: Feb 28, 11:59 PM (5 days)    │
│  Max marks: 20                        │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📋 Description                 │  │
│  │  Normalize the given schema     │  │
│  │  to Third Normal Form (3NF).    │  │
│  │  Show FDs, candidate keys,      │  │
│  │  and step-by-step decomposition.│  │
│  └─────────────────────────────────┘  │
│                                       │
│  📎 Attached Materials:               │
│  ├── dbms-exercise.pdf  [📥 Download] │
│  └── sample-schema.sql  [📥 Download] │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📝 Your Answer (optional)      │  │
│  │                                 │  │
│  │  Type your text answer here...  │  │
│  │                                 │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📤 Upload Files                │  │
│  │                                 │  │
│  │  ┌──────────────────────────┐  │  │
│  │  │   + Tap to upload file   │  │  │
│  │  │   PDF, DOC, ZIP, JPG     │  │  │
│  │  │   Max 10MB per file      │  │  │
│  │  └──────────────────────────┘  │  │
│  │                                 │  │
│  │  📄 normalization_solution.pdf  │  │
│  │     2.3 MB  ✅  [🗑 Remove]    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ⚠️ Late submissions: -2 marks/day    │
│  ⚠️ Max 3 days late allowed            │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │         📤 SUBMIT               │  │
│  │    [Primary Green Button]       │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

### Chatroom Screen

```
┌───────────────────────────────────────┐
│  ← CS301-DBMS (CSE-3A)   👥 53  ⋮   │
├───────────────────────────────────────┤
│                                       │
│  📌 Pinned: "Internal exam syllabus   │
│  covers up to Chapter 7 - Lakshmi P"  │
│  ─────────────────────────────────────│
│                                       │
│  👩‍🏫 Prof. Lakshmi P          10:15 AM │
│  ┌─────────────────────────────────┐  │
│  │  📢 New assignment uploaded:    │  │
│  │  "DB Normalization Exercise"    │  │
│  │  Due: Feb 28                    │  │
│  │  📎 dbms-exercise.pdf           │  │
│  └─────────────────────────────────┘  │
│                                       │
│           Arun K                10:20  │
│           ┌────────────────────────┐  │
│           │  @Lakshmi Ma'am, is   │  │
│           │  3NF enough or do we  │  │
│           │  need BCNF as well?   │  │
│           └────────────────────────┘  │
│                                       │
│  👩‍🏫 Prof. Lakshmi P          10:22 AM │
│  ┌─────────────────────────────────┐  │
│  │  ↩️ Replying to Arun K          │  │
│  │  3NF is sufficient for this    │  │
│  │  assignment. BCNF for bonus.    │  │
│  └─────────────────────────────────┘  │
│                                       │
│           Priya M               10:25  │
│           ┌────────────────────────┐  │
│           │  Can someone share     │  │
│           │  the notes from last   │  │
│           │  class? I was absent.  │  │
│           └────────────────────────┘  │
│                                       │
│           Rahul K               10:28  │
│           ┌────────────────────────┐  │
│           │  📄 dbms_ch7_notes.pdf │  │
│           │  (shared file - 1.2MB) │  │
│           └────────────────────────┘  │
│                                       │
│  ─── Today ───────────────────────── │
│                                       │
├───────────────────────────────────────┤
│ ┌──────────────────────────┐ 📎 📤  │
│ │ Type a message...        │         │
│ └──────────────────────────┘         │
└───────────────────────────────────────┘
```

### Chatroom List Screen

```
┌───────────────────────────────────────┐
│  ← Chatrooms              🔍         │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  💬 CS301-DBMS (CSE-3A)        │  │
│  │  👩‍🏫 Prof. Lakshmi: "3NF is     │  │
│  │  sufficient for..."            │  │
│  │  10:22 AM            🔵 3 new   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  💬 CS201-Data Structures       │  │
│  │  Kumar V: "Lab submission       │  │
│  │  deadline extended to..."       │  │
│  │  Yesterday           🔵 1 new   │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  💬 CSE-3A General              │  │
│  │  Priya: "Anyone going to the    │  │
│  │  tech fest tomorrow?"           │  │
│  │  Yesterday                      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📢 CSE Announcements (read-    │  │
│  │     only)                       │  │
│  │  HOD: "Mid-semester exams       │  │
│  │  schedule published"            │  │
│  │  2 days ago                     │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  💬 CS302-Operating Systems     │  │
│  │  Dr. Rajan: "Chapter 5          │  │
│  │  reference links shared"        │  │
│  │  3 days ago                     │  │
│  └─────────────────────────────────┘  │
│                                       │
├─────┬──────┬──────┬──────┬──────┤    │
│ 🏠  │  📅  │  📍  │  💬  │  👤  │    │
└─────┴──────┴──────┴──────┴──────┘    │
```

### Meeting / Live Class Screen

```
┌───────────────────────────────────────┐
│  ← Live Meetings           📅        │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🔴 LIVE NOW                    │  │
│  │  📹 DBMS – Query Optimization  │  │
│  │  Prof. Lakshmi P | Started 5m   │  │
│  │  👥 38/52 joined                │  │
│  │  ┌─────────────────┐           │  │
│  │  │  ▶ JOIN NOW      │           │  │
│  │  └─────────────────┘           │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📅 Upcoming                          │
│  ┌─────────────────────────────────┐  │
│  │  📹 OS – Process Scheduling     │  │
│  │  Dr. Rajan S                    │  │
│  │  Tomorrow, 3:00 PM | 45 min    │  │
│  │  🔔 Reminder set               │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📹 CSE Dept – Tech Talk       │  │
│  │  HOD Dr. Venkat                 │  │
│  │  Feb 25, 10:00 AM | 60 min     │  │
│  │  Type: Department Meeting       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📼 Past Meetings                     │
│  ┌─────────────────────────────────┐  │
│  │  📹 DBMS – Joins Tutorial       │  │
│  │  Feb 18 | Duration: 42 min      │  │
│  │  📼 [Watch Recording]           │  │
│  │  📍 Attendance: Auto-marked ✅   │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

### In-Meeting View

```
┌───────────────────────────────────────┐
│  🔴 LIVE • DBMS Query Opt.   ⏱ 23:15│
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │                                 │  │
│  │                                 │  │
│  │         👩‍🏫 Prof. Lakshmi       │  │
│  │        [Video Feed Main]       │  │
│  │                                 │  │
│  │   Currently sharing screen:     │  │
│  │   "sql_optimization.pptx"       │  │
│  │                                 │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌──────┐ ┌──────┐ ┌──────┐ +35     │
│  │Rahul │ │Priya │ │Arun  │         │
│  │ 🎤🔇 │ │ 🎤   │ │ 🎤🔇 │         │
│  └──────┘ └──────┘ └──────┘         │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  💬 In-Meeting Chat             │  │
│  │  Arun: "Can you zoom into the  │  │
│  │  execution plan?"               │  │
│  │  Priya: "👍"                    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ✋ Raise Hand                        │
│                                       │
├──────┬──────┬──────┬──────┬──────────┤
│ 🎤   │ 📹   │ 🖥️   │ 💬   │  🔴 End │
│ Mic  │Video │Share │Chat  │  Call   │
└──────┴──────┴──────┴──────┴──────────┘
```

### Fee Payment Screen

```
┌───────────────────────────────────────┐
│  ← Fee Payment                        │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  💰 Fee Summary                 │  │
│  │  Academic Year: 2025-26         │  │
│  │  Semester: 3rd                  │  │
│  │                                 │  │
│  │  ┌─────────────────────────┐   │  │
│  │  │ Fee Type    │ Amount    │   │  │
│  │  ├─────────────┼───────────┤   │  │
│  │  │ Tuition     │ ₹22,500  │   │  │
│  │  │ Lab Fee     │ ₹3,000   │   │  │
│  │  │ Library     │ ₹1,500   │   │  │
│  │  │ Exam Fee    │ ₹2,000   │   │  │
│  │  ├─────────────┼───────────┤   │  │
│  │  │ Subtotal    │ ₹29,000  │   │  │
│  │  │ Scholarship │ -₹12,625 │   │  │
│  │  ├─────────────┼───────────┤   │  │
│  │  │ Net Amount  │ ₹16,375  │   │  │
│  │  │ Paid        │ ₹0       │   │  │
│  │  │ Balance     │ ₹16,375  │   │  │
│  │  └─────────────┴───────────┘   │  │
│  │                                 │  │
│  │  ⏰ Due Date: March 15, 2026    │  │
│  │  ⚠️ Late fee: ₹50/day after due │  │
│  └─────────────────────────────────┘  │
│                                       │
│  Payment Options:                     │
│  ◉ Full Payment (₹16,375)           │
│  ○ Installment 1 of 3 (₹5,459)     │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │        💳 PAY NOW               │  │
│  │   [Opens Razorpay/Cashfree]     │  │
│  └─────────────────────────────────┘  │
│                                       │
│  📄 Payment History                   │
│  └── No payments yet                 │
│                                       │
└───────────────────────────────────────┘
```

### Student Results Screen

```
┌───────────────────────────────────────┐
│  ← Exam Results                       │
├───────────────────────────────────────┤
│                                       │
│  📊 Semester 3 – Results              │
│  SGPA: 8.2 | CGPA: 7.8               │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Subject      │ Int │ Ext │ Grade│  │
│  ├──────────────┼─────┼─────┼──────┤  │
│  │ Data Struct. │ 42  │ 52  │ A    │  │
│  │ DBMS         │ 38  │ 48  │ A    │  │
│  │ OS           │ 40  │ 45  │ A    │  │
│  │ Math III     │ 28  │ 32  │ B    │  │
│  │ English      │ 44  │ 51  │ A+   │  │
│  │ DS Lab       │ 46  │ —   │ A+   │  │
│  └──────────────┴─────┴─────┴──────┘  │
│                                       │
│  Total Credits: 24 | Earned: 24       │
│  Backlogs: 0                          │
│                                       │
│  📈 CGPA Trend:                       │
│  S1: 7.2 → S2: 7.5 → S3: 8.2 📈    │
│                                       │
│  [📥 Download Marksheet PDF]          │
│                                       │
└───────────────────────────────────────┘
```

---

## 6.2 Faculty Mobile App Wireframes

### Faculty Dashboard

```
┌───────────────────────────────────────┐
│  ← Faculty Dashboard     🔔 5   👤   │
├───────────────────────────────────────┤
│                                       │
│  Good Morning, Prof. Lakshmi! 👋      │
│  CSE Department | Employee: FAC-042   │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📅 Today's Classes             │  │
│  │  🟢 10:00  DBMS  CSE-3A  302   │  │
│  │     [Mark Attendance]           │  │
│  │  ⚪ 11:00  DBMS  CSE-3B  302   │  │
│  │  ⚪ 02:00  DB Lab CSE-3A CL-2  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌────────┐┌────────┐┌────────┐      │
│  │  📍    ││  📝    ││  📹    │      │
│  │ Mark   ││ Add    ││ Start  │      │
│  │ Attend.││ Assign.││ Meeting│      │
│  └────────┘└────────┘└────────┘      │
│  ┌────────┐┌────────┐┌────────┐      │
│  │  💬    ││  📊    ││  📋    │      │
│  │ Chats  ││ Enter  ││ Reports│      │
│  │        ││ Grades ││        │      │
│  └────────┘└────────┘└────────┘      │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  📊 Assignment Review Queue     │  │
│  │  ├── DB Normal.: 38 submitted   │  │
│  │  │   12 verified, 26 pending    │  │
│  │  └── [Review Submissions →]    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  ⚠️ Low Attendance Alerts        │  │
│  │  🔴 Deepika R  – 48% (DBMS)    │  │
│  │  🟠 Ganesh K   – 52% (DBMS)    │  │
│  │  🟡 Meera S    – 68% (DBMS)    │  │
│  └─────────────────────────────────┘  │
│                                       │
├─────┬──────┬──────┬──────┬──────┤    │
│ 🏠  │  📅  │  📍  │  💬  │  👤  │    │
└─────┴──────┴──────┴──────┴──────┘    │
```

### Faculty: Mark Attendance (Class View)

```
┌───────────────────────────────────────┐
│  ← DBMS (CSE-3A) Attendance           │
│  Period 2 | Feb 23, 2026              │
├───────────────────────────────────────┤
│                                       │
│  [Mark All Present]  [QR Code]        │
│                                       │
│  Total: 52 | Present: 45 | Absent: 7 │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  🔍 Search student...           │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Roll    Name           Status   │  │
│  ├─────────────────────────────────┤  │
│  │ 21CS101 Rahul Kumar    [P]      │  │
│  │ 21CS102 Priya Menon    [P]      │  │
│  │ 21CS103 Arun Krishnan  [P]      │  │
│  │ 21CS104 Deepika R      [A] ⚠️   │  │
│  │ 21CS105 Suresh V       [P]      │  │
│  │ 21CS106 Anita S        [P]      │  │
│  │ 21CS107 Ganesh K       [A] ⚠️   │  │
│  │ 21CS108 Divya P        [P]      │  │
│  │ 21CS109 Karthik M      [OD]     │  │
│  │ ...                             │  │
│  └─────────────────────────────────┘  │
│                                       │
│  Status Options:                      │
│  [P] Present [A] Absent [OD] On Duty │
│  [ML] Medical Leave [Late] Late       │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │     ✅ SUBMIT ATTENDANCE        │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

### Faculty: Create Assignment

```
┌───────────────────────────────────────┐
│  ← Create Assignment                  │
├───────────────────────────────────────┤
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Course:     [DBMS (CS301) ▼]    │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ Section:    [CSE-3A ▼]          │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ Title:                          │  │
│  │ Database Normalization Exercise │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ Description:                    │  │
│  │ Normalize the given schema to   │  │
│  │ 3NF. Show all functional deps,  │  │
│  │ candidate keys, and step-by-    │  │
│  │ step decomposition.             │  │
│  └─────────────────────────────────┘  │
│                                       │
│  Type:  ◉ File Upload  ○ Text  ○ Both│
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ 📎 Attach Files (Reference)     │  │
│  │ + dbms-exercise.pdf  (1.2 MB)  │  │
│  │ + [Add more files]             │  │
│  └─────────────────────────────────┘  │
│                                       │
│  Max Marks: [20    ]                  │
│  Deadline:  [Feb 28, 11:59 PM]       │
│                                       │
│  ☑ Allow late submission             │
│  Late penalty: [2 ] marks/day        │
│  Max late days: [3 ]                 │
│                                       │
│  ☑ Allow resubmission               │
│  Max file size: [10] MB              │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │      📝 PUBLISH ASSIGNMENT      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  → Notification sent to 52 students   │
│  → Posted to CSE-3A DBMS chatroom     │
│                                       │
└───────────────────────────────────────┘
```

### Faculty: Review Submissions

```
┌───────────────────────────────────────┐
│  ← Submissions: DB Normalization      │
│  DBMS (CS301) | CSE-3A                │
├───────────────────────────────────────┤
│                                       │
│  Status: 38/52 submitted | 12 verified│
│  ██████████████████████░░░░ 73%       │
│                                       │
│  Filter: [All ▼] [Sort: Newest ▼]    │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  21CS101 Rahul Kumar            │  │
│  │  ⏳ Submitted: Feb 25, 8:30 PM  │  │
│  │  📄 normalization_solution.pdf   │  │
│  │  [📥 Download] [✅ Verify] [❌]  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  21CS102 Priya Menon            │  │
│  │  ✅ Verified: Feb 24            │  │
│  │  Marks: 18/20                    │  │
│  │  "Excellent decomposition"       │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  21CS103 Arun Krishnan          │  │
│  │  ⏳ Submitted: Feb 26, 11:58 PM │  │
│  │  🔴 LATE (1 day) | -2 marks     │  │
│  │  📄 arun_dbms_assignment.docx    │  │
│  │  [📥 Download] [✅ Verify] [❌]  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │  21CS108 Divya P                │  │
│  │  ❌ Missing (not submitted)      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  [📥 Download All (ZIP)]             │
│  [📧 Remind Missing Students]        │
│                                       │
└───────────────────────────────────────┘
```

### Faculty: Verify Submission Modal

```
┌───────────────────────────────────────┐
│  ── Verify Submission ──              │
│                                       │
│  Student: Rahul Kumar (21CS101)       │
│  Assignment: DB Normalization         │
│  Submitted: Feb 25, 8:30 PM          │
│  On time: ✅                          │
│                                       │
│  📄 normalization_solution.pdf        │
│  [📥 View/Download]                   │
│                                       │
│  Marks: [18  ] / 20                   │
│                                       │
│  Remarks:                             │
│  ┌─────────────────────────────────┐  │
│  │ Good normalization approach.    │  │
│  │ Minor issue in 3NF step 3.     │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────┐ ┌─────────────────┐ │
│  │ ✅ VERIFY    │ │ 🔄 REQ RESUBMIT│ │
│  └─────────────┘ └─────────────────┘ │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │      ❌ REJECT                  │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

---

## 6.3 Admin Dashboard Wireframes (React/Next.js)

### Admin Sidebar Navigation

```
┌─────────────────────────────────────────────────────────────────────────┐
│ ┌──────────────┐                                                        │
│ │ 📚 [Logo]    │  Institution Dashboard                                │
│ │ XYZ College  │  ─────────────────────────────────────────            │
│ ├──────────────┤                                                        │
│ │              │                                                        │
│ │ 📊 Dashboard │  ┌────────────────────────────────────────────────┐   │
│ │ 👥 Students  │  │  Quick Stats                                   │   │
│ │ 👩‍🏫 Faculty   │  │  ┌──────────┐ ┌──────────┐ ┌──────────┐       │   │
│ │ 🏛 Departments│  │  │ Students │ │ Faculty  │ │ Revenue  │       │   │
│ │ 📚 Courses   │  │  │ 2,456    │ │ 148      │ │ ₹52.4L   │       │   │
│ │ 📅 Timetable │  │  │ +124 ↑   │ │ +8 ↑     │ │ this mo  │       │   │
│ │ ────────────│  │  └──────────┘ └──────────┘ └──────────┘       │   │
│ │ 📍 Attendance│  │  ┌──────────┐ ┌──────────┐                    │   │
│ │ 📝 Assignments│  │  │ Att. Avg │ │ Pending  │                    │   │
│ │ 💬 Chatrooms │  │  │ 82.3%    │ │ Fees     │                    │   │
│ │ 📹 Meetings  │  │  │ ↑ 2.1%   │ │ ₹12.8L   │                    │   │
│ │ ────────────│  │  └──────────┘ └──────────┘                    │   │
│ │ 💰 Fees      │  └────────────────────────────────────────────────┘   │
│ │ 💳 Payments  │                                                        │
│ │ 📊 Results   │  ┌────────────────────────────────────────────────┐   │
│ │ ────────────│  │  Attendance Trend (Last 30 Days)                │   │
│ │ 🔔 Notifs    │  │  90%┤                              ╭──╮       │   │
│ │ ────────────│  │  80%┤       ╭──────────────────╭────╯  │       │   │
│ │ 🤖 AI Insights│  │  70%├───────╯                  │       │       │   │
│ │ 📋 Reports   │  │  60%┤                                          │   │
│ │ 🎨 Branding  │  │     ┼──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──        │   │
│ │ ⚙️ Settings  │  │      W1 W2 W3 W4 W5 W6 W7 W8 W9 W10         │   │
│ └──────────────┘  └────────────────────────────────────────────────┘   │
│                                                                         │
│                    ┌────────────────────────────────────────────────┐   │
│                    │  📊 Submission Tracker (This Week)             │   │
│                    │  ├─ Total Assignments:  8                      │   │
│                    │  ├─ Avg Submission Rate: 87.5%                 │   │
│                    │  ├─ Unverified:  42 pending reviews            │   │
│                    │  └─ Late Submissions: 12                       │   │
│                    └────────────────────────────────────────────────┘   │
│                                                                         │
│                    ┌────────────────────────────────────────────────┐   │
│                    │  ⚠️ AI Alerts                                   │   │
│                    │  🔴 3 students at critical dropout risk        │   │
│                    │  🟠 8 students below 60% attendance            │   │
│                    │  🟡 5 faculty have 0 assignment verifications  │   │
│                    │  [View All Alerts →]                            │   │
│                    └────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────┘
```

### Admin: Student Management

```
┌─────────────────────────────────────────────────────────────────────────┐
│  📚 XYZ College | Students                                              │
│  ─────────────────────────────────────────────────────────              │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  🔍 Search...   [Dept ▼] [Program ▼] [Semester ▼] [Status ▼]     │ │
│  │  [+ Add Student] [📥 Import CSV] [📤 Export]                      │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ ☐ Roll     Name           Dept  Sem  Att.%  CGPA  Fee      Action│ │
│  ├────────────────────────────────────────────────────────────────────┤ │
│  │ ☐ 21CS101  Rahul Kumar    CSE   3rd  78.5%  7.8   ✅ Paid  [⋮]  │ │
│  │ ☐ 21CS102  Priya Menon    CSE   3rd  92.1%  8.5   ✅ Paid  [⋮]  │ │
│  │ ☐ 21CS103  Arun Krishnan  CSE   3rd  85.0%  7.2   ⚠️ Part. [⋮]  │ │
│  │ ☐ 21CS104  Deepika R      CSE   3rd  48.0%  4.2   🔴 Over. [⋮]  │ │
│  │ ☐ 21CS105  Suresh V       CSE   3rd  80.5%  6.9   ✅ Paid  [⋮]  │ │
│  │ ☐ 21ME201  Kavitha S      MECH  2nd  90.0%  8.1   ✅ Paid  [⋮]  │ │
│  │ ☐ 21EC301  Mohan R        ECE   3rd  72.3%  6.5   ⚠️ Part. [⋮]  │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  Showing 1-25 of 2,456 students   [◄ Prev] [1] [2] [3] ... [Next ►]   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 6.4 Super Admin Panel Wireframes

### Super Admin Dashboard

```
┌─────────────────────────────────────────────────────────────────────────┐
│  🛡 CampusSphere – Super Admin Panel                                    │
│  ─────────────────────────────────────                                  │
│                                                                         │
│  ┌──────────────┐  ┌──────────────────────────────────────────────┐    │
│  │              │  │  Platform Overview                           │    │
│  │ 🏢 Tenants   │  │  ┌──────────┐ ┌──────────┐ ┌──────────┐    │    │
│  │ 📊 Analytics │  │  │ Tenants  │ │ Users    │ │ MRR      │    │    │
│  │ 💰 Revenue   │  │  │ 42       │ │ 18,432   │ │ ₹4.2L    │    │    │
│  │ 📋 Plans     │  │  │ +6 new   │ │ +2.1K ↑  │ │ +18% ↑   │    │    │
│  │ 🔧 Config    │  │  └──────────┘ └──────────┘ └──────────┘    │    │
│  │ 📊 Health    │  │                                              │    │
│  │ 📧 Comms     │  │  Active Plans:                               │    │
│  │              │  │  Trial: 12 | Starter: 18 | Pro: 10 | Ent: 2│    │
│  │              │  │                                              │    │
│  └──────────────┘  │  ┌──────────────────────────────────────┐   │    │
│                     │  │ Tenant            Plan    Students  MRR│   │    │
│                     │  ├──────────────────────────────────────┤   │    │
│                     │  │ XYZ Engineering   Pro     2,456   ₹15K│   │    │
│                     │  │ ABC Arts College  Starter 890    ₹5K │   │    │
│                     │  │ DEF Medical       Enter.  3,200   ₹45K│   │    │
│                     │  │ GHI Polytechnic   Trial   450     ₹0  │   │    │
│                     │  │ ...                                     │   │    │
│                     │  └──────────────────────────────────────┘   │    │
│                     │                                              │    │
│                     │  [+ Add New Tenant]  [📤 Export Revenue]    │    │
│                     └──────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 6.5 Submission Tracker – Student View

```
┌───────────────────────────────────────┐
│  ← Submission Tracker                  │
├───────────────────────────────────────┤
│                                       │
│  📊 Your Submission Summary            │
│  ┌─────────────────────────────────┐  │
│  │  Total: 12 | ✅ 8 | ⏳ 2 | ❌ 2 │  │
│  │  ████████████████████░░░░ 83%   │  │
│  │  Submission Rate                │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Subject     │ Assign │ Status   │  │
│  ├─────────────┼────────┼──────────┤  │
│  │ DBMS        │ DB Norm│ ❌ Miss. │  │
│  │ DBMS        │ ER Diag│ ✅ 18/20 │  │
│  │ OS          │ Procss.│ ⏳ Pend. │  │
│  │ DS          │ LL Impl│ 🔄 Resub│  │
│  │ DS          │ Stack  │ ✅ 19/20 │  │
│  │ Math III    │ Prob#1 │ ✅ 15/20 │  │
│  │ Math III    │ Prob#2 │ ⏳ Pend. │  │
│  │ English     │ Essay  │ ✅ 17/20 │  │
│  └─────────────┴────────┴──────────┘  │
│                                       │
│  Legend:                               │
│  ✅ Verified  ⏳ Submitted/Pending    │
│  ❌ Missing   🔄 Resubmit Requested  │
│                                       │
└───────────────────────────────────────┘
```

---

> **→ Continue to [Part 7: Deployment, DevOps & Security](./Roadmap_Part7_Deployment_Security.md)**
