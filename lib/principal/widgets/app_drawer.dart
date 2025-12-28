import 'package:flutter/material.dart';
import '../../../../../data/models/principal.dart';
//import '../../../../data/models/principal.dart';
import '../add_section_screen.dart';
import '../teacher_onboarding_screen.dart';
import '../student_application_form_screen.dart';
import '../teacher_assignment_screen.dart';
import '../student_management_screen.dart';
import '../announcement_management_screen.dart';
import '../fee_management_screen.dart';

class AppDrawer extends StatelessWidget {
  final Principal principal;

  const AppDrawer({super.key, required this.principal});

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap
}){
    return ListTile(
      leading: Icon(icon,color: Colors.blue[100],),
      title: Text(title),
      onTap: onTap,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[800]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    principal.name.isNotEmpty ? principal.name[0].toUpperCase() : 'P',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[600],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  principal.name,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  principal.email,
                  style: const TextStyle(color: Colors.white70),
                ),
                Text(
                  principal.schoolName,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildDrawerItem(icon: Icons.person_add, title: 'Onboard Teachers', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TeacherOnboardingScreen(principal: principal)),
            );
          }),
          _buildDrawerItem(icon: Icons.assignment, title: 'Student Applications', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => StudentApplicationFormScreen(principal: principal)),
            );
          }),
          _buildDrawerItem(icon: Icons.group_work, title: 'Assign Teachers', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TeacherAssignmentScreen(principal: principal)),
            );
          }),
          _buildDrawerItem(icon: Icons.school, title: 'Manage Students', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => StudentManagementScreen(principal: principal)),
            );
          }),
          _buildDrawerItem(icon: Icons.campaign, title: 'Manage Announcements', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AnnouncementManagementScreen(principal: principal)),
            );
          }),
          _buildDrawerItem(icon: Icons.attach_money, title: 'Manage Fees', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => FeeManagementScreen(principal: principal)),
            );
          }),
          _buildDrawerItem(icon: Icons.add_box, title: 'Add Section', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AddSectionScreen()),
            );
          }),
          const Divider(),
          _buildDrawerItem(icon: Icons.logout, title: 'Logout', onTap: () {}),
        ],
      ),
    );
  }
}
