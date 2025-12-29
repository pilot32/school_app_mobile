import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app_mvp/principal/principal_dashboard.dart';
import 'package:school_app_mvp/student/student_dashboard.dart';
import 'package:school_app_mvp/teacher/teacher_dashboard.dart';
import 'package:school_app_mvp/theme/app_theme.dart';
import 'auth/screens/login_screen.dart';
import 'core/teacher_provider.dart';
import 'splash_screen.dart';
import 'data/models/principal.dart' show Principal, PrincipalSchool;

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
              username: 'aisha.verma',
              email: 'principal@greenwood.edu',
              fullName: 'Dr. Aisha Verma',
              createdAt: DateTime.now().subtract(const Duration(days: 365)),
              updatedAt: DateTime.now(),
              school: PrincipalSchool(
                id: 'school_001',
                name: 'Greenwood International School',
                code: 'GWS',
              ),
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