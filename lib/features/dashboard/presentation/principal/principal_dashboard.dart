import 'package:flutter/material.dart';
import 'package:school_app_mvp/features/dashboard/presentation/principal/widgets/app_drawer.dart';
import 'package:school_app_mvp/features/dashboard/presentation/principal/widgets/recent_activities.dart';
import 'package:school_app_mvp/features/dashboard/presentation/principal/widgets/stats_grid.dart';
import 'package:school_app_mvp/features/dashboard/presentation/principal/widgets/welcome_card.dart';
class PrincipalDashboard extends StatefulWidget {
  const PrincipalDashboard({super.key});

  @override
  State<PrincipalDashboard> createState() => _PrincipalDashboardState();
}

class _PrincipalDashboardState extends State<PrincipalDashboard> {
  int _currentIndex=0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //mock data
  //in prod must come from the api calls to db
  final Map<String, dynamic> dashboardData = {
    'totalStudents': 1250,
    'totalTeachers': 65,
    'totalClasses': 35,
    'absentToday': 42,
    'totalSubjects': 15,
    'presentPercentage': 96.6,
  };
  // simple pages for bottom navigation bar we can add or replace the later
  Widget _pageForIndex(int idx){
    switch(idx){
      case 1:
        return const Center(child: Text('Schedule Page(placeholder)'));
      case 2:
        return const Center(child: Text('Analytics Page (placeholder)'));
      case 3:
        return const Center(child: Text('Messages Page (placeholder)'));
      case 4:
        return const Center(child: Text('Profile Page (placeholder)'));
      default:
        return _dashboardBody();
    }
  }
  // when nothing choosesit automatically return to dashboard body
  //fucntion which handles it is this
  Widget _dashboardBody(){
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeCard(presentPercentage: dashboardData['presentPercentage']),
          const SizedBox(height: 20),
          const Text(
            'Quick Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          StatsGrid(
            data: dashboardData,
          ),
          const SizedBox(height: 20),
          const RecentActivities(),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          key:  _scaffoldKey,
      appBar: AppBar(
        title: const Text('Principal Dashboard'),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(onPressed: ()=>_scaffoldKey.currentState?.openDrawer(), icon: const Icon(Icons.menu)),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.notifications),),
      ],
      ),
      drawer: const AppDrawer(),
        body: _pageForIndex(_currentIndex),
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (index) => setState(() => _currentIndex = index),
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.blue[800],
    unselectedItemColor: Colors.grey[600],
    items: const [
    BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
    BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Schedule'),
    BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
    BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Messages'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
    ),

    );
  }
}
