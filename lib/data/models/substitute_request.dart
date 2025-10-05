enum SubstituteStatus { pending, approved, rejected, completed }

class SubstituteRequest {
  final String id;
  final String teacherId;
  final String teacherName;
  final String subject;
  final String targetClass;
  final DateTime requestDate;
  final DateTime substituteDate;
  final String reason;
  final SubstituteStatus status;
  final String? substituteTeacherId;
  final String? substituteTeacherName;
  final String? adminRemarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubstituteRequest({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.subject,
    required this.targetClass,
    required this.requestDate,
    required this.substituteDate,
    required this.reason,
    required this.status,
    this.substituteTeacherId,
    this.substituteTeacherName,
    this.adminRemarks,
    this.createdAt,
    this.updatedAt,
  });

  factory SubstituteRequest.fromJson(Map<String, dynamic> json) {
    return SubstituteRequest(
      id: json['id'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      subject: json['subject'] ?? '',
      targetClass: json['target_class'] ?? '',
      requestDate: DateTime.parse(json['request_date']),
      substituteDate: DateTime.parse(json['substitute_date']),
      reason: json['reason'] ?? '',
      status: _mapStatus(json['status']),
      substituteTeacherId: json['substitute_teacher_id'],
      substituteTeacherName: json['substitute_teacher_name'],
      adminRemarks: json['admin_remarks'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'subject': subject,
      'target_class': targetClass,
      'request_date': requestDate.toIso8601String(),
      'substitute_date': substituteDate.toIso8601String(),
      'reason': reason,
      'status': status.name,
      'substitute_teacher_id': substituteTeacherId,
      'substitute_teacher_name': substituteTeacherName,
      'admin_remarks': adminRemarks,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  static SubstituteStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return SubstituteStatus.pending;
      case 'approved':
        return SubstituteStatus.approved;
      case 'rejected':
        return SubstituteStatus.rejected;
      case 'completed':
        return SubstituteStatus.completed;
      default:
        return SubstituteStatus.pending;
    }
  }

  bool get isPending => status == SubstituteStatus.pending;
  bool get isApproved => status == SubstituteStatus.approved;
  bool get isRejected => status == SubstituteStatus.rejected;
  bool get isCompleted => status == SubstituteStatus.completed;
}
