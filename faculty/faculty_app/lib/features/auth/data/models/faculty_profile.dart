/// User model shared across the app.
class User {
  final String id;
  final String tenantId;
  final String? email;
  final String phone;
  final String role;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final bool isActive;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.tenantId,
    this.email,
    required this.phone,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.isActive = true,
    this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      tenantId: json['tenant_id'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatarUrl: json['avatar_url'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenant_id': tenantId,
        'email': email,
        'phone': phone,
        'role': role,
        'first_name': firstName,
        'last_name': lastName,
        'avatar_url': avatarUrl,
        'is_active': isActive,
        'created_at': createdAt?.toIso8601String(),
      };
}

/// Faculty-specific profile data.
class Faculty {
  final String id;
  final String tenantId;
  final String userId;
  final String employeeId;
  final String departmentId;
  final String? designation;
  final String? specialization;
  final String? qualification;
  final int? experienceYears;
  final bool isHod;
  final bool isCoordinator;
  final String? coordinatorSectionId;

  const Faculty({
    required this.id,
    required this.tenantId,
    required this.userId,
    required this.employeeId,
    required this.departmentId,
    this.designation,
    this.specialization,
    this.qualification,
    this.experienceYears,
    this.isHod = false,
    this.isCoordinator = false,
    this.coordinatorSectionId,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) {
    return Faculty(
      id: json['id'],
      tenantId: json['tenant_id'],
      userId: json['user_id'],
      employeeId: json['employee_id'],
      departmentId: json['department_id'],
      designation: json['designation'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      experienceYears: json['experience_years'],
      isHod: json['is_hod'] ?? false,
      isCoordinator: json['is_coordinator'] ?? false,
      coordinatorSectionId: json['coordinator_section_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenant_id': tenantId,
        'user_id': userId,
        'employee_id': employeeId,
        'department_id': departmentId,
        'designation': designation,
        'specialization': specialization,
        'qualification': qualification,
        'experience_years': experienceYears,
        'is_hod': isHod,
        'is_coordinator': isCoordinator,
        'coordinator_section_id': coordinatorSectionId,
      };
}

/// Combined faculty profile with department and course info.
class FacultyProfile {
  final User user;
  final Faculty faculty;
  final String departmentName;
  final String departmentCode;
  final List<AssignedCourse> assignedCourses;

  const FacultyProfile({
    required this.user,
    required this.faculty,
    required this.departmentName,
    required this.departmentCode,
    this.assignedCourses = const [],
  });

  factory FacultyProfile.fromJson(Map<String, dynamic> json) {
    return FacultyProfile(
      user: User.fromJson(json['user']),
      faculty: Faculty.fromJson(json['faculty']),
      departmentName: json['department_name'] ?? '',
      departmentCode: json['department_code'] ?? '',
      assignedCourses: (json['assigned_courses'] as List?)
              ?.map((c) => AssignedCourse.fromJson(c))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'faculty': faculty.toJson(),
        'department_name': departmentName,
        'department_code': departmentCode,
        'assigned_courses': assignedCourses.map((c) => c.toJson()).toList(),
      };
}

/// A course assigned to this faculty for a section.
class AssignedCourse {
  final String courseId;
  final String courseCode;
  final String courseName;
  final String sectionId;
  final String sectionName;
  final int semester;
  final String courseType; // theory, lab, project

  const AssignedCourse({
    required this.courseId,
    required this.courseCode,
    required this.courseName,
    required this.sectionId,
    required this.sectionName,
    required this.semester,
    this.courseType = 'theory',
  });

  factory AssignedCourse.fromJson(Map<String, dynamic> json) {
    return AssignedCourse(
      courseId: json['course_id'],
      courseCode: json['course_code'],
      courseName: json['course_name'],
      sectionId: json['section_id'],
      sectionName: json['section_name'],
      semester: json['semester'],
      courseType: json['course_type'] ?? 'theory',
    );
  }

  Map<String, dynamic> toJson() => {
        'course_id': courseId,
        'course_code': courseCode,
        'course_name': courseName,
        'section_id': sectionId,
        'section_name': sectionName,
        'semester': semester,
        'course_type': courseType,
      };
}
