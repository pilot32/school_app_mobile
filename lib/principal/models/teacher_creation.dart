class CreateTeacherRequest{
  final String actorId;
  final String schoolId;
  final String username;
  final String email;
  final String password;
  final String fullName;
  final List<String> roles;
  final List<Map<String,int>> teachableGrades;

  CreateTeacherRequest({
      required this.actorId,
      required this.schoolId,
      required this.username,
      required this.email,
      required this.password,
      required this.fullName,
      required this.roles,
      required this.teachableGrades});

  Map<String, dynamic> toJson() {
    return {
      'actorId': actorId,
      'schoolId': schoolId,
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'roles': roles,
      'teachableGrades': teachableGrades,
    };
  }
}
