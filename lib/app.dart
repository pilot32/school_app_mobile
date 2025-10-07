import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app_mvp/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/principal/principal_dashboard.dart';
import 'features/dashboard/presentation/student/student_dashboard.dart';
import 'features/dashboard/presentation/teacher/teacher_dashboard.dart';
import 'features/core/teacher_provider.dart';
import 'features/core/splash_screen.dart';
import 'data/models/principal.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeacherProvider()),
      ],
      child: MaterialApp(
        title: 'Edu App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/': (_) => const LoginScreen(),
          '/dashboard': (_) => const StudentDashboardScreen(),
          '/principal-dashboard': (_) => PrincipalDashboardScreen(
            principal: Principal(
              id: 'principal_001',
              name: 'Dr. Aisha Verma',
              email: 'principal@greenwood.edu',
              phone: '+91-98123 45678',
              schoolName: 'Greenwood International School',
              createdAt: DateTime.now().subtract(const Duration(days: 365)),
            ),
          ),
          '/teacher-dashboard': (_) => Consumer<TeacherProvider>(
            builder: (context, teacherProvider, child) {
              if (teacherProvider.teacher == null) {
                return const Scaffold(
                  body: Center(child: Text('No teacher data available')),
                );
              }
              return TeacherDashboardScreen(teacher: teacherProvider.teacher!);
            },
          ),
        },
      ),
    );
  }
}