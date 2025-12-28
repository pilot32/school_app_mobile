import 'package:flutter/material.dart';
import '../../../../data/models/substitute_request.dart';

class SubstituteRequestScreen extends StatefulWidget {
  final String teacherId;
  final String teacherName;
  final List<String> subjects;
  final List<String> classes;

  const SubstituteRequestScreen({
    super.key,
    required this.teacherId,
    required this.teacherName,
    required this.subjects,
    required this.classes,
  });

  @override
  State<SubstituteRequestScreen> createState() => _SubstituteRequestScreenState();
}

class _SubstituteRequestScreenState extends State<SubstituteRequestScreen> {
  final List<SubstituteRequest> _requests = [];
  final TextEditingController _reasonController = TextEditingController();
  String _selectedSubject = '';
  String _selectedClass = '';
  DateTime _substituteDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    if (widget.subjects.isNotEmpty) {
      _selectedSubject = widget.subjects.first;
    }
    if (widget.classes.isNotEmpty) {
      _selectedClass = widget.classes.first;
    }
    _loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Substitute Requests'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateRequestDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child: _requests.isEmpty
                ? _buildEmptyState()
                : _buildRequestsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', null),
            const SizedBox(width: 8),
            _buildFilterChip('Pending', SubstituteStatus.pending),
            const SizedBox(width: 8),
            _buildFilterChip('Approved', SubstituteStatus.approved),
            const SizedBox(width: 8),
            _buildFilterChip('Rejected', SubstituteStatus.rejected),
            const SizedBox(width: 8),
            _buildFilterChip('Completed', SubstituteStatus.completed),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, SubstituteStatus? status) {
    final isSelected = _selectedFilter == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = status;
        });
      },
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue[600],
    );
  }

  SubstituteStatus? _selectedFilter;

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No substitute requests yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Request a substitute teacher when needed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateRequestDialog,
            icon: const Icon(Icons.add),
            label: const Text('Request Substitute'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestsList() {
    final filteredRequests = _selectedFilter == null
        ? _requests
        : _requests.where((request) => request.status == _selectedFilter).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredRequests.length,
      itemBuilder: (context, index) {
        final request = filteredRequests[index];
        return _buildRequestCard(request);
      },
    );
  }

  Widget _buildRequestCard(SubstituteRequest request) {
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
                    '${request.subject} - ${request.targetClass}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(request.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    request.status.name.toUpperCase(),
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
              'Date: ${_formatDate(request.substituteDate)}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              'Reason: ${request.reason}',
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            if (request.substituteTeacherName != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.green[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Substitute: ${request.substituteTeacherName}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            if (request.adminRemarks != null && request.adminRemarks!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin Remarks:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      request.adminRemarks!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Requested: ${_formatDate(request.requestDate)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                if (request.status == SubstituteStatus.pending)
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
                        value: 'cancel',
                        child: Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Cancel', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editRequest(request);
                      } else if (value == 'cancel') {
                        _cancelRequest(request);
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

  void _showCreateRequestDialog() {
    _reasonController.clear();
    _selectedSubject = widget.subjects.isNotEmpty ? widget.subjects.first : '';
    _selectedClass = widget.classes.isNotEmpty ? widget.classes.first : '';
    _substituteDate = DateTime.now().add(const Duration(days: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Request Substitute Teacher'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.subjects.map((subject) {
                    return DropdownMenuItem(value: subject, child: Text(subject));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.classes.map((cls) {
                    return DropdownMenuItem(value: cls, child: Text(cls));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClass = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${_formatDate(_substituteDate)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _substituteDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _substituteDate = date;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason for Substitute',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
              onPressed: _createRequest,
              child: const Text('Submit Request'),
            ),
          ],
        ),
      ),
    );
  }

  void _editRequest(SubstituteRequest request) {
    _reasonController.text = request.reason;
    _selectedSubject = request.subject;
    _selectedClass = request.targetClass;
    _substituteDate = request.substituteDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Request'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedSubject,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.subjects.map((subject) {
                    return DropdownMenuItem(value: subject, child: Text(subject));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSubject = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Class',
                    border: OutlineInputBorder(),
                  ),
                  items: widget.classes.map((cls) {
                    return DropdownMenuItem(value: cls, child: Text(cls));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClass = value ?? '';
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Date: ${_formatDate(_substituteDate)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _substituteDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() {
                            _substituteDate = date;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _reasonController,
                  decoration: const InputDecoration(
                    labelText: 'Reason for Substitute',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                _updateRequest(request);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _cancelRequest(SubstituteRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text('Are you sure you want to cancel this substitute request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _requests.removeWhere((r) => r.id == request.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _createRequest() {
    if (_selectedSubject.isEmpty || _selectedClass.isEmpty || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final request = SubstituteRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      teacherId: widget.teacherId,
      teacherName: widget.teacherName,
      subject: _selectedSubject,
      targetClass: _selectedClass,
      requestDate: DateTime.now(),
      substituteDate: _substituteDate,
      reason: _reasonController.text,
      status: SubstituteStatus.pending,
    );

    setState(() {
      _requests.add(request);
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Substitute request submitted successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateRequest(SubstituteRequest request) {
    final index = _requests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      setState(() {
        _requests[index] = SubstituteRequest(
          id: request.id,
          teacherId: request.teacherId,
          teacherName: request.teacherName,
          subject: _selectedSubject,
          targetClass: _selectedClass,
          requestDate: request.requestDate,
          substituteDate: _substituteDate,
          reason: _reasonController.text,
          status: request.status,
          substituteTeacherId: request.substituteTeacherId,
          substituteTeacherName: request.substituteTeacherName,
          adminRemarks: request.adminRemarks,
          createdAt: request.createdAt,
          updatedAt: DateTime.now(),
        );
      });
    }
  }

  void _loadRequests() {
    // TODO: Implement API call to load requests
  }

  Color _getStatusColor(SubstituteStatus status) {
    switch (status) {
      case SubstituteStatus.pending:
        return Colors.orange;
      case SubstituteStatus.approved:
        return Colors.green;
      case SubstituteStatus.rejected:
        return Colors.red;
      case SubstituteStatus.completed:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}
