import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../data/models/principal.dart';
import 'teacher_onboarding_screen.dart';
import 'student_application_form_screen.dart';
import 'teacher_assignment_screen.dart';
import 'student_management_screen.dart';
import 'announcement_management_screen.dart';
import 'fee_management_screen.dart';

class PrincipalDashboardScreen extends StatefulWidget {
  final Principal principal;

  const PrincipalDashboardScreen({
    super.key,
    required this.principal,
  });

  @override
  State<PrincipalDashboardScreen> createState() => _PrincipalDashboardScreenState();
}

class _PrincipalDashboardScreenState extends State<PrincipalDashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _DashboardBody(principal: widget.principal),
      _ManagementPage(principal: widget.principal),
      _ProfilePage(principal: widget.principal),
    ];

    final base = Theme.of(context);
    final plusJakartaTextTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);
    final themed = base.copyWith(
      textTheme: plusJakartaTextTheme.copyWith(
        headlineLarge: plusJakartaTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
        headlineMedium: plusJakartaTextTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        headlineSmall: plusJakartaTextTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        titleLarge: plusJakartaTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: plusJakartaTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        titleSmall: plusJakartaTextTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        bodyLarge: plusJakartaTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
        bodyMedium: plusJakartaTextTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
        bodySmall: plusJakartaTextTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
        labelLarge: plusJakartaTextTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        labelMedium: plusJakartaTextTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
        labelSmall: plusJakartaTextTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.plusJakartaSans(
          textStyle: base.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ) ??
              const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );

    return Theme(
      data: themed,
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            backgroundColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue[600],
            unselectedItemColor: Colors.grey[600],
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings),
                label: 'Management',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final Principal principal;

  const _DashboardBody({required this.principal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue[600]),
          ),
        ),
        title: const Text('Principal Dashboard'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            Card(
              elevation: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${principal.name}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Principal of ${principal.schoolName}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Quick Stats
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Teachers',
                    value: '45',
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Students',
                    value: '1,250',
                    icon: Icons.school,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Classes',
                    value: '12',
                    icon: Icons.class_,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Applications',
                    value: '23',
                    icon: Icons.description,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _ActionCard(
                  title: 'Teacher Onboarding',
                  icon: Icons.person_add,
                  color: Colors.green,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherOnboardingScreen(principal: principal),
                    ),
                  ),
                ),
                _ActionCard(
                  title: 'Student Applications',
                  icon: Icons.description,
                  color: Colors.blue,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentApplicationFormScreen(principal: principal),
                    ),
                  ),
                ),
                _ActionCard(
                  title: 'Teacher Assignments',
                  icon: Icons.assignment,
                  color: Colors.orange,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TeacherAssignmentScreen(principal: principal),
                    ),
                  ),
                ),
                _ActionCard(
                  title: 'Student Management',
                  icon: Icons.people_alt,
                  color: Colors.purple,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentManagementScreen(principal: principal),
                    ),
                  ),
                ),
                _ActionCard(
                  title: 'Announcements',
                  icon: Icons.campaign,
                  color: Colors.red,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnouncementManagementScreen(principal: principal),
                    ),
                  ),
                ),
                _ActionCard(
                  title: 'Fee Management',
                  icon: Icons.account_balance_wallet,
                  color: Colors.teal,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeeManagementScreen(principal: principal),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black,fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManagementPage extends StatelessWidget {
  final Principal principal;

  const _ManagementPage({required this.principal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Management'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _ManagementTile(
            title: 'Teacher Onboarding',
            subtitle: 'Add new teachers to the system',
            icon: Icons.person_add,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherOnboardingScreen(principal: principal),
              ),
            ),
          ),
          _ManagementTile(
            title: 'Student Applications',
            subtitle: 'Review and manage student applications',
            icon: Icons.description,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentApplicationFormScreen(principal: principal),
              ),
            ),
          ),
          _ManagementTile(
            title: 'Teacher Assignments',
            subtitle: 'Assign teachers to classes and subjects',
            icon: Icons.assignment,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherAssignmentScreen(principal: principal),
              ),
            ),
          ),
          _ManagementTile(
            title: 'Student Management',
            subtitle: 'Manage student transfers and class changes',
            icon: Icons.people_alt,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentManagementScreen(principal: principal),
              ),
            ),
          ),
          _ManagementTile(
            title: 'Announcements',
            subtitle: 'Create and manage school announcements',
            icon: Icons.campaign,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AnnouncementManagementScreen(principal: principal),
              ),
            ),
          ),
          _ManagementTile(
            title: 'Fee Management',
            subtitle: 'Manage fee structures and payments',
            icon: Icons.account_balance_wallet,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeeManagementScreen(principal: principal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagementTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ManagementTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  final Principal principal;

  const _ProfilePage({required this.principal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: Colors.white),
            tooltip: 'Logout',
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.blue[100],
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.blue[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      principal.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Principal',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      principal.schoolName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(icon: Icons.email, label: 'Email', value: principal.email),
                    _InfoRow(icon: Icons.phone, label: 'Phone', value: principal.phone),
                    _InfoRow(
                      icon: Icons.calendar_today,
                      label: 'Joined',
                      value: '${principal.createdAt.day}/${principal.createdAt.month}/${principal.createdAt.year}',
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
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}