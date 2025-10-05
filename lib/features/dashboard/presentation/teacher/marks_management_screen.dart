import 'package:flutter/material.dart';
import '../../../../data/models/marks.dart';
import '../../../../data/models/student.dart';

class MarksManagementScreen extends StatefulWidget {
  final String subject;
  final String targetClass;
  final String teacherId;
  final String teacherName;

  const MarksManagementScreen({
    super.key,
    required this.subject,
    required this.targetClass,
    required this.teacherId,
    required this.teacherName,
  });

  @override
  State<MarksManagementScreen> createState() => _MarksManagementScreenState();
}

class _MarksManagementScreenState extends State<MarksManagementScreen> {
  final List<Marks> _marksList = [];
  final List<Student> _students = [];
  ExamType _selectedExamType = ExamType.assignment;
  String _examTitle = '';
  double _totalMarks = 100.0;
  DateTime _examDate = DateTime.now();
  final Map<String, double> _studentMarks = {};
  final Map<String, String> _studentRemarks = {};

  @override
  void initState() {
    super.initState();
    _loadStudents();
    _loadMarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marks - ${widget.subject}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddMarksDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildClassInfo(),
          _buildExamTypeFilter(),
          Expanded(
            child: _marksList.isEmpty
                ? _buildEmptyState()
                : _buildMarksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Icon(Icons.class_, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Text(
            'Class: ${widget.targetClass}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 16),
          Icon(Icons.book, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Text(
            'Subject: ${widget.subject}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildExamTypeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ExamType.values.map((type) {
            final isSelected = _selectedExamType == type;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type.name.toUpperCase()),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _selectedExamType = type;
                  });
                  _loadMarks();
                },
                selectedColor: Colors.blue[100],
                checkmarkColor: Colors.blue[600],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assessment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No marks recorded yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add marks for ${_selectedExamType.name}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddMarksDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Marks'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarksList() {
    final filteredMarks = _marksList
        .where((marks) => marks.examType == _selectedExamType)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredMarks.length,
      itemBuilder: (context, index) {
        final marks = filteredMarks[index];
        return _buildMarksCard(marks);
      },
    );
  }

  Widget _buildMarksCard(Marks marks) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    marks.examTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getGradeColor(marks.grade),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    marks.grade,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${marks.obtainedMarks}/${marks.totalMarks}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${marks.percentage.toStringAsFixed(1)}%)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(marks.examDate),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            if (marks.remarks != null && marks.remarks!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Remarks: ${marks.remarks}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  marks.studentName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.class_, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  marks.studentClass,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                PopupMenuButton(
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
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editMarks(marks);
                    } else if (value == 'delete') {
                      _deleteMarks(marks);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMarksDialog() {
    _examTitle = '';
    _totalMarks = 100.0;
    _examDate = DateTime.now();
    _studentMarks.clear();
    _studentRemarks.clear();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Marks'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<ExamType>(
                    value: _selectedExamType,
                    decoration: const InputDecoration(
                      labelText: 'Exam Type',
                      border: OutlineInputBorder(),
                    ),
                    items: ExamType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedExamType = value ?? ExamType.assignment;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Exam Title',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _examTitle = value,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Total Marks',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _totalMarks = double.tryParse(value) ?? 100.0,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Date: ${_formatDate(_examDate)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _examDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _examDate = date;
                            });
                          }
                        },
                        child: const Text('Select Date'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Student Marks:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ..._students.map((student) => _buildStudentMarksInput(student)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _saveMarks,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentMarksInput(Student student) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(student.name),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Marks',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _studentMarks[student.rollNo] = double.tryParse(value) ?? 0.0;
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Remarks',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              onChanged: (value) {
                _studentRemarks[student.rollNo] = value;
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editMarks(Marks marks) {
    // TODO: Implement edit functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit functionality coming soon')),
    );
  }

  void _deleteMarks(Marks marks) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Marks'),
        content: const Text('Are you sure you want to delete these marks?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _marksList.removeWhere((m) => m.id == marks.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _saveMarks() {
    if (_examTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter exam title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    for (var student in _students) {
      final obtainedMarks = _studentMarks[student.rollNo] ?? 0.0;
      final remarks = _studentRemarks[student.rollNo];

      final marks = Marks(
        id: DateTime.now().millisecondsSinceEpoch.toString() + student.rollNo,
        studentId: student.rollNo,
        studentName: student.name,
        studentClass: student.studentClass,
        subject: widget.subject,
        teacherId: widget.teacherId,
        teacherName: widget.teacherName,
        examType: _selectedExamType,
        examTitle: _examTitle,
        obtainedMarks: obtainedMarks,
        totalMarks: _totalMarks,
        examDate: _examDate,
        remarks: remarks,
        createdAt: DateTime.now(),
      );

      _marksList.add(marks);
    }

    setState(() {});
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Marks saved successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _loadStudents() {
    // TODO: Implement API call to load students
    // Sample data for now
    _students.addAll([
      Student(name: 'John Doe', studentClass: widget.targetClass, rollNo: '001'),
      Student(name: 'Jane Smith', studentClass: widget.targetClass, rollNo: '002'),
      Student(name: 'Mike Johnson', studentClass: widget.targetClass, rollNo: '003'),
      Student(name: 'Sarah Wilson', studentClass: widget.targetClass, rollNo: '004'),
      Student(name: 'David Brown', studentClass: widget.targetClass, rollNo: '005'),
    ]);
  }

  void _loadMarks() {
    // TODO: Implement API call to load marks
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
      case 'A':
        return Colors.green;
      case 'B+':
      case 'B':
        return Colors.blue;
      case 'C+':
      case 'C':
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
