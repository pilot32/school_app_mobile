import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apiService//api_assignment.dart';
import '../model/model_Assignment.dart';
import '../../../../../data/models/teacher_assignment.dart';
import 'teacher_assignment_api_provider.dart';

final createAssignmentProvider =
StateNotifierProvider<CreateAssignmentNotifier,
    AsyncValue<TeacherAssignment?>>((ref) {
  final api = ref.read(teacherAssignmentApiProvider);
  return CreateAssignmentNotifier(api);
});

class CreateAssignmentNotifier
    extends StateNotifier<AsyncValue<TeacherAssignment?>> {
  final TeacherAssignmentAPI api;

  CreateAssignmentNotifier(this.api)
      : super(const AsyncData(null));

  Future<void> createAssignment(
      CreateAssignmentPayload payload) async {
    state = const AsyncLoading();
    try {
      final assignment = await api.createAssignment(payload);
      state = AsyncData(assignment);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
