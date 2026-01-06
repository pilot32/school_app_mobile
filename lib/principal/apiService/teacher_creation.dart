import 'package:school_app_mvp/principal/models/teacher_creation.dart';

import '../api_client.dart';

class TeacherApiService{
  Future<void> createTeacher(CreateTeacherRequest request) async {
    await ApiClient.dio.post(
      '/teachers',
      data: request.toJson(),
    );
  }
}