/// API route constants mapped to Cloudflare Workers endpoints.
/// These match the Hono router definitions in the workers/ directory.
class ApiRoutes {
  static const String base = '/v1';

  // Auth
  static const String login = '$base/auth/login';
  static const String otpSend = '$base/auth/otp/send';
  static const String otpVerify = '$base/auth/otp/verify';
  static const String refreshToken = '$base/auth/refresh';

  // Dashboard
  static const String dashboard = '$base/student/dashboard';
  static const String profile = '$base/student/profile';

  // Notifications
  static const String notifications = '$base/notifications';
  static String notificationRead(String id) => '$base/notifications/$id/read';

  // Attendance
  static const String attendanceMark = '$base/attendance/mark';
  static const String attendanceStats = '$base/attendance/stats';
  static const String attendanceHistory = '$base/attendance/history';
  static String attendanceSubject(String id) => '$base/attendance/subject/$id';

  // Timetable
  static const String timetableMy = '$base/timetable/my';
  static const String timetableToday = '$base/timetable/today';
  static const String timetableNextClass = '$base/timetable/next-class';

  // Assignments
  static const String assignments = '$base/assignments';
  static String assignmentDetail(String id) => '$base/assignments/$id';
  static String assignmentSubmit(String id) => '$base/assignments/$id/submit';
  static String assignmentSubmission(String id) =>
      '$base/assignments/$id/submission';

  // Fees
  static const String feesMy = '$base/fees/my';
  static const String feesPay = '$base/fees/pay';
  static const String feesReceipts = '$base/fees/receipts';
  static String feeReceiptPdf(String id) => '$base/fees/receipts/$id/pdf';

  // Results
  static const String results = '$base/results';
  static String resultsSemester(int sem) => '$base/results/semester/$sem';

  // Chat
  static const String chatrooms = '$base/chatrooms';
  static String chatroomMessages(String id) => '$base/chatrooms/$id/messages';
  static String chatroomSend(String id) => '$base/chatrooms/$id/send';

  // Meetings
  static const String meetings = '$base/meetings';
  static String meetingJoin(String id) => '$base/meetings/$id/join';

  // Calendar
  static const String calendarEvents = '$base/calendar/events';
  static String calendarEventDetail(String id) => '$base/calendar/events/$id';
  static String calendarRsvp(String id) => '$base/calendar/events/$id/rsvp';

  // Exam Timetable
  static const String exams = '$base/exams';
  static String examHallTicket(String id) => '$base/exams/hall-ticket/$id';

  // Study Materials
  static const String materials = '$base/materials';
  static String materialsByCourse(String courseId) =>
      '$base/materials/course/$courseId';

  // Hostel
  static const String hostel = '$base/hostel';
  static const String hostelMess = '$base/hostel/mess';
  static const String hostelLeave = '$base/hostel/leave';
  static const String hostelComplaints = '$base/hostel/complaints';

  // Events
  static const String events = '$base/events';
  static String eventDetail(String id) => '$base/events/$id';
  static String eventRegister(String id) => '$base/events/$id/register';

  // Grievance
  static const String grievances = '$base/grievances';
  static String grievanceDetail(String id) => '$base/grievances/$id';

  // Polls
  static const String polls = '$base/polls';
  static String pollVote(String id) => '$base/polls/$id/vote';

  // Placement
  static const String placementDrives = '$base/placement/drives';
  static String placementApply(String id) => '$base/placement/drives/$id/apply';
  static const String placementMyApps = '$base/placement/my-applications';

  // Internship
  static const String internship = '$base/internship';
  static const String internshipLogHours = '$base/internship/log-hours';
  static const String internshipReports = '$base/internship/reports';

  // AI Chatbot
  static const String chatbot = '$base/ai/chatbot';

  // AI Insights
  static const String aiInsights = '$base/ai/insights';
}
