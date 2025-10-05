class Section {
  final String id;
  final String name;
  final String className;
  final String? classTeacherId;
  final String? classTeacherName;
  final int maxStudents;
  final int currentStudents;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Section({
    required this.id,
    required this.name,
    required this.className,
    this.classTeacherId,
    this.classTeacherName,
    required this.maxStudents,
    required this.currentStudents,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      className: json['class_name'] ?? '',
      classTeacherId: json['class_teacher_id'],
      classTeacherName: json['class_teacher_name'],
      maxStudents: json['max_students'] ?? 0,
      currentStudents: json['current_students'] ?? 0,
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'class_name': className,
      'class_teacher_id': classTeacherId,
      'class_teacher_name': classTeacherName,
      'max_students': maxStudents,
      'current_students': currentStudents,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isFull {
    return currentStudents >= maxStudents;
  }

  int get availableSlots {
    return maxStudents - currentStudents;
  }

  Section copyWith({
    String? id,
    String? name,
    String? className,
    String? classTeacherId,
    String? classTeacherName,
    int? maxStudents,
    int? currentStudents,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Section(
      id: id ?? this.id,
      name: name ?? this.name,
      className: className ?? this.className,
      classTeacherId: classTeacherId ?? this.classTeacherId,
      classTeacherName: classTeacherName ?? this.classTeacherName,
      maxStudents: maxStudents ?? this.maxStudents,
      currentStudents: currentStudents ?? this.currentStudents,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
