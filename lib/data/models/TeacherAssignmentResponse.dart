/// Assignment model matching backend DTO structure
/// Based on toTeacherAssignmentDetailDTO from backend utils/assignment.js
/// model for creating asn assignment
class Assignment {
  final String id;
  final String title;
  final String description;
  final SectionInfo? section;
  final SubjectInfo? subject;
  final String status; // "draft", "published", "archived"
  final String type; // "classwork", "homework", "assignment"
  final String? assignedBy;
  final DateTime? dueDate;
  final DateTime? publishAt;
  final int? maxMarks;
  final bool isGraded;
  final DateTime createdAt;
  final DateTime updatedAt;

  Assignment({
    required this.id,
    required this.title,
    this.description = '',
    this.section,
    this.subject,
    required this.status,
    required this.type,
    this.assignedBy,
    this.dueDate,
    this.publishAt,
    this.maxMarks,
    this.isGraded = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      section: json['section'] != null
          ? SectionInfo.fromJson(json['section'])
          : null,
      subject: json['subject'] != null
          ? SubjectInfo.fromJson(json['subject'])
          : null,
      status: json['status'] ?? 'draft',
      type: json['type'] ?? '',
      assignedBy: json['assignedBy'],
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
      publishAt: json['publishAt'] != null
          ? DateTime.parse(json['publishAt'])
          : null,
      maxMarks: json['maxMarks'],
      isGraded: json['isGraded'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'section': section?.toJson(),
      'subject': subject?.toJson(),
      'status': status,
      'type': type,
      'assignedBy': assignedBy,
      'dueDate': dueDate?.toIso8601String(),
      'publishAt': publishAt?.toIso8601String(),
      'maxMarks': maxMarks,
      'isGraded': isGraded,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Assignment copyWith({
    String? id,
    String? title,
    String? description,
    SectionInfo? section,
    SubjectInfo? subject,
    String? status,
    String? type,
    String? assignedBy,
    DateTime? dueDate,
    DateTime? publishAt,
    int? maxMarks,
    bool? isGraded,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      section: section ?? this.section,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      type: type ?? this.type,
      assignedBy: assignedBy ?? this.assignedBy,
      dueDate: dueDate ?? this.dueDate,
      publishAt: publishAt ?? this.publishAt,
      maxMarks: maxMarks ?? this.maxMarks,
      isGraded: isGraded ?? this.isGraded,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Section info from backend DTO
/// when viewing the assignment there is need for section selection which will ave these fields
class SectionInfo {
  final String id;
  final String? name;

  SectionInfo({required this.id, this.name});

  factory SectionInfo.fromJson(Map<String, dynamic> json) {
    return SectionInfo(
      id: json['id'] ?? '',
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Subject info from backend DTO
/// section selection time will have these fields which will require this
class SubjectInfo {
  final String id;
  final String? name;

  SubjectInfo({required this.id, this.name});

  factory SubjectInfo.fromJson(Map<String, dynamic> json) {
    return SubjectInfo(
      id: json['id'] ?? '',
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

/// Assignment list item (lighter version for list views)
/// same as assignment creation list this will return the list when fetched from backend
class AssignmentListItem {
  final String id;
  final String title;
  final SectionInfo? section;
  final SubjectInfo? subject;
  final String status;
  final String type;
  final DateTime? dueDate;
  final DateTime? publishAt;
  final DateTime createdAt;
  final int? maxMarks;

  AssignmentListItem({
    required this.id,
    required this.title,
    this.section,
    this.subject,
    required this.status,
    required this.type,
    this.dueDate,
    this.publishAt,
    required this.createdAt,
    this.maxMarks,
  });

  factory AssignmentListItem.fromJson(Map<String, dynamic> json) {
    return AssignmentListItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      section: json['section'] != null
          ? SectionInfo.fromJson(json['section'])
          : null,
      subject: json['subject'] != null
          ? SubjectInfo.fromJson(json['subject'])
          : null,
      status: json['status'] ?? 'draft',
      type: json['type'] ?? '',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'])
          : null,
      publishAt: json['publishAt'] != null
          ? DateTime.parse(json['publishAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      maxMarks: json['maxMarks'],
    );
  }
}

/// Paginated assignment list response
class AssignmentListResponse {
  final List<AssignmentListItem> items;
  final int total;
  final int page;
  final int limit;

  AssignmentListResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory AssignmentListResponse.fromJson(Map<String, dynamic> json) {
    return AssignmentListResponse(
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => AssignmentListItem.fromJson(item))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
    );
  }
}

