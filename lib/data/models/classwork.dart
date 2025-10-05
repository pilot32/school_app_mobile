class Classwork {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String teacherId;
  final String teacherName;
  final String targetClass;
  final DateTime date;
  final List<String>? attachmentUrls;
  final String? homework;

  Classwork({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.teacherId,
    required this.teacherName,
    required this.targetClass,
    required this.date,
    this.attachmentUrls,
    this.homework,
  });

  factory Classwork.fromJson(Map<String, dynamic> json) {
    return Classwork(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      subject: json['subject'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      targetClass: json['target_class'] ?? '',
      date: DateTime.parse(json['date']),
      attachmentUrls: json['attachment_urls'] != null ? List<String>.from(json['attachment_urls']) : null,
      homework: json['homework'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'target_class': targetClass,
      'date': date.toIso8601String(),
      'attachment_urls': attachmentUrls,
      'homework': homework,
    };
  }
}
