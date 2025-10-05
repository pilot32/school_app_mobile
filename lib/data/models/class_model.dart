import 'section.dart';

class ClassModel {
  final String id;
  final String name;
  final int level; // 1 for Class 1, 2 for Class 2, etc.
  final List<String> subjects;
  final List<Section> sections;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.level,
    required this.subjects,
    required this.sections,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      level: json['level'] ?? 0,
      subjects: List<String>.from(json['subjects'] ?? []),
      sections: (json['sections'] as List<dynamic>?)
          ?.map((section) => Section.fromJson(section))
          .toList() ?? [],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'subjects': subjects,
      'sections': sections.map((section) => section.toJson()).toList(),
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  int get totalStudents {
    return sections.fold(0, (sum, section) => sum + section.currentStudents);
  }

  int get totalCapacity {
    return sections.fold(0, (sum, section) => sum + section.maxStudents);
  }

  ClassModel copyWith({
    String? id,
    String? name,
    int? level,
    List<String>? subjects,
    List<Section>? sections,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ClassModel(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      subjects: subjects ?? this.subjects,
      sections: sections ?? this.sections,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
