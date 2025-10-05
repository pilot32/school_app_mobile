enum ApplicationStatus { pending, approved, rejected, underReview }

class StudentApplication {
  final String id;
  final String studentName;
  final String fatherName;
  final String motherName;
  final String phone;
  final String email;
  final String address;
  final DateTime dateOfBirth;
  final String previousSchool;
  final String previousClass;
  final String appliedClass;
  final String appliedSection;
  final List<String> documents;
  final ApplicationStatus status;
  final String? remarks;
  final DateTime submittedAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  StudentApplication({
    required this.id,
    required this.studentName,
    required this.fatherName,
    required this.motherName,
    required this.phone,
    required this.email,
    required this.address,
    required this.dateOfBirth,
    required this.previousSchool,
    required this.previousClass,
    required this.appliedClass,
    required this.appliedSection,
    required this.documents,
    this.status = ApplicationStatus.pending,
    this.remarks,
    required this.submittedAt,
    this.reviewedBy,
    this.reviewedAt,
  });

  factory StudentApplication.fromJson(Map<String, dynamic> json) {
    return StudentApplication(
      id: json['id'] ?? '',
      studentName: json['student_name'] ?? '',
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      previousSchool: json['previous_school'] ?? '',
      previousClass: json['previous_class'] ?? '',
      appliedClass: json['applied_class'] ?? '',
      appliedSection: json['applied_section'] ?? '',
      documents: List<String>.from(json['documents'] ?? []),
      status: _mapApplicationStatus(json['status']),
      remarks: json['remarks'],
      submittedAt: DateTime.parse(json['submitted_at']),
      reviewedBy: json['reviewed_by'],
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_name': studentName,
      'father_name': fatherName,
      'mother_name': motherName,
      'phone': phone,
      'email': email,
      'address': address,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'previous_school': previousSchool,
      'previous_class': previousClass,
      'applied_class': appliedClass,
      'applied_section': appliedSection,
      'documents': documents,
      'status': status.name,
      'remarks': remarks,
      'submitted_at': submittedAt.toIso8601String(),
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
    };
  }

  static ApplicationStatus _mapApplicationStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return ApplicationStatus.pending;
      case 'approved':
        return ApplicationStatus.approved;
      case 'rejected':
        return ApplicationStatus.rejected;
      case 'under_review':
        return ApplicationStatus.underReview;
      default:
        return ApplicationStatus.pending;
    }
  }

  StudentApplication copyWith({
    String? id,
    String? studentName,
    String? fatherName,
    String? motherName,
    String? phone,
    String? email,
    String? address,
    DateTime? dateOfBirth,
    String? previousSchool,
    String? previousClass,
    String? appliedClass,
    String? appliedSection,
    List<String>? documents,
    ApplicationStatus? status,
    String? remarks,
    DateTime? submittedAt,
    String? reviewedBy,
    DateTime? reviewedAt,
  }) {
    return StudentApplication(
      id: id ?? this.id,
      studentName: studentName ?? this.studentName,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      previousSchool: previousSchool ?? this.previousSchool,
      previousClass: previousClass ?? this.previousClass,
      appliedClass: appliedClass ?? this.appliedClass,
      appliedSection: appliedSection ?? this.appliedSection,
      documents: documents ?? this.documents,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}
