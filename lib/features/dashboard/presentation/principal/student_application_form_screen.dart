import 'package:flutter/material.dart';
import '../../../../data/models/principal.dart';
import '../../../../data/models/student_application.dart';

class StudentApplicationFormScreen extends StatefulWidget {
  final Principal principal;

  const StudentApplicationFormScreen({
    super.key,
    required this.principal,
  });

  @override
  State<StudentApplicationFormScreen> createState() => _StudentApplicationFormScreenState();
}

class _StudentApplicationFormScreenState extends State<StudentApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _previousSchoolController = TextEditingController();
  final _previousClassController = TextEditingController();

  DateTime? _dateOfBirth;
  String _selectedClass = 'Class 1';
  String _selectedSection = 'A';
  List<String> _documents = [];

  final List<String> _availableClasses = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
    'Class 11', 'Class 12',
  ];

  final List<String> _availableSections = ['A', 'B', 'C', 'D', 'E'];

  @override
  void dispose() {
    _studentNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _previousSchoolController.dispose();
    _previousClassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Application Form'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _viewApplications,
            tooltip: 'View Applications',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Student Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Information',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Student Name
                      TextFormField(
                        controller: _studentNameController,
                        decoration: const InputDecoration(
                          labelText: 'Student Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter student name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Date of Birth
                      InkWell(
                        onTap: _selectDateOfBirth,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            _dateOfBirth != null
                                ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
                                : 'Select date of birth',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Father's Name
                      TextFormField(
                        controller: _fatherNameController,
                        decoration: const InputDecoration(
                          labelText: 'Father\'s Name',
                          prefixIcon: Icon(Icons.man),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter father\'s name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Mother's Name
                      TextFormField(
                        controller: _motherNameController,
                        decoration: const InputDecoration(
                          labelText: 'Mother\'s Name',
                          prefixIcon: Icon(Icons.woman),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter mother\'s name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Number
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length < 10) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email Address
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email address';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Address
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Academic Information Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Academic Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Previous School
                      TextFormField(
                        controller: _previousSchoolController,
                        decoration: const InputDecoration(
                          labelText: 'Previous School',
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter previous school name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Previous Class
                      TextFormField(
                        controller: _previousClassController,
                        decoration: const InputDecoration(
                          labelText: 'Previous Class',
                          prefixIcon: Icon(Icons.class_),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter previous class';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Applied Class
                      DropdownButtonFormField<String>(
                        value: _selectedClass,
                        decoration: const InputDecoration(
                          labelText: 'Applied Class',
                          prefixIcon: Icon(Icons.school),
                          border: OutlineInputBorder(),
                        ),
                        items: _availableClasses.map((String classItem) {
                          return DropdownMenuItem<String>(
                            value: classItem,
                            child: Text(classItem),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedClass = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Applied Section
                      DropdownButtonFormField<String>(
                        value: _selectedSection,
                        decoration: const InputDecoration(
                          labelText: 'Applied Section',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: _availableSections.map((String section) {
                          return DropdownMenuItem<String>(
                            value: section,
                            child: Text('Section $section'),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedSection = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Documents Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Required Documents',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select documents that will be provided:',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          'Birth Certificate',
                          'Previous School Transfer Certificate',
                          'Passport Size Photo',
                          'Aadhar Card Copy',
                          'Parent\'s ID Proof',
                          'Address Proof',
                          'Medical Certificate',
                        ].map((document) {
                          final isSelected = _documents.contains(document);
                          return FilterChip(
                            label: Text(document),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _documents.add(document);
                                } else {
                                  _documents.remove(document);
                                }
                              });
                            },
                            selectedColor: Colors.blue[100],
                            checkmarkColor: Colors.blue[600],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Submit Application',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)), // 5 years ago
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dateOfBirth) {
      setState(() {
        _dateOfBirth = picked;
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_dateOfBirth == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select date of birth'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create student application object
    final application = StudentApplication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentName: _studentNameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      motherName: _motherNameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      dateOfBirth: _dateOfBirth!,
      previousSchool: _previousSchoolController.text.trim(),
      previousClass: _previousClassController.text.trim(),
      appliedClass: _selectedClass,
      appliedSection: _selectedSection,
      documents: _documents,
      submittedAt: DateTime.now(),
    );

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Application Submitted'),
        content: Text('Application for ${application.studentName} has been successfully submitted and is pending review.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _clearForm();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    // In a real app, you would save the application to your backend/database here
    print('Application created: ${application.toJson()}');
  }

  void _clearForm() {
    _studentNameController.clear();
    _fatherNameController.clear();
    _motherNameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
    _previousSchoolController.clear();
    _previousClassController.clear();
    _dateOfBirth = null;
    _selectedClass = 'Class 1';
    _selectedSection = 'A';
    _documents.clear();
  }

  void _viewApplications() {
    // Navigate to applications list screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Applications List'),
        content: const Text('This would show a list of all student applications with their status.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
