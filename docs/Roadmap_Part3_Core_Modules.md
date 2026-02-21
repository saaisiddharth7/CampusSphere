# CampusSphere – Complete Roadmap

## Part 3: Core Modules – Attendance, Academics, Assignments, Chatrooms & Meetings

> **Document Series:** Part 3 of 8
> **Continues from:** [Part 2: Database & API](./Roadmap_Part2_Database_API.md)

---

## 3.1 Attendance Module

### Student Attendance Marking Workflow

```
┌──────────────────────────────────────────────────────────────────────┐
│              STUDENT ATTENDANCE FLOW                                  │
│                                                                      │
│   Student opens app → Navigates to "Mark Attendance"                │
│        │                                                             │
│        ▼                                                             │
│   ┌─────────────────────────────────────────────────┐               │
│   │  CHECK 1: Is there a class right now?           │               │
│   │  Query timetable_entries for current day/time   │               │
│   │  ✅ YES → Continue                               │               │
│   │  ❌ NO  → Show "No class in session"             │               │
│   └─────────────────────┬───────────────────────────┘               │
│                         │                                            │
│                         ▼                                            │
│   ┌─────────────────────────────────────────────────┐               │
│   │  CHECK 2: Geo-fence Verification (Haversine)    │               │
│   │  • Get student GPS: (lat, lng)                   │               │
│   │  • Get campus center from tenant config          │               │
│   │  • Campus radius: default 200m                   │               │
│   │  ✅ Within radius → Continue                     │               │
│   │  ❌ Outside → "You are not on campus (Xm away)" │               │
│   └─────────────────────┬───────────────────────────┘               │
│                         │                                            │
│                         ▼                                            │
│   ┌─────────────────────────────────────────────────┐               │
│   │  CHECK 3: Time Window (first 10 min of class)   │               │
│   │  Class: 10:00-10:50 → Window: 10:00-10:10      │               │
│   │  ✅ Within window → Continue                     │               │
│   │  ❌ Late → "Marking window closed at 10:10"     │               │
│   └─────────────────────┬───────────────────────────┘               │
│                         │                                            │
│                         ▼                                            │
│   ┌─────────────────────────────────────────────────┐               │
│   │  CHECK 4: Device Fingerprint                     │               │
│   │  • Compare device_id with registered device     │               │
│   │  ✅ Matches → Continue                           │               │
│   │  ❌ Different device → "Use your registered      │               │
│   │     device. Contact admin to update."           │               │
│   └─────────────────────┬───────────────────────────┘               │
│                         │                                            │
│                         ▼                                            │
│   ┌─────────────────────────────────────────────────┐               │
│   │  CHECK 5: Duplicate Prevention                   │               │
│   │  • Check if already marked for this period      │               │
│   │  ✅ Not marked → Continue                        │               │
│   │  ❌ Already marked → "Attendance already marked"│               │
│   └─────────────────────┬───────────────────────────┘               │
│                         │                                            │
│                         ▼                                            │
│   ┌─────────────────────────────────────────────────┐               │
│   │  ✅ ATTENDANCE MARKED SUCCESSFULLY               │               │
│   │  • Record saved to Supabase                      │               │
│   │  • Show: "Present ✅ – Data Structures"         │               │
│   │  • Update daily attendance counter               │               │
│   └─────────────────────────────────────────────────┘               │
│                                                                      │
│  OFFLINE MODE:                                                       │
│  If no internet → Queue in Hive local DB → Sync when online         │
│  POST /v1/attendance/sync sends batch of queued records              │
└──────────────────────────────────────────────────────────────────────┘
```

### Geo-Fencing Algorithm (Haversine)

```dart
// apps/mobile/lib/core/utils/geo_fence_util.dart

import 'dart:math';

class GeoFenceUtil {
  /// Calculates distance between two GPS coordinates in meters
  /// Uses the Haversine formula (accounts for Earth's curvature)
  static double calculateDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    const R = 6371000; // Earth's radius in meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  /// Check if student is within campus radius
  static GeoResult isWithinCampus({
    required double studentLat,
    required double studentLng,
    required double campusLat,
    required double campusLng,
    required double campusRadiusMeters,
  }) {
    final distance = calculateDistance(
      studentLat, studentLng, campusLat, campusLng,
    );
    return GeoResult(
      isInside: distance <= campusRadiusMeters,
      distanceMeters: distance.roundToDouble(),
      maxRadiusMeters: campusRadiusMeters,
    );
  }

  static double _toRadians(double degrees) => degrees * pi / 180;
}
```

### Faculty Attendance Marking

```
┌──────────────────────────────────────────────────────────────────────┐
│  FACULTY ATTENDANCE OPTIONS                                          │
│                                                                      │
│  Option 1: Manual Marking                                            │
│  └── Open class → tick P/A for each student → Submit                │
│                                                                      │
│  Option 2: Bulk Mark                                                 │
│  └── "Mark All Present" → individually mark absent students         │
│                                                                      │
│  Option 3: QR Code                                                   │
│  └── Faculty generates time-limited QR → students scan → auto-mark  │
│  └── QR expires in 60 seconds, regenerates automatically            │
│                                                                      │
│  Option 4: Meeting Auto-Mark                                         │
│  └── During live meetings, participants auto-marked as present      │
│  └── Minimum participation: 70% of meeting duration                 │
│                                                                      │
│  Special Statuses:                                                   │
│  ├── OD (On Duty): Student on official college work                 │
│  ├── ML (Medical Leave): With medical certificate                    │
│  └── Late: Arrived after window but before class ends               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3.2 Academic Dashboard Module

### Student Dashboard Feature Map

```
┌──────────────────────────────────────────────────────────────────────┐
│  STUDENT DASHBOARD – FEATURE MAP                                     │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Today's Overview Card                                       │   │
│  │  ├── Today's classes with times + rooms                     │   │
│  │  ├── Current attendance % (with UGC 75% indicator)          │   │
│  │  ├── Pending assignments count + next deadline              │   │
│  │  ├── Upcoming meetings                                       │   │
│  │  ├── Unread chatroom messages count                          │   │
│  │  └── Fee balance + due date                                  │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌───────────────────┐  ┌───────────────────────────────────────┐   │
│  │  Quick Actions     │  │  Attendance Summary                  │   │
│  │  ├── Mark Att.    │  │  ├── Overall %: 78.5%               │   │
│  │  ├── Pay Fees     │  │  ├── Subject-wise bars              │   │
│  │  ├── View Results │  │  ├── Calendar view (color coded)    │   │
│  │  ├── Timetable    │  │  └── Alerts: 3% below minimum ⚠️   │   │
│  │  ├── Assignments  │  │                                      │   │
│  │  ├── Chatrooms    │  │  AI Insights (if enabled):           │   │
│  │  └── Meetings     │  │  └── "Your Math attendance is       │   │
│  └───────────────────┘  │      declining. Attend 5 more        │   │
│                          │      classes to reach 75%."          │   │
│                          └───────────────────────────────────────┘   │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Recent Activity Feed                                         │  │
│  │  ├── 📝 New assignment: "DB Normalization" – Due Feb 28     │  │
│  │  ├── 📹 Meeting scheduled: "DBMS Doubt Session" – Feb 22   │  │
│  │  ├── 💬 3 new messages in CSE-3A chatroom                   │  │
│  │  ├── 📊 Internal 1 results published                        │  │
│  │  └── 💰 Fee reminder: ₹16,375 due by Mar 15               │  │
│  └───────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

### Faculty Dashboard Feature Map

```
┌──────────────────────────────────────────────────────────────────────┐
│  FACULTY DASHBOARD – FEATURE MAP                                     │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Today's Overview                                             │   │
│  │  ├── Today's classes (with attendance button per class)      │   │
│  │  ├── Pending assignment reviews count                        │   │
│  │  ├── Upcoming meetings                                       │   │
│  │  └── Low attendance alerts                                   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌───────────────────┐  ┌───────────────────────────────────────┐   │
│  │  Quick Actions     │  │  Class Statistics                    │   │
│  │  ├── Mark Att.    │  │  ├── DS (CSE-3A): 85% avg att.     │   │
│  │  ├── Add Assign.  │  │  ├── DBMS (CSE-3A): 72% avg att.   │   │
│  │  ├── Start Meet.  │  │  ├── DS (CSE-3B): 78% avg att.     │   │
│  │  ├── Enter Grades │  │  └── Students below 75%: 12/52      │   │
│  │  └── Chatrooms    │  │                                      │   │
│  └───────────────────┘  └───────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  Assignment Tracker                                           │   │
│  │  ┌───────────────────────────────────────────────────────┐   │   │
│  │  │ Assignment          Due       Submitted  Verified      │   │   │
│  │  │ DB Normalization    Feb 28    38/52      12/38        │   │   │
│  │  │ ER Diagram          Feb 20    50/52      50/52  ✅    │   │   │
│  │  │ SQL Queries         Mar 05    0/52       —            │   │   │
│  │  └───────────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │  AI Alerts (if enabled)                                       │   │
│  │  ├── 🔴 Deepika R (21CS104): Dropout risk 92% – Intervene   │   │
│  │  ├── 🟠 Ganesh K (21CS107): Attendance 52% – Counsel        │   │
│  │  └── 🟡 Meera S (21CS133): Declining trend – Monitor        │   │
│  └──────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3.3 Assignment & Submission Module (NEW)

### Complete Assignment Flow

```
┌──────────────────────────────────────────────────────────────────────┐
│              ASSIGNMENT LIFECYCLE                                     │
│                                                                      │
│  Step 1: Faculty Creates Assignment                                  │
│  ═══════════════════════════════                                     │
│  POST /v1/assignments                                                │
│  {                                                                   │
│    "title": "Database Normalization Exercise",                       │
│    "courseId": "cs301-uuid",                                         │
│    "sectionId": "cse-3a-uuid",                                      │
│    "description": "Normalize the given schema to 3NF...",           │
│    "assignmentType": "file_upload",                                  │
│    "deadline": "2026-02-28T23:59:00+05:30",                        │
│    "maxMarks": 20,                                                   │
│    "allowLateSubmission": true,                                      │
│    "latePenaltyPerDay": 2,                                           │
│    "maxLateDays": 3,                                                 │
│    "attachmentUrls": ["r2://assignments/dbms-exercise.pdf"]         │
│  }                                                                   │
│  → Notification sent to all 52 students in CSE-3A                   │
│  → Via: Push (FCM) + In-App + Chatroom auto-post                    │
│                                                                      │
│  Step 2: Student Views & Downloads                                   │
│  ═══════════════════════════════                                     │
│  GET /v1/assignments?sectionId=cse-3a-uuid&status=active            │
│  → Shows list with countdown timer to deadline                      │
│  → Download attached materials from R2                              │
│                                                                      │
│  Step 3: Student Submits                                             │
│  ═══════════════════════                                             │
│  POST /v1/assignments/:id/submit                                     │
│  Content-Type: multipart/form-data                                   │
│  {                                                                   │
│    "file": <upload>,      // → Stored in R2: /tenant/assignments/   │
│    "textContent": "..."   // Optional text answer                   │
│  }                                                                   │
│  → Status: "submitted"                                               │
│  → If past deadline: auto-flag as late, calculate penalty            │
│  → Faculty notified: "Arun K submitted DBMS assignment"             │
│                                                                      │
│  Step 4: Faculty Reviews                                             │
│  ═════════════════════                                               │
│  GET /v1/assignments/:id/submissions                                 │
│  → Paginated list with status filters                                │
│  → Download individual or all submissions                            │
│                                                                      │
│  Step 5: Faculty Verifies or Rejects                                 │
│  ═══════════════════════════════════                                 │
│  PUT /v1/submissions/:id/verify                                      │
│  { "marksAwarded": 18, "remarks": "Good normalization" }           │
│  → Student notified with marks                                      │
│                                                                      │
│  PUT /v1/submissions/:id/reject                                      │
│  { "remarks": "Incomplete. Please add 3NF explanation." }           │
│  → Student can resubmit (version incremented)                       │
│                                                                      │
│  Step 6: Submission Tracker Dashboard                                │
│  ════════════════════════════════════                                │
│  GET /v1/submissions/tracker                                         │
│  → Student sees all assignments with status:                        │
│    ✅ Verified | ⏳ Submitted | ❌ Missing | 🔄 Resubmit           │
│  → Faculty sees class-wide progress bars                             │
│  → Admin sees department-wide metrics                                │
└──────────────────────────────────────────────────────────────────────┘
```

### Submission Tracker Dashboard (Admin View)

```
┌──────────────────────────────────────────────────────────────────────────┐
│  📊 SUBMISSION TRACKER – Admin Dashboard                                 │
├──────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  Filter: [Dept: CSE ▼] [Sem: 3 ▼] [Section: A ▼] [Subject: All ▼]    │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │  Department Summary                                                │ │
│  │  ├── Total Assignments Created:  24                                │ │
│  │  ├── Overall Submission Rate:    87.5%  ████████████████░░ 87%    │ │
│  │  ├── On-Time Submissions:        82.1%                             │ │
│  │  ├── Late Submissions:           5.4%                              │ │
│  │  ├── Missing:                    12.5%  🔴 30 students             │ │
│  │  └── Verified:                   71.2%                             │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ Assignment         │ Faculty    │ Due    │ Sub% │ Verified │ Late │ │
│  ├────────────────────┼────────────┼────────┼──────┼──────────┼──────┤ │
│  │ DB Normalization   │ Lakshmi P  │ Feb 28 │ 73%  │ 23%      │ 4    │ │
│  │ ER Diagram         │ Lakshmi P  │ Feb 20 │ 96%  │ 96%  ✅  │ 2    │ │
│  │ OS Process Sync    │ Kumar V    │ Mar 01 │ 45%  │ 0%       │ 0    │ │
│  │ Math III Prob Set  │ Priya S    │ Feb 25 │ 88%  │ 50%      │ 8    │ │
│  │ English Essay      │ John M     │ Feb 22 │ 92%  │ 92%  ✅  │ 1    │ │
│  └────────────────────┴────────────┴────────┴──────┴──────────┴──────┘ │
│                                                                          │
│  [📥 Export Report]  [📧 Send Reminder to Missing Students]            │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## 3.4 Class Chatroom Module (NEW)

### Chatroom Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│              CHATROOM ARCHITECTURE (Supabase Realtime)                │
│                                                                      │
│  Auto-Created Chatrooms:                                             │
│  ────────────────────────                                            │
│  When admin creates a section + assigns faculty, the system          │
│  auto-creates the following chatrooms:                               │
│                                                                      │
│  1. Section General: "CSE-3A General"                                │
│     Members: All CSE-3A students + Coordinator + All section faculty │
│     Type: Two-way discussion                                         │
│                                                                      │
│  2. Per-Subject: "CS301-DBMS (CSE-3A)"                              │
│     Members: CSE-3A students + Subject faculty (Prof. Lakshmi)      │
│     Type: Two-way (for doubts, materials)                            │
│                                                                      │
│  3. Department Announcements: "CSE Announcements"                    │
│     Members: All CSE students + HOD                                  │
│     Type: One-way (only HOD/admin can post)                          │
│                                                                      │
│  Technical Implementation:                                            │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Client (Flutter/React)                                        │  │
│  │  ├── Subscribe to Supabase Realtime channel: chatroom:{id}    │  │
│  │  ├── Listen for INSERT events on messages table                │  │
│  │  ├── Send messages via REST API (POST /v1/chatrooms/:id/msg)  │  │
│  │  └── Update read receipts on scroll                            │  │
│  │                                                                │  │
│  │  Worker API                                                    │  │
│  │  ├── POST creates message row in Supabase                     │  │
│  │  ├── Supabase Realtime broadcasts to all subscribers          │  │
│  │  ├── Handles file uploads to R2                                │  │
│  │  └── Rate limits: 30 messages/minute per user                 │  │
│  └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  Features:                                                           │
│  ├── 💬 Text messages with markdown support                         │
│  ├── 📎 File sharing (PDF, images, docs → R2)                      │
│  ├── ↩️  Reply threads (reply_to_id)                                 │
│  ├── 📌 Pin important messages (faculty/moderator)                  │
│  ├── @  Mentions (@student_name, @all)                              │
│  ├── 👁 Read receipts (last read message tracking)                  │
│  ├── 🔔 Push notification for @mentions                             │
│  ├── 🔇 Mute chatroom option                                        │
│  └── 🗑 Delete own messages (within 15 min)                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3.5 Live Meeting Module (NEW)

### Meeting Lifecycle

```
┌──────────────────────────────────────────────────────────────────────┐
│              MEETING LIFECYCLE (100ms WebRTC)                         │
│                                                                      │
│  1. SCHEDULE                                                         │
│  ├── Faculty/Admin creates meeting via app or dashboard              │
│  ├── POST /v1/meetings → creates room via 100ms API                 │
│  ├── Push notification + calendar entry sent to participants         │
│  └── "Join Meeting" button appears 5 min before start time          │
│                                                                      │
│  2. JOIN                                                             │
│  ├── POST /v1/meetings/:id/join                                     │
│  │   → Generate temporary 100ms auth token for the user             │
│  │   → Return { roomId, token, wsUrl }                              │
│  ├── Flutter app: HMSVideoView widget renders video/audio           │
│  ├── Web admin: 100ms React SDK                                     │
│  └── Participant record created in meeting_participants table       │
│                                                                      │
│  3. DURING MEETING                                                   │
│  ├── Video/Audio toggle                                              │
│  ├── Screen sharing (faculty/host)                                   │
│  ├── In-meeting chat (separate from class chatrooms)                │
│  ├── Hand raise → notification to host                              │
│  ├── Whiteboard (100ms plugin or embedded Excalidraw)               │
│  └── Recording: 100ms auto-records → webhook → store in R2         │
│                                                                      │
│  4. END                                                              │
│  ├── POST /v1/meetings/:id/end                                      │
│  ├── Calculate each participant's duration                           │
│  ├── If auto_mark_attendance = true:                                │
│  │   └── Mark "present" for participants with ≥70% duration         │
│  ├── Recording URL saved to R2, linked in meeting record            │
│  └── Meeting status → "ended"                                       │
│                                                                      │
│  Implementation: 100ms SDK                                           │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  // Flutter – Join Meeting                                     │  │
│  │  final hmsSDK = HMSSDK();                                     │  │
│  │  await hmsSDK.build();                                         │  │
│  │  final config = HMSConfig(                                     │  │
│  │    authToken: meetingToken,  // from our API                   │  │
│  │    userName: currentUser.name,                                 │  │
│  │  );                                                            │  │
│  │  hmsSDK.join(config: config);                                  │  │
│  │                                                                │  │
│  │  // Listen for events                                          │  │
│  │  hmsSDK.addUpdateListener(listener: MeetingListener());       │  │
│  └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3.6 Timetable Module

### Timetable Data Model

```
┌──────────────────────────────────────────────────────────────────────┐
│              TIMETABLE – SAMPLE VIEW (CSE-3A, Monday)                │
│                                                                      │
│  ┌────────┬──────────────┬────────────┬────────┬───────────────────┐│
│  │ Period │ Time         │ Subject    │ Room   │ Faculty           ││
│  ├────────┼──────────────┼────────────┼────────┼───────────────────┤│
│  │   1    │ 09:00-09:50  │ DS (CS201) │ 301    │ Prof. Kumar V     ││
│  │   2    │ 10:00-10:50  │ DBMS(CS301)│ 302    │ Prof. Lakshmi P   ││
│  │   3    │ 11:00-11:50  │ OS (CS302) │ 301    │ Dr. Rajan S       ││
│  │   —    │ 12:00-01:00  │ LUNCH      │ —      │ —                 ││
│  │   4    │ 01:00-01:50  │ Math (MA201)│Lab 2  │ Dr. Priya S       ││
│  │   5    │ 02:00-02:50  │ Eng (HS201)│ 303    │ Mr. John M        ││
│  │   6    │ 03:00-04:50  │ DS Lab     │ CL-1   │ Prof. Kumar V     ││
│  └────────┴──────────────┴────────────┴────────┴───────────────────┘│
│                                                                      │
│  Timetable Generation Algorithm:                                     │
│  1. Input: Courses, faculty, sections, rooms, periods per day       │
│  2. Constraints: No faculty/room conflicts, lab blocks together     │
│  3. Algorithm: Greedy assignment with backtracking                   │
│  4. Output: Timetable entries inserted into Supabase                │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3.7 Notification System Architecture

```
┌──────────────────────────────────────────────────────────────────────┐
│              NOTIFICATION SYSTEM                                      │
│                                                                      │
│  Notification Events:                                                │
│  ├── 📍 Attendance marked / low attendance alert                    │
│  ├── 💰 Fee reminder / payment confirmation / receipt               │
│  ├── 📝 New assignment / deadline approaching / submission verified  │
│  ├── 💬 Chatroom @mention / new message in muted room              │
│  ├── 📹 Meeting scheduled / starting in 5 min / recording ready    │
│  ├── 📊 Result published / CGPA updated                             │
│  ├── 📢 Admin announcement                                          │
│  └── 🤖 AI alert (dropout risk, attendance prediction)              │
│                                                                      │
│  Delivery Channels (Priority Order):                                 │
│  ┌─────────────────────────────────────────────────┐                │
│  │  1. In-App Notification (always)                │                │
│  │  2. Push Notification (FCM – mobile + web)      │                │
│  │  3. Email (via Resend)                           │                │
│  │  4. SMS (via MSG91 – critical only)             │                │
│  │  5. WhatsApp (via WATI – fee/result only)       │                │
│  └─────────────────────────────────────────────────┘                │
│                                                                      │
│  Implementation:                                                     │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  Event Trigger (Worker API)                                    │  │
│  │       │                                                        │  │
│  │       ▼                                                        │  │
│  │  INSERT into notifications table (Supabase)                    │  │
│  │  + Supabase Realtime broadcasts to client (in-app)            │  │
│  │       │                                                        │  │
│  │       ▼                                                        │  │
│  │  Cloudflare Worker Cron or Queue (Cloudflare Queues)          │  │
│  │  → Sends FCM push via Firebase Admin SDK                     │  │
│  │  → Sends email via Resend API                                 │  │
│  │  → Sends SMS via MSG91 API                                    │  │
│  │  → Sends WhatsApp via WATI API                                │  │
│  └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│  Resend Email Example:                                               │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  import { Resend } from 'resend';                              │  │
│  │                                                                │  │
│  │  const resend = new Resend(env.RESEND_API_KEY);               │  │
│  │                                                                │  │
│  │  await resend.emails.send({                                    │  │
│  │    from: `${tenant.appName} <noreply@campussphere.in>`,       │  │
│  │    to: student.email,                                          │  │
│  │    subject: `New Assignment: ${assignment.title}`,            │  │
│  │    html: renderTemplate('assignment-notification', {           │  │
│  │      studentName: student.firstName,                           │  │
│  │      assignmentTitle: assignment.title,                        │  │
│  │      deadline: formatIST(assignment.deadline),                │  │
│  │      collegeLogo: tenant.logoUrl,                              │  │
│  │    }),                                                         │  │
│  │  });                                                           │  │
│  └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

> **→ Continue to [Part 4: Fees, Payments & White-Label Engine](./Roadmap_Part4_Fees_WhiteLabel.md)**
