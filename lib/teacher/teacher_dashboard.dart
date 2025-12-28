import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:school_app_mvp/features/dashboard/presentation/teacher/assignment_create_screen.dart';
import '../../../../data/models/teacher.dart';
import 'assignments_main.dart';
import 'attendance_marking_screen.dart';
import 'announcement_screen.dart';
import 'marks_management_screen.dart';
//import 'homework_assignment_screen.dart';
import 'classwork_update_screen.dart';
import 'substitute_request_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  final Teacher teacher;

  const TeacherDashboardScreen({
    super.key,
    required this.teacher,
  });

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _DashboardBody(teacher: widget.teacher),
      _ClassesPage(teacher: widget.teacher),
      _ProfilePage(teacher: widget.teacher),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blueAccent[100],
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final Teacher teacher;

  const _DashboardBody({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
                  const SizedBox(height: 20),
                  _buildQuickActions(context),
                  const SizedBox(height: 20),
                  _buildRecentActivity(),
                  const SizedBox(height: 20),
                  _buildUpcomingClasses(),
                  const SizedBox(height: 20), // Add bottom padding for navigation bar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blueAccent[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Text(
                  teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : 'T',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent[100],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,// 👈 Light 300
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      teacher.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // TODO: Implement notifications
                },
                icon: Icon(Icons.notifications, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '${teacher.department} • ${teacher.subjects.join(', ')}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.school, color: Colors.blueAccent[100], size: 24),
                const SizedBox(width: 12),
                Text(
                  'Today\'s Overview',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueAccent[100],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Classes', '${teacher.classes.length}', Icons.class_),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Subjects', '${teacher.subjects.length}', Icons.book),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blueAccent[100], size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent[100],
            ),
          ),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.blueAccent[100],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildActionCard(
              'Mark Attendance',
              Icons.check_circle_outline,
              Colors.green,
              () => _navigateToAttendance(context),
            ),
            _buildActionCard(
              'Add Marks',
              Icons.grade,
              Colors.orange,
              () => _navigateToMarks(context),
            ),
            _buildActionCard(
              'Assign Homework',
              Icons.assignment,
              Colors.purple,
              () => _navigateToHomework(context),
            ),
            _buildActionCard(
              'Update Classwork',
              Icons.work_outline,
              Colors.blue,
              () => _navigateToClasswork(context),
            ),
            _buildActionCard(
              'Make Announcement',
              Icons.campaign,
              Colors.red,
              () => _navigateToAnnouncements(context),
            ),
            _buildActionCard(
              'Request Substitute',
              Icons.person_add,
              Colors.teal,
              () => _navigateToSubstitute(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildActivityItem('Marked attendance for Class 10-A', '2 hours ago', Icons.check_circle),
                const Divider(),
                _buildActivityItem('Added marks for Mathematics Quiz', '4 hours ago', Icons.grade),
                const Divider(),
                _buildActivityItem('Assigned homework to Class 9-B', '1 day ago', Icons.assignment),
                const Divider(),
                _buildActivityItem('Updated classwork for Class 11-C', '2 days ago', Icons.work),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent[100], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  time,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600],fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingClasses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Classes',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w600
            ,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildClassItem('Mathematics', 'Class 10-A', '09:00 AM', 'Room 101'),
                const Divider(),
                _buildClassItem('Physics', 'Class 11-B', '11:00 AM', 'Lab 2'),
                const Divider(),
                _buildClassItem('Mathematics', 'Class 9-C', '02:00 PM', 'Room 205'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassItem(String subject, String className, String time, String room) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.book, color: Colors.blueAccent[100], size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:  GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  '$className • $room',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600],fontWeight:FontWeight.w600),
                ),
              ],
            ),
          ),
          Text(
            time,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.blueAccent[100], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _navigateToAttendance(BuildContext context) {
    if (teacher.classes.isNotEmpty && teacher.subjects.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AttendanceMarkingScreen(
            subject: teacher.subjects.first,
            targetClass: teacher.classes.first,
            teacherId: teacher.id,
          ),
        ),
      );
    }
  }

  void _navigateToMarks(BuildContext context) {
    if (teacher.classes.isNotEmpty && teacher.subjects.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MarksManagementScreen(
            subject: teacher.subjects.first,
            targetClass: teacher.classes.first,
            teacherId: teacher.id,
            teacherName: teacher.name,
          ),
        ),
      );
    }
  }

  void _navigateToHomework(BuildContext context) {
    if (teacher.classes.isNotEmpty && teacher.subjects.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AssignmentMainPage(

          ),
        ),
      );
    }
  }

  void _navigateToClasswork(BuildContext context) {
    if (teacher.classes.isNotEmpty && teacher.subjects.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ClassworkUpdateScreen(
            subject: teacher.subjects.first,
            targetClass: teacher.classes.first,
            teacherId: teacher.id,
            teacherName: teacher.name,
          ),
        ),
      );
    }
  }

  void _navigateToAnnouncements(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementScreen(
          teacherId: teacher.id,
          teacherName: teacher.name,
          classes: teacher.classes,
        ),
      ),
    );
  }

  void _navigateToSubstitute(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubstituteRequestScreen(
          teacherId: teacher.id,
          teacherName: teacher.name,
          subjects: teacher.subjects,
          classes: teacher.classes,
        ),
      ),
    );
  }
}

class _ClassesPage extends StatelessWidget {
  final Teacher teacher;

  const _ClassesPage({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Classes'),
        backgroundColor: Colors.blueAccent[100],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: teacher.classes.length,
        itemBuilder: (context, index) {
          final className = teacher.classes[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(Icons.class_, color: Colors.blueAccent[100]),
              ),
              title: Text(className),
              subtitle: Text('Subjects: ${teacher.subjects.join(', ')}'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                _showClassDetails(context, className);
              },
            ),
          );
        },
      ),
    );
  }

  void _showClassDetails(BuildContext context, String className) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              className,
              style:  GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            _buildClassAction('Mark Attendance', Icons.check_circle, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceMarkingScreen(
                    subject: teacher.subjects.first,
                    targetClass: className,
                    teacherId: teacher.id,
                  ),
                ),
              );
            }),
            _buildClassAction('Add Marks', Icons.grade, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarksManagementScreen(
                    subject: teacher.subjects.first,
                    targetClass: className,
                    teacherId: teacher.id,
                    teacherName: teacher.name,
                  ),
                ),
              );
            }),
            _buildClassAction('Assign Homework', Icons.assignment, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AssignmentMainPage(
                  ),
                ),
              );
            }),
            _buildClassAction('Update Classwork', Icons.work_outline, () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassworkUpdateScreen(
                    subject: teacher.subjects.first,
                    targetClass: className,
                    teacherId: teacher.id,
                    teacherName: teacher.name,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildClassAction(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent[100]),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final Teacher teacher;

  const _ProfilePage({required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent[100],
        foregroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
                  (route) => false,
            );
          }, icon: const Icon(Icons.logout,color: Colors.white), tooltip: 'Logout',)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue[100],
                      child: Text(
                        teacher.name.isNotEmpty ? teacher.name[0].toUpperCase() : 'T',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent[100],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      teacher.name,
                      style:  GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      teacher.department,
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, color: Colors.grey[600],fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.email, 'Email', teacher.email),
                    _buildInfoRow(Icons.phone, 'Phone', teacher.phone),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teaching Details',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.book, 'Subjects', teacher.subjects.join(', ')),
                    _buildInfoRow(Icons.class_, 'Classes', teacher.classes.join(', ')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Add bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent[100], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600],fontWeight: FontWeight.w600),
                ),
                Text(
                  value,
                  style:  GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
