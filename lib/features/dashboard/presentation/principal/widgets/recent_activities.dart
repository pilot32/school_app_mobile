import 'package:flutter/material.dart';

class RecentActivities extends StatelessWidget {
  const RecentActivities({super.key});

  Widget _buildActivityItem(String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.history, color: Colors.blue[700], size: 20),
            const SizedBox(width: 8),
            const Text('Recent Activities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ]),
          const SizedBox(height: 12),
          _buildActivityItem('New teacher assigned to Class 10-A', '2 hours ago'),
          _buildActivityItem('Time table updated for Grade 8', '4 hours ago'),
          _buildActivityItem('Monthly report generated', '1 day ago'),
          _buildActivityItem('New section added - Grade 6-B', '2 days ago'),
        ]),
      ),
    );
  }
}
