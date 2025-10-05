enum ExamType { quiz, test, assignment, midterm, finalExam }

class Marks {
  final String id;
  final String studentId;
  final String studentName;
  final String studentClass;
  final String subject;
  final String teacherId;
  final String teacherName;
  final ExamType examType;
  final String examTitle;
  final double obtainedMarks;
  final double totalMarks;
  final DateTime examDate;
  final String? remarks;
  final DateTime createdAt;

  Marks({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentClass,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.examType,
    required this.examTitle,
    required this.obtainedMarks,
    required this.totalMarks,
    required this.examDate,
    this.remarks,
    required this.createdAt,
  });

  factory Marks.fromJson(Map<String, dynamic> json) {
    return Marks(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      studentName: json['student_name'] ?? '',
      studentClass: json['student_class'] ?? '',
      subject: json['subject'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      examType: _mapExamType(json['exam_type']),
      examTitle: json['exam_title'] ?? '',
      obtainedMarks: (json['obtained_marks'] ?? 0).toDouble(),
      totalMarks: (json['total_marks'] ?? 0).toDouble(),
      examDate: DateTime.parse(json['exam_date']),
      remarks: json['remarks'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_name': studentName,
      'student_class': studentClass,
      'subject': subject,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'exam_type': examType.name,
      'exam_title': examTitle,
      'obtained_marks': obtainedMarks,
      'total_marks': totalMarks,
      'exam_date': examDate.toIso8601String(),
      'remarks': remarks,
      'created_at': createdAt.toIso8601String(),
    };
  }

  static ExamType _mapExamType(String type) {
    switch (type.toLowerCase()) {
      case 'quiz':
        return ExamType.quiz;
      case 'test':
        return ExamType.test;
      case 'assignment':
        return ExamType.assignment;
      case 'midterm':
        return ExamType.midterm;
      case 'final':
        return ExamType.finalExam;
      default:
        return ExamType.assignment;
    }
  }

  double get percentage {
    return (obtainedMarks / totalMarks) * 100;
  }

  String get grade {
    final percentage = this.percentage;
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B+';
    if (percentage >= 60) return 'B';
    if (percentage >= 50) return 'C+';
    if (percentage >= 40) return 'C';
    return 'F';
  }
}
