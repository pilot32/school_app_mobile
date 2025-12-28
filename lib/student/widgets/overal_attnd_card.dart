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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Animated Circular Progress - Made more prominent
          SizedBox(
            width: 120, // Fixed width for the circle container
            height: 120, // Fixed height for the circle container
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: overallAttendance / 100),
              duration: const Duration(seconds: 1),
              builder: (context, value, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 110, // Circle diameter
                      height: 110, // Circle diameter
                      child: CircularProgressIndicator(
                        value: value,
                        strokeWidth: 10,
                        backgroundColor: Colors.blue[200],
                        color: Colors.blue[800],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(value * 100).toInt()}%",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Overall",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(width: 20),

          // 🔹 BACKEND INTEGRATION:
          // These stats should come from your API response
          // Consider adding more stats like:
          // - Total Class Days
          // - Leave Days
          // - Attendance Percentage per subject
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Present: $totalPresent Days",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Total Absent: $totalAbsent Days",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                // 🔹 UNCOMMENT TO ADD MORE STATS FROM API:
                /*
                const SizedBox(height: 12),
                Text(
                  "Total Leave: $totalLeave Days",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Total Classes: $totalClassDays Days",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                */
              ],
            ),
          ),
        ],
      ),
    );
  }
}