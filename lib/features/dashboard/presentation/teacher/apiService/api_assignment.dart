import 'package:dio/dio.dart';
import '../../../../../data/models/assignment.dart';
import '../model/model_Assignment.dart';

/// Custom exception for API errors with HTTP status codes
class AssignmentApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  AssignmentApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'AssignmentApiException: $message (Status: $statusCode)';
}

class TeacherAssignmentAPI {
  final Dio dio;
  TeacherAssignmentAPI(this.dio);

  /// Create a new assignment
  /// POST /api/teacher/assignments
  /// Returns 201 on success
  Future<Assignment> createAssignment(
      CreateAssignmentPayload payload) async {
    try {
      final response = await dio.post(
        '/api/teacher/assignments',
        data: payload.toJson(),
      );

      // Handle success status codes
      if (response.statusCode == 201) {
        return Assignment.fromJson(response.data['assignment']);
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to create assignment: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Update an assignment
  /// PATCH /api/teacher/assignments/:id
  /// Returns 200 on success
  Future<Assignment> updateAssignment(
    String id,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await dio.patch(
        '/api/teacher/assignments/$id',
        data: updates,
      );

      if (response.statusCode == 200) {
        return Assignment.fromJson(response.data['assignment']);
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to update assignment: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Publish an assignment
  /// PATCH /api/teacher/assignments/:id/publish
  /// Returns 200 on success
  Future<Assignment> publishAssignment(
    String id, {
    DateTime? publishAt,
    String? status,
  }) async {
    try {
      final response = await dio.patch(
        '/api/teacher/assignments/$id/publish',
        data: {
          if (publishAt != null) 'publishAt': publishAt.toIso8601String(),
          if (status != null) 'status': status,
        },
      );

      if (response.statusCode == 200) {
        return Assignment.fromJson(response.data['assignment']);
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to publish assignment: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Archive an assignment
  /// PATCH /api/teacher/assignments/:id/archive
  /// Returns 200 on success
  Future<Assignment> archiveAssignment(String id) async {
    try {
      final response = await dio.patch(
        '/api/teacher/assignments/$id/archive',
      );

      if (response.statusCode == 200) {
        return Assignment.fromJson(response.data['assignment']);
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to archive assignment: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Delete an assignment
  /// DELETE /api/teacher/assignments/:id
  /// Returns 200 on success (soft delete) or 200 with success: true (hard delete)
  Future<void> deleteAssignment(String id, {bool force = false}) async {
    try {
      final response = await dio.delete(
        '/api/teacher/assignments/$id',
        queryParameters: {'force': force.toString()},
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to delete assignment: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get list of assignments with filters and pagination
  /// GET /api/teacher/assignments
  /// Returns 200 on success
  Future<AssignmentListResponse> listAssignments({
    String? section,
    String? subject,
    String? status,
    String? type,
    String? assignedBy,
    DateTime? fromDate,
    DateTime? toDate,
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortDir,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (section != null) queryParams['section'] = section;
      if (subject != null) queryParams['subject'] = subject;
      if (status != null) queryParams['status'] = status;
      if (type != null) queryParams['type'] = type;
      if (assignedBy != null) queryParams['assignedBy'] = assignedBy;
      if (fromDate != null) {
        queryParams['fromDate'] = fromDate.toIso8601String();
      }
      if (toDate != null) {
        queryParams['toDate'] = toDate.toIso8601String();
      }
      if (sortBy != null) queryParams['sortBy'] = sortBy;
      if (sortDir != null) queryParams['sortDir'] = sortDir;

      final response = await dio.get(
        '/api/teacher/assignments',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return AssignmentListResponse.fromJson(response.data);
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to list assignments: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get assignment detail by ID
  /// GET /api/teacher/assignments/:id
  /// Returns 200 on success, 404 if not found
  Future<Assignment> getAssignmentDetail(String id) async {
    try {
      final response = await dio.get('/api/teacher/assignments/$id');

      if (response.statusCode == 200) {
        return Assignment.fromJson(response.data['assignment']);
      } else if (response.statusCode == 404) {
        throw AssignmentApiException(
          message: 'Assignment not found',
          statusCode: 404,
        );
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to get assignment: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get assignment availability
  /// GET /api/teacher/assignments/:id/availability
  /// Returns 200 on success
  Future<Map<String, dynamic>> getAssignmentAvailability(String id) async {
    try {
      final response = await dio.get(
        '/api/teacher/assignments/$id/availability',
      );

      if (response.statusCode == 200) {
        return response.data['availability'] as Map<String, dynamic>;
      } else {
        throw AssignmentApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AssignmentApiException(
        message: 'Failed to get assignment availability: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Handle Dio errors and convert to AssignmentApiException
  AssignmentApiException _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = error.response?.data?['error'] ??
        error.response?.data?['message'] ??
        error.message ??
        'Network error occurred';

    // Map common HTTP status codes to user-friendly messages
    String userMessage = message;
    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          userMessage = 'Bad request: $message';
          break;
        case 401:
          userMessage = 'Unauthorized: Please login again';
          break;
        case 403:
          userMessage = 'Forbidden: You don\'t have permission';
          break;
        case 404:
          userMessage = 'Not found: $message';
          break;
        case 409:
          userMessage = 'Conflict: $message';
          break;
        case 422:
          userMessage = 'Validation error: $message';
          break;
        case 500:
          userMessage = 'Server error: Please try again later';
          break;
        case 503:
          userMessage = 'Service unavailable: Please try again later';
          break;
        default:
          userMessage = 'Error ($statusCode): $message';
      }
    }

    return AssignmentApiException(
      message: userMessage,
      statusCode: statusCode,
      originalError: error,
    );
  }
}
