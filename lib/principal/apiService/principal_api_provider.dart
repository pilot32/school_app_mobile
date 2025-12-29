import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'principal_api.dart';
import '../../teacher/apiService/teacher_assignment_api_provider.dart' show dioProvider;

/// Provider for Principal API
/// Uses the shared Dio instance from teacher API provider
final principalApiProvider = Provider<PrincipalAPI>((ref) {
  // Reuse the Dio instance from teacher API provider if available
  // Otherwise create a new one
  try {
    final dio = ref.watch(dioProvider);
    return PrincipalAPI(dio);
  } catch (e) {
    // If dioProvider is not available, create a new Dio instance
    final dio = Dio();
    dio.options.baseUrl = 'http://localhost:3000'; // Update with actual URL
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
    
    return PrincipalAPI(dio);
  }
});

