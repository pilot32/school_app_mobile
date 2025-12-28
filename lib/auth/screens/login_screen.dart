import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[400]!, Colors.blue[600]!],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo/Icon
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.blue[100],
                          child: Icon(
                            Icons.school,
                            size: 40,
                            color: Colors.blue[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Title
                        Text(
                          'School Management System',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign in to continue',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Demo Login Buttons
                        Text(
                          'Demo Login',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style:OutlinedButton.styleFrom(
                            minimumSize: const Size(0,36),
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                                onPressed: () => _demoLogin('principal'),
                                icon: const Icon(Icons.admin_panel_settings,color: Colors.grey,),
                                label: const Text('Principal',style: TextStyle(fontSize: 10,color: Colors.grey)),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: OutlinedButton.icon(
                                style:OutlinedButton.styleFrom(
                                  minimumSize: const Size(0,36),
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                ),
                                onPressed: () => _demoLogin('teacher'),
                                icon: const Icon(Icons.person,color: Colors.grey,),
                                label: const Text('Teacher',
                                   style: TextStyle(fontSize: 10,color: Colors.grey),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: OutlinedButton.icon(
                                style:OutlinedButton.styleFrom(
                                  minimumSize: const Size(0,36),
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                ),
                                onPressed: () => _demoLogin('student'),
                                icon: const Icon(Icons.school,size: 10,color: Colors.grey,),
                                label: const Text('Student',style: TextStyle(fontSize: 10,color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would authenticate the user here
      // For demo purposes, redirect to principal dashboard
      _demoLogin('principal');
    }
  }

  void _demoLogin(String userType) {
    switch (userType) {
      case 'principal':
        Navigator.pushReplacementNamed(context, '/principal-dashboard');
        break;
      case 'teacher':
        Navigator.pushReplacementNamed(context, '/teacher-dashboard');
        break;
      case 'student':
        Navigator.pushReplacementNamed(context, '/dashboard');
        break;
    }
  }
}