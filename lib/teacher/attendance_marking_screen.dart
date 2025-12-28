import 'package:flutter/material.dart';
import '../../../../data/models/attendance.dart';
import '../../../../data/models/student.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  final String subject;
  final String targetClass;
  final String teacherId;

  const AttendanceMarkingScreen({
    super.key,
    required this.subject,
    required this.targetClass,
    required this.teacherId,
  });

  @override
  State<AttendanceMarkingScreen> createState() => _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
  final Map<String, AttendanceStatus> _attendanceStatus = {};
  final Map<String, String> _remarks = {};
  DateTime _selectedDate = DateTime.now();

  // Sample students data - replace with API call
  final List<Student> _students = [
    Student(name: 'Aarav Sharma', studentClass: '10-A', rollNo: '001'),
    Student(name: 'Diya Patel', studentClass: '10-A', rollNo: '002'),
    Student(name: 'Rohan Gupta', studentClass: '10-A', rollNo: '003'),
    Student(name: 'Ananya Iyer', studentClass: '10-A', rollNo: '004'),
    Student(name: 'Kabir Singh', studentClass: '10-A', rollNo: '005'),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize all students as present by default
    for (var student in _students) {
      _attendanceStatus[student.rollNo] = AttendanceStatus.present;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance - ${widget.subject}'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAttendance,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          _buildClassInfo(),
          Expanded(child: _buildStudentList()),
          _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
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

  Widget _buildClassInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[100],
      child: Row(
        children: [
          Icon(Icons.class_, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Class: ${widget.targetClass}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.book, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Subject: ${widget.subject}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- List + Tile ----------

  Widget _buildStudentList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return _buildStudentTile(student);
      },
    );
  }

  Widget _buildStudentTile(Student student) {
    final status = _attendanceStatus[student.rollNo] ?? AttendanceStatus.present;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _showRemarksDialog(student),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with roll no
              CircleAvatar(
                backgroundColor: _getStatusColor(status),
                child: FittedBox(
                  child: Text(
                    student.rollNo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name stays horizontal
                    Text(
                      student.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text('Roll No: ${student.rollNo}',
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(height: 8),
                    // Status chips wrap on smaller widths
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildStatusChip(
                          student.rollNo,
                          AttendanceStatus.present,
                          status,
                        ),
                        _buildStatusChip(
                          student.rollNo,
                          AttendanceStatus.absent,
                          status,
                        ),
                        _buildStatusChip(
                          student.rollNo,
                          AttendanceStatus.late,
                          status,
                        ),
                        _buildStatusChip(
                          student.rollNo,
                          AttendanceStatus.excused,
                          status,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Add remarks',
                icon: const Icon(Icons.note_alt_outlined),
                onPressed: () => _showRemarksDialog(student),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Status Chip ----------

  Widget _buildStatusChip(
      String rollNo,
      AttendanceStatus status,
      AttendanceStatus currentStatus,
      ) {
    final isSelected = currentStatus == status;
    final color = _getStatusColor(status);

    return GestureDetector(
      onTap: () {
        setState(() {
          // ✅ Correctly update the specific student's status
          _attendanceStatus[rollNo] = status;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color),
        ),
        child: Text(
          status.name.toUpperCase(),
          style: TextStyle(
            color: isSelected ? Colors.white : color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ---------- Summary ----------

  Widget _buildSummaryCard() {
    final presentCount =
        _attendanceStatus.values.where((s) => s == AttendanceStatus.present).length;
    final absentCount =
        _attendanceStatus.values.where((s) => s == AttendanceStatus.absent).length;
    final lateCount =
        _attendanceStatus.values.where((s) => s == AttendanceStatus.late).length;
    final excusedCount =
        _attendanceStatus.values.where((s) => s == AttendanceStatus.excused).length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('Present', presentCount, Colors.green),
          _buildSummaryItem('Absent', absentCount, Colors.red),
          _buildSummaryItem('Late', lateCount, Colors.orange),
          _buildSummaryItem('Excused', excusedCount, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // ---------- Utils ----------

  Color _getStatusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.present:
        return Colors.green;
      case AttendanceStatus.absent:
        return Colors.red;
      case AttendanceStatus.late:
        return Colors.orange;
      case AttendanceStatus.excused:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

  void _showRemarksDialog(Student student) {
    final currentRemarks = _remarks[student.rollNo] ?? '';
    final controller = TextEditingController(text: currentRemarks);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Remarks - ${student.name}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter remarks (optional)',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _remarks[student.rollNo] = controller.text;
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _saveAttendance() {
    // TODO: Implement API call to save attendance
    final attendanceRecords = <Attendance>[];

    for (var student in _students) {
      final status = _attendanceStatus[student.rollNo] ?? AttendanceStatus.present;
      final remarks = _remarks[student.rollNo];

      attendanceRecords.add(
        Attendance(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          studentId: student.rollNo,
          studentName: student.name,
          studentClass: student.studentClass,
          subject: widget.subject,
          date: _selectedDate,
          status: status,
          remarks: remarks,
          teacherId: widget.teacherId,
        ),
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance saved for ${attendanceRecords.length} students'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
