class StudentTransfer {
  final String id;
  final String studentId;
  final String studentName;
  final String currentClass;
  final String currentSection;
  final String newClass;
  final String newSection;
  final String reason;
  final String requestedBy;
  final DateTime requestedAt;
  final DateTime? approvedAt;
  final String? approvedBy;
  final bool isApproved;
  final String? remarks;

  StudentTransfer({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.currentClass,
    required this.currentSection,
    required this.newClass,
    required this.newSection,
    required this.reason,
    required this.requestedBy,
    required this.requestedAt,
    this.approvedAt,
    this.approvedBy,
    this.isApproved = false,
    this.remarks,
  });

  factory StudentTransfer.fromJson(Map<String, dynamic> json) {
    return StudentTransfer(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      currentClass: json['current_class'] ?? '',
      currentSection: json['current_section'] ?? '',
      newClass: json['new_class'] ?? '',
      newSection: json['new_section'] ?? '',
      reason: json['reason'] ?? '',
      requestedBy: json['requested_by'] ?? '',
      requestedAt: DateTime.parse(json['requested_at']),
      approvedAt: json['approved_at'] != null ? DateTime.parse(json['approved_at']) : null,
      approvedBy: json['approved_by'],
      isApproved: json['is_approved'] ?? false,
      remarks: json['remarks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'current_class': currentClass,
      'current_section': currentSection,
      'new_class': newClass,
      'new_section': newSection,
      'reason': reason,
      'requested_by': requestedBy,
      'requested_at': requestedAt.toIso8601String(),
      'approved_at': approvedAt?.toIso8601String(),
      'approved_by': approvedBy,
      'is_approved': isApproved,
      'remarks': remarks,
    };
  }

  StudentTransfer copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? currentClass,
    String? currentSection,
    String? newClass,
    String? newSection,
    String? reason,
    String? requestedBy,
    DateTime? requestedAt,
    DateTime? approvedAt,
    String? approvedBy,
    bool? isApproved,
    String? remarks,
  }) {
    return StudentTransfer(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      currentClass: currentClass ?? this.currentClass,
      currentSection: currentSection ?? this.currentSection,
      newClass: newClass ?? this.newClass,
      newSection: newSection ?? this.newSection,
      reason: reason ?? this.reason,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedAt: requestedAt ?? this.requestedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      isApproved: isApproved ?? this.isApproved,
      remarks: remarks ?? this.remarks,
    );
  }
}
