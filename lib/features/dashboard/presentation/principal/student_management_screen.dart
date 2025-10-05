import 'package:flutter/material.dart';
import '../../../../data/models/principal.dart';
import '../../../../data/models/student_transfer.dart';

class StudentManagementScreen extends StatefulWidget {
  final Principal principal;

  const StudentManagementScreen({
    super.key,
    required this.principal,
  });

  @override
  State<StudentManagementScreen> createState() => _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _studentNameController = TextEditingController();
  final _reasonController = TextEditingController();
  
  String _currentClass = 'Class 1';
  String _currentSection = 'A';
  String _newClass = 'Class 2';
  String _newSection = 'A';

  final List<String> _availableClasses = [
    'Class 1', 'Class 2', 'Class 3', 'Class 4', 'Class 5',
    'Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10',
    'Class 11', 'Class 12',
  ];

  final List<String> _availableSections = ['A', 'B', 'C', 'D', 'E'];

  List<StudentTransfer> _transferRequests = [];

  @override
  void initState() {
    super.initState();
    _loadTransferRequests();
  }

  @override
  void dispose() {
    _studentNameController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _loadTransferRequests() {
    // Sample transfer requests - in a real app, this would come from your backend
    _transferRequests = [
      StudentTransfer(
        id: '1',
        studentId: 'S001',
        studentName: 'Alice Johnson',
        currentClass: 'Class 9',
        currentSection: 'A',
        newClass: 'Class 10',
        newSection: 'A',
        reason: 'Academic performance',
        requestedBy: 'Parent',
        requestedAt: DateTime.now().subtract(const Duration(days: 5)),
        isApproved: false,
      ),
      StudentTransfer(
        id: '2',
        studentId: 'S002',
        studentName: 'Bob Smith',
        currentClass: 'Class 8',
        currentSection: 'B',
        newClass: 'Class 8',
        newSection: 'A',
        reason: 'Section change request',
        requestedBy: 'Teacher',
        requestedAt: DateTime.now().subtract(const Duration(days: 3)),
        isApproved: true,
        approvedAt: DateTime.now().subtract(const Duration(days: 1)),
        approvedBy: 'Principal',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Management'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.blue[600],
              child: const TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: 'Transfer Student'),
                  Tab(text: 'Pending Requests'),
                  Tab(text: 'All Requests'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTransferForm(),
                  _buildPendingRequests(),
                  _buildAllRequests(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferForm() {
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
                      'Student Transfer Request',
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

                    // Current Class and Section
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _currentClass,
                            decoration: const InputDecoration(
                              labelText: 'Current Class',
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
                                _currentClass = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _currentSection,
                            decoration: const InputDecoration(
                              labelText: 'Current Section',
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
                                _currentSection = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // New Class and Section
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _newClass,
                            decoration: const InputDecoration(
                              labelText: 'New Class',
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
                                _newClass = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _newSection,
                            decoration: const InputDecoration(
                              labelText: 'New Section',
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
                                _newSection = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Reason
                    TextFormField(
                      controller: _reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason for Transfer',
                        prefixIcon: Icon(Icons.note),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter reason for transfer';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submitTransferRequest,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Submit Transfer Request',
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

  Widget _buildPendingRequests() {
    final pendingRequests = _transferRequests.where((request) => !request.isApproved).toList();
    
    if (pendingRequests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No pending requests',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        final request = pendingRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.orange[100],
                      child: Icon(Icons.person, color: Colors.orange[600]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            request.studentName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Student ID: ${request.studentId}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pending',
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${request.currentClass} - Section ${request.currentSection}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.grey),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'To:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${request.newClass} - Section ${request.newSection}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Reason: ${request.reason}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => _rejectRequest(request),
                      child: Text(
                        'Reject',
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _approveRequest(request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Approve'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllRequests() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _transferRequests.length,
      itemBuilder: (context, index) {
        final request = _transferRequests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: request.isApproved ? Colors.green[100] : Colors.orange[100],
              child: Icon(
                request.isApproved ? Icons.check : Icons.pending,
                color: request.isApproved ? Colors.green[600] : Colors.orange[600],
              ),
            ),
            title: Text(
              request.studentName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${request.currentClass} Section ${request.currentSection} → ${request.newClass} Section ${request.newSection}'),
                Text('Reason: ${request.reason}'),
                if (request.isApproved)
                  Text(
                    'Approved by ${request.approvedBy} on ${request.approvedAt!.day}/${request.approvedAt!.month}/${request.approvedAt!.year}',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: request.isApproved ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                request.isApproved ? 'Approved' : 'Pending',
                style: TextStyle(
                  color: request.isApproved ? Colors.green[800] : Colors.orange[800],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _submitTransferRequest() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Create transfer request
    final transferRequest = StudentTransfer(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      studentId: 'S${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      studentName: _studentNameController.text.trim(),
      currentClass: _currentClass,
      currentSection: _currentSection,
      newClass: _newClass,
      newSection: _newSection,
      reason: _reasonController.text.trim(),
      requestedBy: widget.principal.name,
      requestedAt: DateTime.now(),
    );

    setState(() {
      _transferRequests.add(transferRequest);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transfer request for ${transferRequest.studentName} has been submitted'),
        backgroundColor: Colors.green,
      ),
    );

    // Reset form
    _studentNameController.clear();
    _reasonController.clear();
    _currentClass = 'Class 1';
    _currentSection = 'A';
    _newClass = 'Class 2';
    _newSection = 'A';

    // In a real app, you would save the transfer request to your backend/database here
    print('Transfer request created: ${transferRequest.toJson()}');
  }

  void _approveRequest(StudentTransfer request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Transfer'),
        content: Text('Are you sure you want to approve the transfer request for ${request.studentName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _transferRequests.indexWhere((r) => r.id == request.id);
                if (index != -1) {
                  _transferRequests[index] = request.copyWith(
                    isApproved: true,
                    approvedAt: DateTime.now(),
                    approvedBy: widget.principal.name,
                  );
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transfer request for ${request.studentName} has been approved'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _rejectRequest(StudentTransfer request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Transfer'),
        content: Text('Are you sure you want to reject the transfer request for ${request.studentName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _transferRequests.removeWhere((r) => r.id == request.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Transfer request for ${request.studentName} has been rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
