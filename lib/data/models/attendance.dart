enum AttendanceStatus { present, absent, late, excused }

class Attendance {
  final String id;
  final String studentId;
  final String studentName;
  final String studentClass;
  final String subject;
  final DateTime date;
  final AttendanceStatus status;
  final String? remarks;
  final String teacherId;

  Attendance({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    required this.subject,
    required this.date,
    required this.status,
    this.remarks,
    required this.teacherId,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['student_class'] ?? '',
      subject: json['subject'] ?? '',
      date: DateTime.parse(json['date']),
      status: _mapAttendanceStatus(json['status']),
      remarks: json['remarks'],
      teacherId: json['teacher_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'student_class': studentClass,
      'subject': subject,
      'date': date.toIso8601String(),
      'status': status.name,
      'remarks': remarks,
      'teacher_id': teacherId,
    };
  }

  static AttendanceStatus _mapAttendanceStatus(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AttendanceStatus.present;
      case 'absent':
        return AttendanceStatus.absent;
      case 'late':
        return AttendanceStatus.late;
      case 'excused':
        return AttendanceStatus.excused;
      default:
        return AttendanceStatus.absent;
    }
  }
}
