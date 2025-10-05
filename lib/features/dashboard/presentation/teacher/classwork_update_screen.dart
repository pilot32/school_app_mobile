import 'package:flutter/material.dart';
import '../../../../data/models/classwork.dart';

class ClassworkUpdateScreen extends StatefulWidget {
  final String subject;
  final String targetClass;
  final String teacherId;
  final String teacherName;

  const ClassworkUpdateScreen({
    super.key,
    required this.subject,
    required this.targetClass,
    required this.teacherId,
    required this.teacherName,
  });

  @override
  State<ClassworkUpdateScreen> createState() => _ClassworkUpdateScreenState();
}

class _ClassworkUpdateScreenState extends State<ClassworkUpdateScreen> {
  final List<Classwork> _classworkList = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _homeworkController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> _attachmentUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classwork - ${widget.subject}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateClassworkDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildClassInfo(),
          _buildDateFilter(),
          Expanded(
            child: _classworkList.isEmpty
                ? _buildEmptyState()
                : _buildClassworkList(),
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

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Colors.blue),
          const SizedBox(width: 8),
          Text(
            'Date: ${_formatDate(_selectedDate)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _selectDate,
            icon: const Icon(Icons.edit),
            label: const Text('Change'),
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
            Icons.work_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No classwork recorded yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Update classwork for ${_formatDate(_selectedDate)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateClassworkDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Classwork'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassworkList() {
    final filteredClasswork = _classworkList
        .where((classwork) => 
            classwork.date.year == _selectedDate.year &&
            classwork.date.month == _selectedDate.month &&
            classwork.date.day == _selectedDate.day)
        .toList();

    if (filteredClasswork.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No classwork for ${_formatDate(_selectedDate)}',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showCreateClassworkDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Classwork'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredClasswork.length,
      itemBuilder: (context, index) {
        final classwork = filteredClasswork[index];
        return _buildClassworkCard(classwork);
      },
    );
  }

  Widget _buildClassworkCard(Classwork classwork) {
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
                    classwork.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                      _editClasswork(classwork);
                    } else if (value == 'delete') {
                      _deleteClasswork(classwork);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              classwork.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            if (classwork.homework != null && classwork.homework!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.assignment, size: 16, color: Colors.blue[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Homework:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      classwork.homework!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (classwork.attachmentUrls != null && classwork.attachmentUrls!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: classwork.attachmentUrls!.map((url) {
                  return Chip(
                    label: Text(url.split('/').last),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        classwork.attachmentUrls!.remove(url);
                      });
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  classwork.teacherName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatTime(classwork.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateClassworkDialog() {
    _titleController.clear();
    _descriptionController.clear();
    _homeworkController.clear();
    _attachmentUrls.clear();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Classwork'),
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
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _homeworkController,
                  decoration: const InputDecoration(
                    labelText: 'Homework (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Attachment URL',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _attachmentUrls.add(value);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (_attachmentUrls.isNotEmpty) {
                          setState(() {
                            _attachmentUrls.removeLast();
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                ),
                if (_attachmentUrls.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _attachmentUrls.map((url) {
                      return Chip(
                        label: Text(url.split('/').last),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _attachmentUrls.remove(url);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _createClasswork,
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _editClasswork(Classwork classwork) {
    _titleController.text = classwork.title;
    _descriptionController.text = classwork.description;
    _homeworkController.text = classwork.homework ?? '';
    _attachmentUrls = List.from(classwork.attachmentUrls ?? []);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Classwork'),
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
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _homeworkController,
                  decoration: const InputDecoration(
                    labelText: 'Homework (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Attachment URL',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              _attachmentUrls.add(value);
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (_attachmentUrls.isNotEmpty) {
                          setState(() {
                            _attachmentUrls.removeLast();
                          });
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                ),
                if (_attachmentUrls.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _attachmentUrls.map((url) {
                      return Chip(
                        label: Text(url.split('/').last),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _attachmentUrls.remove(url);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
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
                _updateClasswork(classwork);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteClasswork(Classwork classwork) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Classwork'),
        content: const Text('Are you sure you want to delete this classwork entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _classworkList.removeWhere((c) => c.id == classwork.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _createClasswork() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final classwork = Classwork(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      subject: widget.subject,
      teacherId: widget.teacherId,
      teacherName: widget.teacherName,
      targetClass: widget.targetClass,
      date: _selectedDate,
      attachmentUrls: _attachmentUrls.isNotEmpty ? _attachmentUrls : null,
      homework: _homeworkController.text.isEmpty ? null : _homeworkController.text,
    );

    setState(() {
      _classworkList.add(classwork);
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Classwork added successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateClasswork(Classwork classwork) {
    final index = _classworkList.indexWhere((c) => c.id == classwork.id);
    if (index != -1) {
      setState(() {
        _classworkList[index] = Classwork(
          id: classwork.id,
          title: _titleController.text,
          description: _descriptionController.text,
          subject: classwork.subject,
          teacherId: classwork.teacherId,
          teacherName: classwork.teacherName,
          targetClass: classwork.targetClass,
          date: classwork.date,
          attachmentUrls: _attachmentUrls.isNotEmpty ? _attachmentUrls : null,
          homework: _homeworkController.text.isEmpty ? null : _homeworkController.text,
        );
      });
    }
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _homeworkController.dispose();
    super.dispose();
  }
}
