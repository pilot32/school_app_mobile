import 'package:flutter/material.dart';
import 'package:school_app_mvp/features/dashboard/presentation/principal/add_section_screen.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text('Principal Name',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text('principal@school.edu', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _buildDrawerItem(icon: Icons.add_box, title: 'Add Section', onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_)=>const AddSectionScreen()),
            );
          }),
          _buildDrawerItem(icon: Icons.person_add, title: 'Assign Teachers', onTap: () {}),
          _buildDrawerItem(icon: Icons.schedule, title: 'Update Time Table', onTap: () {}),
          _buildDrawerItem(icon: Icons.assignment, title: 'Manage Curriculum', onTap: () {}),
          _buildDrawerItem(icon: Icons.analytics, title: 'Reports & Analytics', onTap: () {}),
          _buildDrawerItem(icon: Icons.settings, title: 'Settings', onTap: () {}),
          const Divider(),
          _buildDrawerItem(icon: Icons.logout, title: 'Logout', onTap: () {}),
        ],
      ),
    );
  }
}
