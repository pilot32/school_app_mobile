/// Assignment Controller with Riverpod
/// 
/// This controller provides state management for assignment operations:
/// - Create, Update, Delete assignments
/// - List assignments with filters and pagination
/// - Publish and Archive assignments
/// - Get assignment details and availability
/// 
/// Usage example:
/// ```dart
/// final controller = ref.watch(assignmentControllerProvider.notifier);
/// final state = ref.watch(assignmentControllerProvider);
/// 
/// // Create assignment
/// await controller.createAssignment(payload);
/// 
/// // Load assignments
/// await controller.loadAssignments(status: 'published');
/// 
/// // Update assignment
/// await controller.updateAssignment(id, {'title': 'New Title'});
/// ```
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../../../data/models/assignment.dart';
import '../apiService/api_assignment.dart';
import '../apiService/teacher_assignment_api_provider.dart';
import '../../../../../models/model_Assignment.dart';

/// State class for assignment controller
class AssignmentState {
  final List<AssignmentListItem> assignments;
  final Assignment? currentAssignment;
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final String? error;
  final int? totalCount;
  final int currentPage;
  final bool hasMore;

  AssignmentState({
    this.assignments = const [],
    this.currentAssignment,
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.error,
    this.totalCount,
    this.currentPage = 1,
    this.hasMore = false,
  });

  AssignmentState copyWith({
    List<AssignmentListItem>? assignments,
    Assignment? currentAssignment,
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    String? error,
    int? totalCount,
    int? currentPage,
    bool? hasMore,
    bool clearError = false,
    bool clearCurrentAssignment = false,
  }) {
    return AssignmentState(
      assignments: assignments ?? this.assignments,
      currentAssignment: clearCurrentAssignment
          ? null
          : (currentAssignment ?? this.currentAssignment),
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      error: clearError ? null : (error ?? this.error),
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// Riverpod controller for assignment operations
class AssignmentController extends StateNotifier<AssignmentState> {
  final TeacherAssignmentAPI _api;

  AssignmentController(this._api) : super(AssignmentState());

  /// Create a new assignment
  Future<bool> createAssignment(CreateAssignmentPayload payload) async {
    state = state.copyWith(isCreating: true, clearError: true);

    try {
      final assignment = await _api.createAssignment(payload);
      
      // Add to list if needed
      final newListItem = AssignmentListItem(
        id: assignment.id,
        title: assignment.title,
        section: assignment.section,
        subject: assignment.subject,
        status: assignment.status,
        type: assignment.type,
        dueDate: assignment.dueDate,
        publishAt: assignment.publishAt,
        createdAt: assignment.createdAt,
        maxMarks: assignment.maxMarks,
      );

      state = state.copyWith(
        isCreating: false,
        assignments: [newListItem, ...state.assignments],
        currentAssignment: assignment,
        totalCount: (state.totalCount ?? 0) + 1,
      );

      return true;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isCreating: false,
        error: 'Failed to create assignment: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update an assignment
  Future<bool> updateAssignment(
    String id,
    Map<String, dynamic> updates,
  ) async {
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final updatedAssignment = await _api.updateAssignment(id, updates);

      // Update in list
      final updatedList = state.assignments.map((item) {
        if (item.id == id) {
          return AssignmentListItem(
            id: updatedAssignment.id,
            title: updatedAssignment.title,
            section: updatedAssignment.section,
            subject: updatedAssignment.subject,
            status: updatedAssignment.status,
            type: updatedAssignment.type,
            dueDate: updatedAssignment.dueDate,
            publishAt: updatedAssignment.publishAt,
            createdAt: updatedAssignment.createdAt,
            maxMarks: updatedAssignment.maxMarks,
          );
        }
        return item;
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        assignments: updatedList,
        currentAssignment: updatedAssignment,
      );

      return true;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Failed to update assignment: ${e.toString()}',
      );
      return false;
    }
  }

  /// Publish an assignment
  Future<bool> publishAssignment(
    String id, {
    DateTime? publishAt,
    String? status,
  }) async {
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final publishedAssignment = await _api.publishAssignment(
        id,
        publishAt: publishAt,
        status: status,
      );

      // Update in list
      final updatedList = state.assignments.map((item) {
        if (item.id == id) {
          return AssignmentListItem(
            id: publishedAssignment.id,
            title: publishedAssignment.title,
            section: publishedAssignment.section,
            subject: publishedAssignment.subject,
            status: publishedAssignment.status,
            type: publishedAssignment.type,
            dueDate: publishedAssignment.dueDate,
            publishAt: publishedAssignment.publishAt,
            createdAt: publishedAssignment.createdAt,
            maxMarks: publishedAssignment.maxMarks,
          );
        }
        return item;
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        assignments: updatedList,
        currentAssignment: publishedAssignment,
      );

      return true;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Failed to publish assignment: ${e.toString()}',
      );
      return false;
    }
  }

  /// Archive an assignment
  Future<bool> archiveAssignment(String id) async {
    state = state.copyWith(isUpdating: true, clearError: true);

    try {
      final archivedAssignment = await _api.archiveAssignment(id);

      // Update in list
      final updatedList = state.assignments.map((item) {
        if (item.id == id) {
          return AssignmentListItem(
            id: archivedAssignment.id,
            title: archivedAssignment.title,
            section: archivedAssignment.section,
            subject: archivedAssignment.subject,
            status: archivedAssignment.status,
            type: archivedAssignment.type,
            dueDate: archivedAssignment.dueDate,
            publishAt: archivedAssignment.publishAt,
            createdAt: archivedAssignment.createdAt,
            maxMarks: archivedAssignment.maxMarks,
          );
        }
        return item;
      }).toList();

      state = state.copyWith(
        isUpdating: false,
        assignments: updatedList,
        currentAssignment: archivedAssignment,
      );

      return true;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isUpdating: false,
        error: 'Failed to archive assignment: ${e.toString()}',
      );
      return false;
    }
  }

  /// Delete an assignment
  Future<bool> deleteAssignment(String id, {bool force = false}) async {
    state = state.copyWith(isDeleting: true, clearError: true);

    try {
      await _api.deleteAssignment(id, force: force);

      // Remove from list
      final updatedList =
          state.assignments.where((item) => item.id != id).toList();

      state = state.copyWith(
        isDeleting: false,
        assignments: updatedList,
        totalCount: (state.totalCount ?? 0) - 1,
        clearCurrentAssignment: state.currentAssignment?.id == id,
      );

      return true;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isDeleting: false,
        error: 'Failed to delete assignment: ${e.toString()}',
      );
      return false;
    }
  }

  /// Load assignments list with filters
  Future<bool> loadAssignments({
    String? section,
    String? subject,
    String? status,
    String? type,
    String? assignedBy,
    DateTime? fromDate,
    DateTime? toDate,
    int? page,
    int limit = 20,
    String? sortBy,
    String? sortDir,
    bool append = false,
  }) async {
    final targetPage = page ?? (append ? state.currentPage + 1 : 1);
    
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final response = await _api.listAssignments(
        section: section,
        subject: subject,
        status: status,
        type: type,
        assignedBy: assignedBy,
        fromDate: fromDate,
        toDate: toDate,
        page: targetPage,
        limit: limit,
        sortBy: sortBy,
        sortDir: sortDir,
      );

      final newAssignments = append
          ? [...state.assignments, ...response.items]
          : response.items;

      state = state.copyWith(
        isLoading: false,
        assignments: newAssignments,
        totalCount: response.total,
        currentPage: response.page,
        hasMore: (response.page * response.limit) < response.total,
      );

      return true;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load assignments: ${e.toString()}',
      );
      return false;
    }
  }

  /// Load more assignments (pagination)
  Future<bool> loadMoreAssignments({
    String? section,
    String? subject,
    String? status,
    String? type,
    String? assignedBy,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 20,
    String? sortBy,
    String? sortDir,
  }) async {
    if (!state.hasMore || state.isLoading) {
      return false;
    }

    return loadAssignments(
      section: section,
      subject: subject,
      status: status,
      type: type,
      assignedBy: assignedBy,
      fromDate: fromDate,
      toDate: toDate,
      limit: limit,
      sortBy: sortBy,
      sortDir: sortDir,
      append: true,
    );
  }

  /// Get assignment detail by ID
  Future<bool> getAssignmentDetail(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final assignment = await _api.getAssignmentDetail(id);

      state = state.copyWith(
        isLoading: false,
        currentAssignment: assignment,
      );

      return true;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to get assignment: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get assignment availability
  Future<Map<String, dynamic>?> getAssignmentAvailability(String id) async {
    try {
      final availability = await _api.getAssignmentAvailability(id);
      return availability;
    } on AssignmentApiException catch (e) {
      state = state.copyWith(error: e.message);
      return null;
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to get availability: ${e.toString()}',
      );
      return null;
    }
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Clear current assignment
  void clearCurrentAssignment() {
    state = state.copyWith(clearCurrentAssignment: true);
  }

  /// Refresh assignments list
  Future<bool> refreshAssignments({
    String? section,
    String? subject,
    String? status,
    String? type,
    String? assignedBy,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 20,
    String? sortBy,
    String? sortDir,
  }) async {
    return loadAssignments(
      section: section,
      subject: subject,
      status: status,
      type: type,
      assignedBy: assignedBy,
      fromDate: fromDate,
      toDate: toDate,
      page: 1,
      limit: limit,
      sortBy: sortBy,
      sortDir: sortDir,
      append: false,
    );
  }
}

/// Provider for AssignmentController
final assignmentControllerProvider =
    StateNotifierProvider<AssignmentController, AssignmentState>((ref) {
  final api = ref.watch(teacherAssignmentApiProvider);
  return AssignmentController(api);
});

