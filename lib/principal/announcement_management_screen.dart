import 'package:flutter/material.dart';
import '../../../../data/models/principal.dart';
import '../../../../data/models/announcement.dart';

class AnnouncementManagementScreen extends StatefulWidget {
  final Principal principal;

  const AnnouncementManagementScreen({
    super.key,
    required this.principal,
  });

  @override
  State<AnnouncementManagementScreen> createState() => _AnnouncementManagementScreenState();
}

class _AnnouncementManagementScreenState extends State<AnnouncementManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  
  String _selectedClass = 'All Classes';
  String? _selectedSubject;
  DateTime? _expiryDate;
  bool _isUrgent = false;

  final List<String> _availableClasses = [
    'All Classes',
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
    'Class 11', 'Class 12',
  ];

  final List<String> _availableSubjects = [
    'General',
    'Mathematics',
    'Science',
    'English',
    'Social Studies',
    'Hindi',
    'Computer Science',
    'Physical Education',
    'Art',
    'Music',
    'History',
    'Geography',
    'Physics',
    'Chemistry',
    'Biology',
    'Economics',
    'Business Studies',
    'Psychology',
  ];

  List<Announcement> _announcements = [];

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _loadAnnouncements() {
    // Sample announcements - in a real app, this would come from your backend
    _announcements = [
      Announcement(
        id: '1',
        title: 'School Holiday Notice',
        content: 'School will remain closed on Monday, 15th January 2024 due to a local holiday. Classes will resume on Tuesday, 16th January 2024.',
        teacherId: widget.principal.id,
        teacherName: widget.principal.name,
        targetClass: 'All Classes',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        expiryDate: DateTime.now().add(const Duration(days: 5)),
        isUrgent: true,
      ),
      Announcement(
        id: '2',
        title: 'Parent-Teacher Meeting',
        content: 'Parent-Teacher meeting is scheduled for Saturday, 20th January 2024 from 9:00 AM to 12:00 PM. All parents are requested to attend.',
        teacherId: widget.principal.id,
        teacherName: widget.principal.name,
        targetClass: 'All Classes',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        expiryDate: DateTime.now().add(const Duration(days: 10)),
        isUrgent: false,
      ),
      Announcement(
        id: '3',
        title: 'Science Fair Registration',
        content: 'Students interested in participating in the Science Fair should register with their respective class teachers by Friday, 18th January 2024.',
        teacherId: widget.principal.id,
        teacherName: widget.principal.name,
        targetClass: 'Class 6-12',
        subject: 'Science',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        expiryDate: DateTime.now().add(const Duration(days: 3)),
        isUrgent: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcement Management'),
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
                  Tab(text: 'Create Announcement'),
                  Tab(text: 'View Announcements'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildCreateAnnouncement(),
                  _buildAnnouncementsList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAnnouncement() {
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
                      'Create New Announcement',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Announcement Title',
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter announcement title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Content
                    TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Announcement Content',
                        prefixIcon: Icon(Icons.description),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter announcement content';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Target Class
                    DropdownButtonFormField<String>(
                      value: _selectedClass,
                      decoration: const InputDecoration(
                        labelText: 'Target Class',
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

                    // Subject (Optional)
                    DropdownButtonFormField<String>(
                      value: _selectedSubject,
                      decoration: const InputDecoration(
                        labelText: 'Subject (Optional)',
                        prefixIcon: Icon(Icons.book),
                        border: OutlineInputBorder(),
                      ),
                      items: _availableSubjects.map((String subject) {
                        return DropdownMenuItem<String>(
                          value: subject,
                          child: Text(subject),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Expiry Date
                    InkWell(
                      onTap: _selectExpiryDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date (Optional)',
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _expiryDate != null
                              ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                              : 'Select expiry date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Urgent Checkbox
                    CheckboxListTile(
                      title: const Text('Mark as Urgent'),
                      subtitle: const Text('This announcement will be highlighted as urgent'),
                      value: _isUrgent,
                      onChanged: (bool? value) {
                        setState(() {
                          _isUrgent = value ?? false;
                        });
                      },
                      activeColor: Colors.red[600],
                    ),

                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitAnnouncement,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Create Announcement',
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

  Widget _buildAnnouncementsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _announcements.length,
      itemBuilder: (context, index) {
        final announcement = _announcements[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: announcement.isUrgent ? Colors.red[100] : Colors.blue[100],
              child: Icon(
                announcement.isUrgent ? Icons.warning : Icons.campaign,
                color: announcement.isUrgent ? Colors.red[600] : Colors.blue[600],
              ),
            ),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    announcement.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                if (announcement.isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'URGENT',
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Target: ${announcement.targetClass}'),
                if (announcement.subject != null)
                  Text('Subject: ${announcement.subject}'),
                Text(
                  'Created: ${announcement.createdAt.day}/${announcement.createdAt.month}/${announcement.createdAt.year}',
                ),
                if (announcement.expiryDate != null)
                  Text(
                    'Expires: ${announcement.expiryDate!.day}/${announcement.expiryDate!.month}/${announcement.expiryDate!.year}',
                  ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      announcement.content,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: () => _editAnnouncement(announcement),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          onPressed: () => _deleteAnnouncement(announcement),
                          icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                          label: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  void _submitAnnouncement() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create announcement object
    final announcement = Announcement(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      teacherId: widget.principal.id,
      teacherName: widget.principal.name,
      targetClass: _selectedClass,
      subject: _selectedSubject,
      createdAt: DateTime.now(),
      expiryDate: _expiryDate,
      isUrgent: _isUrgent,
    );

    setState(() {
      _announcements.insert(0, announcement);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Announcement "${announcement.title}" has been created successfully'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    _titleController.clear();
    _contentController.clear();
    _selectedClass = 'All Classes';
    _selectedSubject = null;
    _expiryDate = null;
    _isUrgent = false;

    // In a real app, you would save the announcement to your backend/database here
    print('Announcement created: ${announcement.toJson()}');
  }

  void _editAnnouncement(Announcement announcement) {
    // Pre-fill the form with existing data
    _titleController.text = announcement.title;
    _contentController.text = announcement.content;
    _selectedClass = announcement.targetClass;
    _selectedSubject = announcement.subject;
    _expiryDate = announcement.expiryDate;
    _isUrgent = announcement.isUrgent;

    // Show edit dialog or navigate to edit screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Announcement'),
        content: const Text('Edit functionality would be implemented here. The form would be pre-filled with the announcement data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteAnnouncement(Announcement announcement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Announcement'),
        content: Text('Are you sure you want to delete the announcement "${announcement.title}"?'),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Announcement "${announcement.title}" has been deleted'),
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
