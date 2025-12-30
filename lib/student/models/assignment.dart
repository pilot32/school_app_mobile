class Assignment_student{
  final String id;
  final String title;
  final String description;
  ///the section has to feteched when student logins
  ///and the subject will be mapped to the class he is in
  final String section;
  final String subject;
  final String status;
  final String type;
  final String assignedBy;
  final DateTime dueDate;
  final DateTime publishAt;
  final int maxMarks;
  final bool isGraded;
  final DateTime createdAt;
  final DateTime updatedAt;


  Assignment_student({
    required this.id,
    required this.title,
    required this.description,
    required this.section,
    required this.subject,
    required this.status,
    required this.type,
    required this.assignedBy,
    required this.dueDate,
    required this.publishAt,
    required this.maxMarks,
    required this.isGraded,
    required this.createdAt,
    required this.updatedAt,
  })
  factory Assignment_student.fromJson(Map<String , dynamic> json){
    return Assignment_student(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        description: description,
        section: section,
        subject: subject,
        status: status,
        type: type,
        assignedBy: assignedBy,
        dueDate: dueDate,
        publishAt: publishAt,
        maxMarks: maxMarks,
        isGraded: isGraded,
        createdAt: createdAt,
        updatedAt: updatedAt)
  }
}