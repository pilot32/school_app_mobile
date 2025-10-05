class TeacherAssignment {
  final String id;
  final String teacherId;
  final String teacherName;
  final String className;
  final String sectionId;
  final String sectionName;
  final List<String> subjects;
  final bool isClassTeacher;
  final DateTime assignedAt;
  final DateTime? updatedAt;

  TeacherAssignment({
    required this.id,
    required this.teacherId,
    required this.teacherName,
    required this.className,
    required this.sectionId,
    required this.sectionName,
    required this.subjects,
    this.isClassTeacher = false,
    required this.assignedAt,
    this.updatedAt,
  });

  factory TeacherAssignment.fromJson(Map<String, dynamic> json) {
    return TeacherAssignment(
      id: json['id'] ?? '',
      teacherId: json['teacher_id'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      className: json['class_name'] ?? '',
      sectionId: json['section_id'] ?? '',
      sectionName: json['section_name'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []),
      isClassTeacher: json['is_class_teacher'] ?? false,
      assignedAt: DateTime.parse(json['assigned_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'class_name': className,
      'section_id': sectionId,
      'section_name': sectionName,
      'subjects': subjects,
      'is_class_teacher': isClassTeacher,
      'assigned_at': assignedAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  TeacherAssignment copyWith({
    String? id,
    String? teacherId,
    String? teacherName,
    String? className,
    String? sectionId,
    String? sectionName,
    List<String>? subjects,
    bool? isClassTeacher,
    DateTime? assignedAt,
    DateTime? updatedAt,
  }) {
    return TeacherAssignment(
      id: id ?? this.id,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      className: className ?? this.className,
      sectionId: sectionId ?? this.sectionId,
      sectionName: sectionName ?? this.sectionName,
      subjects: subjects ?? this.subjects,
      isClassTeacher: isClassTeacher ?? this.isClassTeacher,
      assignedAt: assignedAt ?? this.assignedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
