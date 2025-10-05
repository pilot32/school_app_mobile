class Principal {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String schoolName;
  final DateTime createdAt;

  Principal({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.schoolName,
    required this.createdAt,
  });

  factory Principal.fromJson(Map<String, dynamic> json) {
    return Principal(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profile_image_url'],
      schoolName: json['school_name'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image_url': profileImageUrl,
      'school_name': schoolName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
