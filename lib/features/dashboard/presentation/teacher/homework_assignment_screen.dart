import 'package:flutter/material.dart';
import '../../../../data/models/homework.dart';

class HomeworkAssignmentScreen extends StatefulWidget {
  final String subject;
  final String targetClass;
  final String teacherId;
  final String teacherName;

  const HomeworkAssignmentScreen({
    super.key,
    required this.subject,
    required this.targetClass,
    required this.teacherId,
    required this.teacherName,
  });

  @override
  State<HomeworkAssignmentScreen> createState() => _HomeworkAssignmentScreenState();
}

class _HomeworkAssignmentScreenState extends State<HomeworkAssignmentScreen> {
  final List<Homework> _homeworkList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  int? _maxMarks;
  String? _attachmentUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework - ${widget.subject}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateHomeworkDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildClassInfo(),
          Expanded(
            child: _homeworkList.isEmpty
                ? _buildEmptyState()
                : _buildHomeworkList(),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No homework assigned yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create homework assignments for your class',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateHomeworkDialog,
            icon: const Icon(Icons.add),
            label: const Text('Assign Homework'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeworkList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _homeworkList.length,
      itemBuilder: (context, index) {
        final homework = _homeworkList[index];
        return _buildHomeworkCard(homework);
      },
    );
  }

  Widget _buildHomeworkCard(Homework homework) {
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
                    homework.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getUrgencyColor(homework.urgencyLevel),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    homework.urgencyLevel.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              homework.details,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Due: ${_formatDate(homework.dueDate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  homework.subjectTeacherName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                if (homework.maxMarks != null) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.grade, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    '${homework.maxMarks} marks',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  'Assigned: ${_formatDate(homework.assignedDate)}',
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
                      _editHomework(homework);
                    } else if (value == 'delete') {
                      _deleteHomework(homework);
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

  void _showCreateHomeworkDialog() {
    _titleController.clear();
    _detailsController.clear();
    _dueDate = DateTime.now().add(const Duration(days: 1));
    _maxMarks = null;
    _attachmentUrl = null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Assign Homework'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Due Date: ${_formatDate(_dueDate)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _dueDate = date;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Marks (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _maxMarks = int.tryParse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Attachment URL (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _attachmentUrl = value.isEmpty ? null : value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _createHomework,
              child: const Text('Assign'),
            ),
          ],
        ),
      ),
    );
  }

  void _editHomework(Homework homework) {
    _titleController.text = homework.title;
    _detailsController.text = homework.details;
    _dueDate = homework.dueDate;
    _maxMarks = homework.maxMarks;
    _attachmentUrl = homework.attachmentUrl;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Homework'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _detailsController,
                  decoration: const InputDecoration(
                    labelText: 'Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Due Date: ${_formatDate(_dueDate)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _dueDate = date;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Max Marks (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _maxMarks = int.tryParse(value),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Attachment URL (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => _attachmentUrl = value.isEmpty ? null : value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateHomework(homework);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteHomework(Homework homework) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Homework'),
        content: const Text('Are you sure you want to delete this homework assignment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _homeworkList.removeWhere((h) => h.id == homework.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _createHomework() {
    if (_titleController.text.isEmpty || _detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final homework = Homework(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      details: _detailsController.text,
      subjectName: widget.subject,
      subjectTeacherName: widget.teacherName,
      dueDate: _dueDate,
      assignedDate: DateTime.now(),
      attachmentUrl: _attachmentUrl,
      maxMarks: _maxMarks,
    );

    setState(() {
      _homeworkList.add(homework);
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Homework assigned successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateHomework(Homework homework) {
    final index = _homeworkList.indexWhere((h) => h.id == homework.id);
    if (index != -1) {
      setState(() {
        _homeworkList[index] = Homework(
          id: homework.id,
          title: _titleController.text,
          details: _detailsController.text,
          subjectName: homework.subjectName,
          subjectTeacherName: homework.subjectTeacherName,
          dueDate: _dueDate,
          assignedDate: homework.assignedDate,
          attachmentUrl: _attachmentUrl,
          maxMarks: _maxMarks,
        );
      });
    }
  }

  Color _getUrgencyColor(String urgencyLevel) {
    switch (urgencyLevel) {
      case 'overdue':
        return Colors.red;
      case 'urgent':
        return Colors.orange;
      case 'soon':
        return Colors.yellow[700]!;
      case 'completed':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
