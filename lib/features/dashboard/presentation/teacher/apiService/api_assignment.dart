import 'package:dio/dio.dart';
import '../../../../../data/models/teacher_assignment.dart';
import '../model/model_Assignment.dart';

class TeacherAssignmentAPI {
  final Dio dio;
  TeacherAssignmentAPI(this.dio);

  Future<TeacherAssignment> createAssignment(
      CreateAssignmentPayload payload) async {
    try {
      final response = await dio.post(
          '/api/teacher/assignments', // Replace with actual endpoint
        data: payload.toJson(),
      );
      return TeacherAssignment.fromJson(response.data['assignment']);
    } catch (e) {
      rethrow;
    }
  }
}
