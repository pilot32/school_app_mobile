import 'package:flutter/material.dart';
import './stat_card.dart';
//import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final Map<String, dynamic> data;
  const StatsGrid({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // If you expect dynamic items, consider building from a list instead of hardcoding six cards.
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        StatCard(title: 'Total Students', value: data['totalStudents'].toString(), icon: Icons.people, color: Colors.blue),
        StatCard(title: 'Total Teachers', value: data['totalTeachers'].toString(), icon: Icons.person, color: Colors.green),
        StatCard(title: 'Total Classes', value: data['totalClasses'].toString(), icon: Icons.class_, color: Colors.orange),
        StatCard(title: 'Absent Today', value: data['absentToday'].toString(), icon: Icons.person_off, color: Colors.red),
        StatCard(title: 'Total Subjects', value: data['totalSubjects'].toString(), icon: Icons.menu_book, color: Colors.purple),
        StatCard(title: 'Active Classes', value: '28', icon: Icons.school, color: Colors.teal),
      ],
    );
  }
}
