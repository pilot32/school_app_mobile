import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/student_provider.dart';
import '../../../data/models/student.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example simple login — replace with real auth form later
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              // Simulate login + set student in provider
              final s = Student(
                name: 'Alex Johnson',
                studentClass: 'Class 10-A',
                rollNo: '2024001',
              );
              Provider.of<StudentProvider>(context, listen: false).setStudent(s);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text('Login as Alex Johnson'),
            ),
          ),
        ),
      ),
    );
  }
}
