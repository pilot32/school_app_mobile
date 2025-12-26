import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../apiService/api_assignment.dart';

/// Provider for Dio instance
/// You can configure base URL, interceptors, etc. here
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  
  // Configure base URL - update this with your actual backend URL
  dio.options.baseUrl = 'http://localhost:3000'; // Update with actual URL
  dio.options.connectTimeout = const Duration(seconds: 30);
  dio.options.receiveTimeout = const Duration(seconds: 30);
  
  // Add interceptors for auth, logging, etc.
  dio.interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
    error: true,
  ));
  
  // TODO: Add auth interceptor to add Bearer token
  // dio.interceptors.add(AuthInterceptor());
  
  return dio;
});

/// Provider for TeacherAssignmentAPI
final teacherAssignmentApiProvider = Provider<TeacherAssignmentAPI>((ref) {
  final dio = ref.watch(dioProvider);
  return TeacherAssignmentAPI(dio);
});

