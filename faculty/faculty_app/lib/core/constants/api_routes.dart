/// All API route constants for the faculty app.
class ApiRoutes {
  ApiRoutes._();

  // ── Auth ──────────────────────────────────────────
  static const login = '/v1/auth/login';
  static const loginOtp = '/v1/auth/login/otp';
  static const verifyOtp = '/v1/auth/verify-otp';
  static const refreshToken = '/v1/auth/refresh';
  static const logout = '/v1/auth/logout';
  static const profile = '/v1/auth/profile';

  // ── Dashboard ─────────────────────────────────────
  static const dashboard = '/v1/faculty/dashboard';

  // ── Attendance ────────────────────────────────────
  static const attendanceMark = '/v1/attendance/mark';
  static const attendanceMarkBulk = '/v1/attendance/mark-bulk';
  static const attendanceClass = '/v1/attendance/class'; // + /:classId
  static const attendanceQrGenerate = '/v1/attendance/qr/generate';
  static const attendanceHistory = '/v1/attendance/history';

  // ── Assignments ───────────────────────────────────
  static const assignments = '/v1/assignments';
  static const submissions = '/v1/submissions'; // + /:id/verify, /:id/reject

  // ── Timetable ─────────────────────────────────────
  static const timetableFaculty = '/v1/timetable/faculty';

  // ── Chat ──────────────────────────────────────────
  static const chatrooms = '/v1/chatrooms';
  static const messages = '/v1/messages'; // + /:chatroomId

  // ── Meetings ──────────────────────────────────────
  static const meetings = '/v1/meetings';

  // ── Study Materials ───────────────────────────────
  static const materials = '/v1/materials';
  static const courseModules = '/v1/courses'; // + /:courseId/modules

  // ── Grades / Results ──────────────────────────────
  static const results = '/v1/results';
  static const resultsEnter = '/v1/results/enter';

  // ── Calendar ──────────────────────────────────────
  static const calendarEvents = '/v1/calendar/events';
  static const calendarToday = '/v1/calendar/today';
  static const calendarUpcoming = '/v1/calendar/upcoming';

  // ── Exams ─────────────────────────────────────────
  static const examSessions = '/v1/exams/sessions';
  static const examInvigilation = '/v1/exams/timetable/faculty';

  // ── Campus Events ─────────────────────────────────
  static const campusEvents = '/v1/events';

  // ── Research Papers ───────────────────────────────
  static const research = '/v1/research';

  // ── AI Insights ───────────────────────────────────
  static const aiDeptInsights = '/v1/ai/department-insights';
  static const aiDropoutRisk = '/v1/ai/dropout-risk';
  static const aiAttendancePrediction = '/v1/ai/attendance-prediction';

  // ── Notifications ─────────────────────────────────
  static const notifications = '/v1/notifications';

  // ── Profile ───────────────────────────────────────
  static const facultyProfile = '/v1/faculty/profile';
}
