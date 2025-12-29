import 'package:dio/dio.dart';
import '../../data/models/principal.dart';

/// Custom exception for Principal API errors with HTTP status codes
class PrincipalApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  PrincipalApiException({
    required this.message,
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'PrincipalApiException: $message (Status: $statusCode)';
}

class PrincipalAPI {
  final Dio dio;
  PrincipalAPI(this.dio);

  /// Create a new principal
  /// POST /principals/create
  /// Returns 201 on success
  Future<Principal> createPrincipal({
    required String actorId,
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String schoolId,
  }) async {
    try {
      final response = await dio.post(
        '/principals/create',
        data: {
          'actorId': actorId,
          'username': username,
          'email': email,
          'password': password,
          'fullName': fullName,
          'school': schoolId,
        },
      );

      if (response.statusCode == 201) {
        return Principal.fromJson(response.data['principal']);
      } else {
        throw PrincipalApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw PrincipalApiException(
        message: 'Failed to create principal: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Update a principal
  /// PUT /principals/update/:id
  /// Returns 200 on success
  Future<Principal> updatePrincipal({
    required String id,
    required String actorId,
    String? username,
    String? email,
    String? password,
    String? fullName,
    String? schoolId,
    bool? isActive,
  }) async {
    try {
      final data = <String, dynamic>{
        'actorId': actorId,
      };

      if (username != null) data['username'] = username;
      if (email != null) data['email'] = email;
      if (password != null) data['password'] = password;
      if (fullName != null) data['fullName'] = fullName;
      if (schoolId != null) data['school'] = schoolId;
      if (isActive != null) data['isActive'] = isActive;

      final response = await dio.put(
        '/principals/update/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        return Principal.fromJson(response.data['principal']);
      } else {
        throw PrincipalApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw PrincipalApiException(
        message: 'Failed to update principal: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get all principals
  /// GET /principals/fetch
  /// Returns 200 on success
  Future<List<Principal>> getAllPrincipals({
    required String actorId,
  }) async {
    try {
      final response = await dio.get(
        '/principals/fetch',
        queryParameters: {'actorId': actorId},
      );

      if (response.statusCode == 200) {
        final principalsData = response.data['principals'] as List<dynamic>;
        return principalsData
            .map((json) => Principal.fromJson(json))
            .toList();
      } else {
        throw PrincipalApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw PrincipalApiException(
        message: 'Failed to get principals: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get principal by ID
  /// GET /principals/fetch/:id
  /// Returns 200 on success, 404 if not found
  Future<Principal> getPrincipalById({
    required String id,
    required String actorId,
  }) async {
    try {
      final response = await dio.get(
        '/principals/fetch/$id',
        queryParameters: {'actorId': actorId},
      );

      if (response.statusCode == 200) {
        return Principal.fromJson(response.data['principal']);
      } else if (response.statusCode == 404) {
        throw PrincipalApiException(
          message: 'Principal not found',
          statusCode: 404,
        );
      } else {
        throw PrincipalApiException(
          message: 'Unexpected status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw PrincipalApiException(
        message: 'Failed to get principal: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Handle Dio errors and convert to PrincipalApiException
  PrincipalApiException _handleDioError(DioException error) {
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

    return PrincipalApiException(
      message: userMessage,
      statusCode: statusCode,
      originalError: error,
    );
  }
}

