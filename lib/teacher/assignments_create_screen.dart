// import 'package:flutter/material.dart';
// import '../../../../data/models/classwork.dart';
//
// class AssignmentsScreen extends StatefulWidget {
//   final String subject;
//   final String targetClass;
//   final String teacherId;
//   final String teacherName;
//
//   const AssignmentsScreen({
//     super.key,
//     required this.subject,
//     required this.targetClass,
//     required this.teacherId,
//     required this.teacherName,
//   });
//
//   @override
//   State<AssignmentsScreen> createState() => _AssignmentsScreenState();
// }
//
// class _AssignmentsScreenState extends State<AssignmentsScreen> {
//   final List<Classwork> _assignmentsList = [];
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _dueDateController = TextEditingController();
//   DateTime _selectedDate = DateTime.now();
//   List<String> _attachmentUrls = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Assignments - ${widget.subject}'),
//         backgroundColor: Colors.blue[600],
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: _showCreateAssignmentDialog,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           _buildClassInfo(),
//           Expanded(
//             child: _assignmentsList.isEmpty
//                 ? _buildEmptyState()
//                 : _buildAssignmentsList(),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildClassInfo() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       color: Colors.grey[100],
//       child: Row(
//         children: [
//           Icon(Icons.class_, color: Colors.blue[600]),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               'Class: ${widget.targetClass}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               softWrap: false,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Icon(Icons.book, color: Colors.blue[600]),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               'Subject: ${widget.subject}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               softWrap: false,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.assignment_outlined,
//             size: 64,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No assignments created yet',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 24),
//           ElevatedButton.icon(
//             onPressed: _showCreateAssignmentDialog,
//             icon: const Icon(Icons.add),
//             label: const Text('Create Assignment'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue[600],
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAssignmentsList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: _assignmentsList.length,
//       itemBuilder: (context, index) {
//         final assignment = _assignmentsList[index];
//         return _buildAssignmentCard(assignment);
//       },
//     );
//   }
//
//   Widget _buildAssignmentCard(Classwork assignment) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     assignment.title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 PopupMenuButton(
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: 'edit',
//                       child: Row(
//                         children: [
//                           Icon(Icons.edit),
//                           SizedBox(width: 8),
//                           Text('Edit'),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuItem(
//                       value: 'delete',
//                       child: Row(
//                         children: [
//                           Icon(Icons.delete, color: Colors.red),
//                           SizedBox(width: 8),
//                           Text('Delete', style: TextStyle(color: Colors.red)),
//                         ],
//                       ),
//                     ),
//                   ],
//                   onSelected: (value) {
//                     if (value == 'edit') {
//                       _editAssignment(assignment);
//                     } else if (value == 'delete') {
//                       _deleteAssignment(assignment);
//                     }
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               assignment.description,
//               style: const TextStyle(fontSize: 14, color: Colors.black87),
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 Icon(Icons.calendar_today, size: 16, color: Colors.red[400]),
//                 const SizedBox(width: 4),
//                 Text(
//                   'Due: ${_formatDate(assignment.date)}',
//                   style: TextStyle(fontSize: 12, color: Colors.red[400], fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showCreateAssignmentDialog() {
//     _titleController.clear();
//     _descriptionController.clear();
//     _selectedDate = DateTime.now().add(const Duration(days: 1));
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Create Assignment'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(
//                     labelText: 'Title',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(
//                     labelText: 'Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 4,
//                 ),
//                 const SizedBox(height: 16),
//                 InkWell(
//                   onTap: () async {
//                     final date = await showDatePicker(
//                       context: context,
//                       initialDate: _selectedDate,
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(const Duration(days: 365)),
//                     );
//                     if (date != null) {
//                       setState(() {
//                         _selectedDate = date;
//                       });
//                     }
//                   },
//                   child: InputDecorator(
//                     decoration: const InputDecoration(
//                       labelText: 'Due Date',
//                       border: OutlineInputBorder(),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(_formatDate(_selectedDate)),
//                         const Icon(Icons.calendar_today),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: _createAssignment,
//               child: const Text('Create'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _editAssignment(Classwork assignment) {
//     _titleController.text = assignment.title;
//     _descriptionController.text = assignment.description;
//     _selectedDate = assignment.date;
//
//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setState) => AlertDialog(
//           title: const Text('Edit Assignment'),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: const InputDecoration(
//                     labelText: 'Title',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(
//                     labelText: 'Description',
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 4,
//                 ),
//                 const SizedBox(height: 16),
//                 InkWell(
//                   onTap: () async {
//                     final date = await showDatePicker(
//                       context: context,
//                       initialDate: _selectedDate,
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(const Duration(days: 365)),
//                     );
//                     if (date != null) {
//                       setState(() {
//                         _selectedDate = date;
//                       });
//                     }
//                   },
//                   child: InputDecorator(
//                     decoration: const InputDecoration(
//                       labelText: 'Due Date',
//                       border: OutlineInputBorder(),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(_formatDate(_selectedDate)),
//                         const Icon(Icons.calendar_today),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _updateAssignment(assignment);
//                 Navigator.pop(context);
//               },
//               child: const Text('Update'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _deleteAssignment(Classwork assignment) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Assignment'),
//         content: const Text('Are you sure you want to delete this assignment?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _assignmentsList.removeWhere((c) => c.id == assignment.id);
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _createAssignment() {
//     if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all required fields'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }
//
//     final assignment = Classwork(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       title: _titleController.text,
//       description: _descriptionController.text,
//       subject: widget.subject,
//       teacherId: widget.teacherId,
//       teacherName: widget.teacherName,
//       targetClass: widget.targetClass,
//       date: _selectedDate,
//     );
//
//     setState(() {
//       _assignmentsList.add(assignment);
//     });
//
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Assignment created successfully'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   void _updateAssignment(Classwork assignment) {
//     final index = _assignmentsList.indexWhere((c) => c.id == assignment.id);
//     if (index != -1) {
//       setState(() {
//         _assignmentsList[index] = Classwork(
//           id: assignment.id,
//           title: _titleController.text,
//           description: _descriptionController.text,
//           subject: assignment.subject,
//           teacherId: assignment.teacherId,
//           teacherName: assignment.teacherName,
//           targetClass: assignment.targetClass,
//           date: _selectedDate,
//         );
//       });
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _dueDateController.dispose();
//     super.dispose();
//   }
// }
