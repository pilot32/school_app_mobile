class Teacher {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final List<String> subjects;
  final List<String> classes;
  final String? profileImageUrl;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.subjects,
    required this.classes,
    this.profileImageUrl,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
      subjects: List<String>.from(json['subjects'] ?? []),
      classes: List<String>.from(json['classes'] ?? []),
      profileImageUrl: json['profile_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'subjects': subjects,
      'classes': classes,
      'profile_image_url': profileImageUrl,
    };
  }
}
