
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../data/models/create_Assignment_payload.dart';
import 'assignment_controller.dart';

/// Legacy provider for backward compatibility
/// This now uses the new AssignmentController
/// Consider migrating to assignmentControllerProvider directly
@Deprecated('Use assignmentControllerProvider instead')
final createAssignmentProvider =
    StateNotifierProvider<CreateAssignmentNotifier, AsyncValue<bool>>((ref) {
  final controller = ref.watch(assignmentControllerProvider.notifier);
  return CreateAssignmentNotifier(controller);
});

@Deprecated('Use AssignmentController instead')
class CreateAssignmentNotifier
    extends StateNotifier<AsyncValue<bool>> {
  final AssignmentController controller;

  CreateAssignmentNotifier(this.controller)
      : super(const AsyncData(false));

  Future<void> createAssignment(CreateAssignmentPayload payload) async {
    state = const AsyncLoading();
    try {
      final success = await controller.createAssignment(payload);
      state = AsyncData(success);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
