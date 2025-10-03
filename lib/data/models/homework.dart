class Homework {
  final String id;
  final String title;
  final String details;
  final String subjectName;
  final String subjectTeacherName;
  final DateTime dueDate;
  final DateTime assignedDate;
  final String? attachmentUrl;
  final bool isCompleted;
  final int? maxMarks;

  Homework({
    required this.id,
    required this.title,
    required this.details,
    required this.subjectName,
    required this.subjectTeacherName,
    required this.dueDate,
    required this.assignedDate,
    this.attachmentUrl,
    this.isCompleted = false,
    this.maxMarks,
  });

  // Factory constructor for creating from JSON (for backend integration)
  factory Homework.fromJson(Map<String, dynamic> json) {
    return Homework(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      details: json['details'] ?? '',
      subjectName: json['subject_name'] ?? '',
      subjectTeacherName: json['subject_teacher_name'] ?? '',
      dueDate: DateTime.parse(json['due_date']),
      assignedDate: DateTime.parse(json['assigned_date']),
      attachmentUrl: json['attachment_url'],
      isCompleted: json['is_completed'] ?? false,
      maxMarks: json['max_marks'],
    );
  }

  // Convert to JSON (for backend integration)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'details': details,
      'subject_name': subjectName,
      'subject_teacher_name': subjectTeacherName,
      'due_date': dueDate.toIso8601String(),
      'assigned_date': assignedDate.toIso8601String(),
      'attachment_url': attachmentUrl,
      'is_completed': isCompleted,
      'max_marks': maxMarks,
    };
  }

  // Helper method to check if homework is overdue
  bool get isOverdue {
    return !isCompleted && DateTime.now().isAfter(dueDate);
  }

  // Helper method to get days until due
  int get daysUntilDue {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;
    return difference;
  }

  // Helper method to get urgency level
  String get urgencyLevel {
    if (isCompleted) return 'completed';
    if (isOverdue) return 'overdue';
    if (daysUntilDue <= 1) return 'urgent';
    if (daysUntilDue <= 3) return 'soon';
    return 'normal';
  }
}
