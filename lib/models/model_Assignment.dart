class CreateAssignmentPayload{
  final String section;
  final String subject;
  final String title;
  final String type;
  final String asignedBy;

  final String? description;
  final DateTime? dueDate;
  final int? maxMArks;
  final DateTime? publishedAt;
  final String? status;


  CreateAssignmentPayload({
     required this.section,
    required this.subject,
    required this.title,
    required this.type,
    required this.asignedBy,
     this.description,
     this.dueDate,
     this.maxMArks,
     this.publishedAt,
     this.status});


  Map<String, dynamic> toJson() {
    return {
      "section": section,
      "subject": subject,
      "title": title,
      "type": type,
      "assignedBy": asignedBy, // Backend expects "assignedBy"
      if (description != null) "description": description,
      if (dueDate != null) "dueDate": dueDate!.toIso8601String(),
      if (maxMArks != null) "maxMarks": maxMArks, // Fixed typo: maxMarks
      if (publishedAt != null) "publishAt": publishedAt!.toIso8601String(), // Backend expects "publishAt"
      if (status != null) "status": status,
    };
  }
}