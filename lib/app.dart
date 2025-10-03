import 'package:flutter/material.dart';
import 'package:school_app_mvp/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/principal/principal_dashboard_new.dart';
import 'features/dashboard/presentation/student/student_dashboard.dart';
import 'features/dashboard/presentation/principal/principal_dashboard.dart'; // ADD THIS IMPORT

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edu App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/dashboard': (_) => const StudentDashboardScreen(),
        '/principal-dashboard': (_) => const PrincipalDashboardNew(), // ADD THIS ROUTE
      },
    );
  }
}