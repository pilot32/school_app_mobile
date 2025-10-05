import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app_mvp/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/principal/principal_dashboard_new.dart';
import 'features/dashboard/presentation/student/student_dashboard.dart';
import 'features/dashboard/presentation/principal/principal_dashboard.dart';
import 'features/dashboard/presentation/teacher/teacher_dashboard.dart';
import 'features/core/teacher_provider.dart';

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
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginScreen(),
          '/dashboard': (_) => const StudentDashboardScreen(),
          '/principal-dashboard': (_) => const PrincipalDashboardNew(),
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