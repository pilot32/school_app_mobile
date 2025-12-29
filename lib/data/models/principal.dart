class PrincipalSchool {
  final String id;
  final String name;
  final String? code;

  PrincipalSchool({
    required this.id,
    required this.name,
    this.code,
  });

  factory PrincipalSchool.fromJson(Map<String, dynamic> json) {
    return PrincipalSchool(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      if (code != null) 'code': code,
    };
  }
}

class Principal {
  final String id;
  final String username;
  final String email;
  final String fullName;
  final bool isActive;
  final PrincipalSchool? school;
  final DateTime createdAt;
  final DateTime updatedAt;

  Principal({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
    this.isActive = true,
    this.school,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Principal.fromJson(Map<String, dynamic> json) {
    return Principal(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      isActive: json['isActive'] ?? true,
      school: json['school'] != null
          ? PrincipalSchool.fromJson(json['school'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'fullName': fullName,
      'isActive': isActive,
      if (school != null) 'school': school!.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper getters for backward compatibility
  String get name => fullName;
  String get schoolName => school?.name ?? '';
  String get phone => ''; // Phone not available in backend model
}
