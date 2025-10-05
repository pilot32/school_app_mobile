class Announcement {
  final String id;
  final String title;
  final String content;
  final String teacherId;
  final String teacherName;
  final String targetClass;
  final String? subject;
  final DateTime createdAt;
  final DateTime? expiryDate;
  final bool isUrgent;
  final List<String>? attachmentUrls;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.teacherId,
    required this.teacherName,
    required this.targetClass,
    this.subject,
    required this.createdAt,
    this.expiryDate,
    this.isUrgent = false,
    this.attachmentUrls,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      targetClass: json['target_class'] ?? '',
      subject: json['subject'],
      createdAt: DateTime.parse(json['created_at']),
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date']) : null,
      isUrgent: json['is_urgent'] ?? false,
      attachmentUrls: json['attachment_urls'] != null ? List<String>.from(json['attachment_urls']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'target_class': targetClass,
      'subject': subject,
      'created_at': createdAt.toIso8601String(),
      'expiry_date': expiryDate?.toIso8601String(),
      'is_urgent': isUrgent,
      'attachment_urls': attachmentUrls,
    };
  }

  bool get isExpired {
    if (expiryDate == null) return false;
    return DateTime.now().isAfter(expiryDate!);
  }
}
