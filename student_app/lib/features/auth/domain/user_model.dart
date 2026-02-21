/// Domain models matching the Supabase `users` and `students` tables.

class User {
  final String id;
  final String tenantId;
  final String? email;
  final String phone;
  final String role;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? address;
  final String? city;
  final String? state;
  final String? pincode;
  final String? deviceId;
  final String? fcmToken;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  User({
    required this.id,
    required this.tenantId,
    this.email,
    required this.phone,
    required this.role,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.address,
    this.city,
    this.state,
    this.pincode,
    this.deviceId,
    this.fcmToken,
    required this.isActive,
    this.lastLoginAt,
    required this.createdAt,
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
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      address: json['address'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      deviceId: json['device_id'],
      fcmToken: json['fcm_token'],
      isActive: json['is_active'] ?? true,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
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
        'gender': gender,
        'date_of_birth': dateOfBirth?.toIso8601String(),
        'address': address,
        'city': city,
        'state': state,
        'pincode': pincode,
        'device_id': deviceId,
        'fcm_token': fcmToken,
        'is_active': isActive,
        'last_login_at': lastLoginAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };
}

class Student {
  final String id;
  final String tenantId;
  final String userId;
  final String rollNumber;
  final String? registrationNumber;
  final String departmentId;
  final String programId;
  final String? sectionId;
  final int currentSemester;
  final int batchYear;
  final String? admissionType;
  final String? category;
  final bool scholarshipHolder;
  final double scholarshipAmount;
  final bool hostelResident;
  final String? parentName;
  final String? parentPhone;
  final String? parentEmail;
  final String? bloodGroup;
  final bool isActive;

  Student({
    required this.id,
    required this.tenantId,
    required this.userId,
    required this.rollNumber,
    this.registrationNumber,
    required this.departmentId,
    required this.programId,
    this.sectionId,
    required this.currentSemester,
    required this.batchYear,
    this.admissionType,
    this.category,
    this.scholarshipHolder = false,
    this.scholarshipAmount = 0,
    this.hostelResident = false,
    this.parentName,
    this.parentPhone,
    this.parentEmail,
    this.bloodGroup,
    this.isActive = true,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      tenantId: json['tenant_id'],
      userId: json['user_id'],
      rollNumber: json['roll_number'],
      registrationNumber: json['registration_number'],
      departmentId: json['department_id'],
      programId: json['program_id'],
      sectionId: json['section_id'],
      currentSemester: json['current_semester'],
      batchYear: json['batch_year'],
      admissionType: json['admission_type'],
      category: json['category'],
      scholarshipHolder: json['scholarship_holder'] ?? false,
      scholarshipAmount: (json['scholarship_amount'] ?? 0).toDouble(),
      hostelResident: json['hostel_resident'] ?? false,
      parentName: json['parent_name'],
      parentPhone: json['parent_phone'],
      parentEmail: json['parent_email'],
      bloodGroup: json['blood_group'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'tenant_id': tenantId,
        'user_id': userId,
        'roll_number': rollNumber,
        'registration_number': registrationNumber,
        'department_id': departmentId,
        'program_id': programId,
        'section_id': sectionId,
        'current_semester': currentSemester,
        'batch_year': batchYear,
        'admission_type': admissionType,
        'category': category,
        'scholarship_holder': scholarshipHolder,
        'scholarship_amount': scholarshipAmount,
        'hostel_resident': hostelResident,
        'parent_name': parentName,
        'parent_phone': parentPhone,
        'parent_email': parentEmail,
        'blood_group': bloodGroup,
        'is_active': isActive,
      };
}

/// Combined user + student profile for the logged-in student.
class StudentProfile {
  final User user;
  final Student student;
  final String? departmentName;
  final String? departmentCode;
  final String? programName;
  final String? sectionName;

  StudentProfile({
    required this.user,
    required this.student,
    this.departmentName,
    this.departmentCode,
    this.programName,
    this.sectionName,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      user: User.fromJson(json['user']),
      student: Student.fromJson(json['student']),
      departmentName: json['department_name'],
      departmentCode: json['department_code'],
      programName: json['program_name'],
      sectionName: json['section_name'],
    );
  }
}
