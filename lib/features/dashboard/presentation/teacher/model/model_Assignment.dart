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


  Map<String , dynamic> toJson(){

    return {
      "section": section,
      "subject":subject,
      "title":title,
      "type":type,
      "asignedBy":asignedBy,
      if(description !=null) "description":description,
      if(dueDate !=null) "dueDate":dueDate,
      if(maxMArks !=null) "maxMArks":maxMArks,
      if(publishedAt !=null) "publishedAt":publishedAt,
      if(status !=null) "status":status,
    };
  }
}