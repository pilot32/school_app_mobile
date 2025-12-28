import 'package:flutter/material.dart';
import '../../../../data/models/principal.dart';
import '../../../../data/models/teacher.dart';
import '../data/models/teacher_assignment.dart';
import '../../../../data/models/section.dart';
import '../../../../data/models/class_model.dart';

class TeacherAssignmentScreen extends StatefulWidget {
  final Principal principal;

  const TeacherAssignmentScreen({
    super.key,
    required this.principal,
  });

  @override
  State<TeacherAssignmentScreen> createState() => _TeacherAssignmentScreenState();
}

class _TeacherAssignmentScreenState extends State<TeacherAssignmentScreen> {
  final _formKey = GlobalKey<FormState>();
  Teacher? _selectedTeacher;
  String _selectedClass = 'Class 1';
  String _selectedSection = 'A';
  List<String> _selectedSubjects = [];
  bool _isClassTeacher = false;

  // Sample data - in a real app, this would come from your backend
  final List<Teacher> _teachers = [
    Teacher(
      id: '1',
      name: 'John Smith',
      email: 'john.smith@school.com',
      phone: '9876543210',
      department: 'Mathematics',
      subjects: ['Mathematics', 'Statistics'],
      classes: ['Class 9', 'Class 10', 'Class 11', 'Class 12'],
    ),
    Teacher(
      id: '2',
      name: 'Sarah Johnson',
      email: 'sarah.johnson@school.com',
      phone: '9876543211',
      department: 'Science',
      subjects: ['Physics', 'Chemistry'],
      classes: ['Class 8', 'Class 9', 'Class 10', 'Class 11', 'Class 12'],
    ),
    Teacher(
      id: '3',
      name: 'Michael Brown',
      email: 'michael.brown@school.com',
      phone: '9876543212',
      department: 'English',
      subjects: ['English', 'Literature'],
      classes: ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10'],
    ),
  ];

  final List<String> _availableClasses = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
    'Class 11', 'Class 12',
  ];

  final List<String> _availableSections = ['A', 'B', 'C', 'D', 'E'];

  List<TeacherAssignment> _assignments = [];

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  void _loadAssignments() {
    // Sample assignments - in a real app, this would come from your backend
    _assignments = [
      TeacherAssignment(
        id: '1',
        teacherId: '1',
        teacherName: 'John Smith',
        className: 'Class 10',
        sectionId: '10A',
        sectionName: 'A',
        subjects: ['Mathematics'],
        isClassTeacher: true,
        assignedAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      TeacherAssignment(
        id: '2',
        teacherId: '2',
        teacherName: 'Sarah Johnson',
        className: 'Class 9',
        sectionId: '9A',
        sectionName: 'A',
        subjects: ['Physics', 'Chemistry'],
        isClassTeacher: false,
        assignedAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Assignments'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.blue[600],
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Assign Teacher'),
                  Tab(text: 'View Assignments'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAssignmentForm(),
                  _buildAssignmentsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assign Teacher',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Teacher Selection
                    DropdownButtonFormField<Teacher>(
                      value: _selectedTeacher,
                      decoration: const InputDecoration(
                        labelText: 'Select Teacher',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      items: _teachers.map((Teacher teacher) {
                        return DropdownMenuItem<Teacher>(
                          value: teacher,
                          child: Text('${teacher.name} (${teacher.department})'),
                        );
                      }).toList(),
                      onChanged: (Teacher? newValue) {
                        setState(() {
                          _selectedTeacher = newValue;
                          _selectedSubjects.clear();
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a teacher';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Class Selection
                    DropdownButtonFormField<String>(
                      value: _selectedClass,
                      decoration: const InputDecoration(
                        labelText: 'Select Class',
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

                    // Section Selection
                    DropdownButtonFormField<String>(
                      value: _selectedSection,
                      decoration: const InputDecoration(
                        labelText: 'Select Section',
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
                    const SizedBox(height: 20),

                    // Subject Selection
                    if (_selectedTeacher != null) ...[
                      Text(
                        'Subjects',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select subjects to assign to ${_selectedTeacher!.name}:',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedTeacher!.subjects.map((subject) {
                          final isSelected = _selectedSubjects.contains(subject);
                          return FilterChip(
                            label: Text(subject),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSubjects.add(subject);
                                } else {
                                  _selectedSubjects.remove(subject);
                                }
                              });
                            },
                            selectedColor: Colors.blue[100],
                            checkmarkColor: Colors.blue[600],
                          );
                        }).toList(),
                      ),
                      if (_selectedSubjects.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Please select at least one subject',
                            style: TextStyle(color: Colors.red[600]),
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],

                    // Class Teacher Checkbox
                    CheckboxListTile(
                      title: const Text('Assign as Class Teacher'),
                      subtitle: const Text('This teacher will be responsible for this class section'),
                      value: _isClassTeacher,
                      onChanged: (bool? value) {
                        setState(() {
                          _isClassTeacher = value ?? false;
                        });
                      },
                      activeColor: Colors.blue[600],
                    ),

                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitAssignment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Assign Teacher',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _assignments.length,
      itemBuilder: (context, index) {
        final assignment = _assignments[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: assignment.isClassTeacher ? Colors.blue[100] : Colors.grey[200],
              child: Icon(
                assignment.isClassTeacher ? Icons.person : Icons.school,
                color: assignment.isClassTeacher ? Colors.blue[600] : Colors.grey[600],
              ),
            ),
            title: Text(
              assignment.teacherName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${assignment.className} - Section ${assignment.sectionName}'),
                Text('Subjects: ${assignment.subjects.join(', ')}'),
                if (assignment.isClassTeacher)
                  Text(
                    'Class Teacher',
                    style: TextStyle(
                      color: Colors.blue[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  _editAssignment(assignment);
                } else if (value == 'delete') {
                  _deleteAssignment(assignment);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitAssignment() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTeacher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a teacher'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedSubjects.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one subject'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if teacher is already assigned to this section
    final existingAssignment = _assignments.firstWhere(
      (assignment) => assignment.sectionId == '${_selectedClass.replaceAll(' ', '')}$_selectedSection',
      orElse: () => TeacherAssignment(
        id: '',
        teacherId: '',
        teacherName: '',
        className: '',
        sectionId: '',
        sectionName: '',
        subjects: [],
        assignedAt: DateTime.now(),
      ),
    );

    if (existingAssignment.id.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This section already has a teacher assigned: ${existingAssignment.teacherName}'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Create new assignment
    final newAssignment = TeacherAssignment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      teacherId: _selectedTeacher!.id,
      teacherName: _selectedTeacher!.name,
      className: _selectedClass,
      sectionId: '${_selectedClass.replaceAll(' ', '')}$_selectedSection',
      sectionName: _selectedSection,
      subjects: _selectedSubjects,
      isClassTeacher: _isClassTeacher,
      assignedAt: DateTime.now(),
    );

    setState(() {
      _assignments.add(newAssignment);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedTeacher!.name} has been successfully assigned to $_selectedClass Section $_selectedSection'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    _selectedTeacher = null;
    _selectedSubjects.clear();
    _isClassTeacher = false;

    // In a real app, you would save the assignment to your backend/database here
    print('Assignment created: ${newAssignment.toJson()}');
  }

  void _editAssignment(TeacherAssignment assignment) {
    // Navigate to edit screen or show edit dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Assignment'),
        content: Text('Edit functionality for ${assignment.teacherName} assignment would be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteAssignment(TeacherAssignment assignment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assignment'),
        content: Text('Are you sure you want to remove ${assignment.teacherName} from ${assignment.className} Section ${assignment.sectionName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _assignments.remove(assignment);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Assignment for ${assignment.teacherName} has been removed'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
