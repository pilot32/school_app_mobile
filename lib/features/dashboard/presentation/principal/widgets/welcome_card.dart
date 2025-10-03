
import 'package:flutter/material.dart';

class WelcomeCard extends StatelessWidget {
  final double presentPercentage;
  const WelcomeCard({super.key, required this.presentPercentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Good Morning, Principal!',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                const Text('Here\'s your school overview for today',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(16)),
                  child: Text(
                    '${presentPercentage.toString()}% Attendance Today',
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 12),
                  ),
                ),
              ],
            )),
            Icon(Icons.school, size: 40, color: Colors.blue[300]),
          ],
        ),
      ),
    );
  }
}
