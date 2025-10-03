import 'package:flutter/material.dart';
import '../../../../data/models/homework.dart';
import 'widgets/homework_widget.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  List<Homework> _homeworkList = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, pending, completed, overdue

  @override
  void initState() {
    super.initState();
    _fetchHomework();
  }

  Future<void> _fetchHomework() async {
    setState(() => _isLoading = true);
    
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Mock data - replace with actual API call
    _homeworkList = [
      Homework(
        id: '1',
        title: 'Algebra Practice Problems',
        details: 'Complete exercises 1-20 from chapter 5. Show all working steps and submit by the due date.',
        subjectName: 'Mathematics',
        subjectTeacherName: 'Ms. Sarah Johnson',
        dueDate: DateTime.now().add(const Duration(days: 2)),
        assignedDate: DateTime.now().subtract(const Duration(days: 3)),
        maxMarks: 25,
      ),
      Homework(
        id: '2',
        title: 'English Essay - Climate Change',
        details: 'Write a 500-word essay on the impact of climate change on our environment. Include proper citations and references.',
        subjectName: 'English Literature',
        subjectTeacherName: 'Mr. David Wilson',
        dueDate: DateTime.now().add(const Duration(days: 5)),
        assignedDate: DateTime.now().subtract(const Duration(days: 1)),
        maxMarks: 30,
      ),
      Homework(
        id: '3',
        title: 'Science Lab Report',
        details: 'Complete the lab report for the photosynthesis experiment conducted last week. Include observations, analysis, and conclusions.',
        subjectName: 'Biology',
        subjectTeacherName: 'Dr. Emily Chen',
        dueDate: DateTime.now().subtract(const Duration(days: 1)), // Overdue
        assignedDate: DateTime.now().subtract(const Duration(days: 7)),
        maxMarks: 40,
      ),
      Homework(
        id: '4',
        title: 'History Timeline Project',
        details: 'Create a timeline of major events during World War II. Include dates, key figures, and their significance.',
        subjectName: 'History',
        subjectTeacherName: 'Mr. Robert Smith',
        dueDate: DateTime.now().add(const Duration(days: 1)),
        assignedDate: DateTime.now().subtract(const Duration(days: 2)),
        maxMarks: 35,
        isCompleted: true,
      ),
      Homework(
        id: '5',
        title: 'Physics Problem Set',
        details: 'Solve problems 1-15 from the mechanics chapter. Show detailed calculations and explain your reasoning.',
        subjectName: 'Physics',
        subjectTeacherName: 'Dr. Michael Brown',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        assignedDate: DateTime.now().subtract(const Duration(days: 1)),
        maxMarks: 50,
      ),
    ];
    
    setState(() => _isLoading = false);
  }

  List<Homework> get _filteredHomework {
    switch (_selectedFilter) {
      case 'pending':
        return _homeworkList.where((h) => !h.isCompleted && !h.isOverdue).toList();
      case 'completed':
        return _homeworkList.where((h) => h.isCompleted).toList();
      case 'overdue':
        return _homeworkList.where((h) => h.isOverdue).toList();
      default:
        return _homeworkList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        backgroundColor: Colors.blue[50],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchHomework,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', 'All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('pending', 'Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('overdue', 'Overdue'),
                  const SizedBox(width: 8),
                  _buildFilterChip('completed', 'Completed'),
                ],
              ),
            ),
          ),
          
          // Homework list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredHomework.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredHomework.length,
                        itemBuilder: (context, index) {
                          final homework = _filteredHomework[index];
                          return HomeworkWidget(
                            homework: homework,
                            onTap: () => _showHomeworkDetails(homework),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue[700],
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue[700] : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    switch (_selectedFilter) {
      case 'pending':
        message = 'No pending assignments';
        icon = Icons.check_circle_outline;
        break;
      case 'completed':
        message = 'No completed assignments';
        icon = Icons.assignment_turned_in;
        break;
      case 'overdue':
        message = 'No overdue assignments';
        icon = Icons.schedule;
        break;
      default:
        message = 'No assignments found';
        icon = Icons.assignment_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new assignments',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showHomeworkDetails(Homework homework) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(homework.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Subject', homework.subjectName),
              _buildDetailRow('Teacher', homework.subjectTeacherName),
              _buildDetailRow('Due Date', _formatDate(homework.dueDate)),
              _buildDetailRow('Assigned Date', _formatDate(homework.assignedDate)),
              if (homework.maxMarks != null)
                _buildDetailRow('Max Marks', '${homework.maxMarks}'),
              const SizedBox(height: 12),
              const Text(
                'Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(homework.details),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          if (!homework.isCompleted)
            ElevatedButton(
              onPressed: () {
                // TODO: Implement mark as completed functionality
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mark as completed functionality coming soon!')),
                );
              },
              child: const Text('Mark Complete'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
