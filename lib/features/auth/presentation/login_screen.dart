import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/student_provider.dart';
import '../../../data/models/student.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Choose your option',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 40),

              // First Row - Student & Teacher
              Row(
                children: [
                  Expanded(
                    child: _buildRoleTile(
                      title: 'Student',
                      color: Color(0xFF4CAF50),
                      onTap: () {
                        _loginAsStudent(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRoleTile(
                      title: 'Teacher',
                      color: Color(0xFF2196F3),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Second Row - Principal & Admin
              Row(
                children: [
                  Expanded(
                    child: _buildRoleTile(
                      title: 'Principal',
                      color: Color(0xFFFF9800),
                      onTap: () {
                        _loginAsPrincipal(context); // UPDATED THIS LINE
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildRoleTile(
                      title: 'Admin',
                      color: Color(0xFFF44336),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/dashboard');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTile({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _loginAsStudent(BuildContext context) {
    final student = Student(
      name: 'Alex Johnson',
      studentClass: 'Class 10-A',
      rollNo: '2024001',
    );
    Provider.of<StudentProvider>(context, listen: false).setStudent(student);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  // ADD THIS NEW METHOD FOR PRINCIPAL LOGIN
  void _loginAsPrincipal(BuildContext context) {
    // You can add principal-specific data to provider if needed
    Navigator.pushReplacementNamed(context, '/principal-dashboard');
  }
}