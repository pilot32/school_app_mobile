import 'package:flutter/material.dart';

class OverallAttendanceCard extends StatelessWidget {
  final int overallAttendance;
  final int totalPresent;
  final int totalAbsent;

  const OverallAttendanceCard({
    super.key,
    required this.overallAttendance,
    required this.totalPresent,
    required this.totalAbsent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Animated Circular Progress
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: overallAttendance / 100),
            duration: const Duration(seconds: 1),
            builder: (context, value, child) {
              return SizedBox(
                width: 140,  // 🔹 Increased size
                height: 140, // 🔹 Increased size
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: value,
                      strokeWidth: 8, // 🔹 Slightly thicker but not overwhelming
                      backgroundColor: Colors.blue[200],
                      color: Colors.blue[800],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(value * 100).toInt()}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16, // 🔹 Bigger text
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Overall",
                          style: TextStyle(
                            fontSize: 10, // 🔹 Slightly bigger label
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(width: 20),

          // Attendance stats
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Present: $totalPresent Days",
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total Absent: $totalAbsent Days",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
