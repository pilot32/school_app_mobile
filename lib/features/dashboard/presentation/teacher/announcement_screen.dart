import 'package:flutter/material.dart';
import '../../../../data/models/announcement.dart';

class AnnouncementScreen extends StatefulWidget {
  final String teacherId;
  final String teacherName;
  final List<String> classes;

  const AnnouncementScreen({
    super.key,
    required this.teacherId,
    required this.teacherName,
    required this.classes,
  });

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final List<Announcement> _announcements = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedClass = '';
  String? _selectedSubject;
  bool _isUrgent = false;
  DateTime? _expiryDate;

  @override
  void initState() {
    super.initState();
    if (widget.classes.isNotEmpty) {
      _selectedClass = widget.classes.first;
    }
    _loadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Announcements'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateAnnouncementDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _announcements.isEmpty
                ? _buildEmptyState()
                : _buildAnnouncementsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedClass,
              decoration: const InputDecoration(
                labelText: 'Filter by Class',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: widget.classes.map((cls) {
                return DropdownMenuItem(value: cls, child: Text(cls));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClass = value ?? '';
                });
                _loadAnnouncements();
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            onPressed: _loadAnnouncements,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
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
            Icons.campaign_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No announcements yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first announcement for the class',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showCreateAnnouncementDialog,
            icon: const Icon(Icons.add),
            label: const Text('Create Announcement'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    final filteredAnnouncements = _announcements
        .where((announcement) => announcement.targetClass == _selectedClass)
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAnnouncements.length,
      itemBuilder: (context, index) {
        final announcement = filteredAnnouncements[index];
        return _buildAnnouncementCard(announcement);
      },
    );
  }

  Widget _buildAnnouncementCard(Announcement announcement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (announcement.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'URGENT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (announcement.isUrgent) const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    announcement.title,
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
                      _editAnnouncement(announcement);
                    } else if (value == 'delete') {
                      _deleteAnnouncement(announcement);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              announcement.content,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  announcement.teacherName,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.class_, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  announcement.targetClass,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const Spacer(),
                Text(
                  _formatDate(announcement.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            if (announcement.expiryDate != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.orange[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Expires: ${_formatDate(announcement.expiryDate!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: announcement.isExpired ? Colors.red : Colors.orange[600],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCreateAnnouncementDialog() {
    _titleController.clear();
    _contentController.clear();
    _isUrgent = false;
    _expiryDate = null;
    _selectedClass = widget.classes.isNotEmpty ? widget.classes.first : '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Create Announcement'),
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
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Target Class',
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
                    Checkbox(
                      value: _isUrgent,
                      onChanged: (value) {
                        setState(() {
                          _isUrgent = value ?? false;
                        });
                      },
                    ),
                    const Text('Mark as Urgent'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _expiryDate == null
                            ? 'No expiry date'
                            : 'Expires: ${_formatDate(_expiryDate!)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    TextButton(
                      onPressed: _selectExpiryDate,
                      child: const Text('Set Expiry'),
                    ),
                  ],
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
              onPressed: _createAnnouncement,
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _editAnnouncement(Announcement announcement) {
    _titleController.text = announcement.title;
    _contentController.text = announcement.content;
    _selectedClass = announcement.targetClass;
    _isUrgent = announcement.isUrgent;
    _expiryDate = announcement.expiryDate;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Announcement'),
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
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedClass,
                  decoration: const InputDecoration(
                    labelText: 'Target Class',
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
                    Checkbox(
                      value: _isUrgent,
                      onChanged: (value) {
                        setState(() {
                          _isUrgent = value ?? false;
                        });
                      },
                    ),
                    const Text('Mark as Urgent'),
                  ],
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
                _updateAnnouncement(announcement);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectExpiryDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _expiryDate = date;
      });
    }
  }

  void _createAnnouncement() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final announcement = Announcement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      content: _contentController.text,
      teacherId: widget.teacherId,
      teacherName: widget.teacherName,
      targetClass: _selectedClass,
      subject: _selectedSubject,
      createdAt: DateTime.now(),
      expiryDate: _expiryDate,
      isUrgent: _isUrgent,
    );

    setState(() {
      _announcements.add(announcement);
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Announcement created successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _updateAnnouncement(Announcement announcement) {
    final index = _announcements.indexWhere((a) => a.id == announcement.id);
    if (index != -1) {
      setState(() {
        _announcements[index] = Announcement(
          id: announcement.id,
          title: _titleController.text,
          content: _contentController.text,
          teacherId: announcement.teacherId,
          teacherName: announcement.teacherName,
          targetClass: _selectedClass,
          subject: _selectedSubject,
          createdAt: announcement.createdAt,
          expiryDate: _expiryDate,
          isUrgent: _isUrgent,
        );
      });
    }
  }

  void _deleteAnnouncement(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: const Text('Are you sure you want to delete this announcement?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _announcements.removeWhere((a) => a.id == announcement.id);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _loadAnnouncements() {
    // TODO: Implement API call to load announcements
    // For now, using sample data
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
