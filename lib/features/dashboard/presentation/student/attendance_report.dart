import 'package:flutter/material.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/widgets/overal_attnd_card.dart';
//import 'package:school_app_mobile/features/dashboard/presentation/student/widgets/overal_attnd_card.dart';

/// Responsive Attendance Report Screen with compact 3-column grid.
/// - Grid uses up to 3 columns (auto-falls to 1 or 2 on narrow screens)
/// - Card contents shrink using FittedBox/Expanded so no overflows occur
/// - Replace the mock data with real API responses where indicated.
class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  // --- MOCK DATA (for testing) ---
  List<Map<String, dynamic>> _mockSubjects() => List.generate(12, (i) {
    final names = [
      "Mathematics",
      "English",
      "Physics",
      "History",
      "Chemistry",
      "Biology"
    ];
    final name = names[i % names.length] + (i >= names.length ? ' ${i ~/ names.length}' : '');
    return {
      'name': name,
      'classes': 20 + (i % 5) * 5,
      'present': 12 + (i % 8),
      'absent': (i % 4),
      'leave': (i % 3),
      'dotColor': [Colors.green, Colors.purple, Colors.orange, Colors.yellow, Colors.blue][i % 5],
    };
  });

  @override
  Widget build(BuildContext context) {
    final overallAttendance = 85;
    final totalPresent = 120;
    final totalAbsent = 20;
    final subjects = _mockSubjects();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        title: const Text(
          'ATTENDANCE REPORT',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;

          // Decide columns: prefer 3, but reduce for narrow screens
          int columns = 3;
          if (maxWidth < 420) columns = 1;
          else if (maxWidth < 760) columns = 2;
          else columns = 3;

          // Compute card aspect ratio to keep cards compact.
          // We aim for cards slightly taller than half their width (tweak as needed).
          // Avoid absolute sizes — compute from available width.
          final horizontalPadding = 32.0; // from outer padding
          final gridSpacing = 10.0;
          final usableWidth = maxWidth - horizontalPadding - (gridSpacing * (columns - 1));
          final cardWidth = usableWidth / columns;
          // Set desired card height; smaller value => more compact
          final desiredCardHeight = 110.0;
          final childAspectRatio = cardWidth / desiredCardHeight;

          return Column(
            children: [
              const SizedBox(height: 12),
              // Overall attendance (compact)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: OverallAttendanceCard(
                  overallAttendance: overallAttendance,
                  totalPresent: totalPresent,
                  totalAbsent: totalAbsent,
                ),
              ),

              const SizedBox(height: 14),

              // Grid of subject cards (Expanded so it scrolls)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    itemCount: subjects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: gridSpacing,
                      mainAxisSpacing: gridSpacing,
                      childAspectRatio: childAspectRatio.clamp(0.6, 2.5),
                    ),
                    // IMPORTANT: GridView is directly scrollable (inside Expanded)
                    itemBuilder: (context, i) {
                      final s = subjects[i];
                      // SAFE conversions (backend might send numbers as strings)
                      final name = (s['name'] ?? '').toString();
                      final classes = _toInt(s['classes']);
                      final present = _toInt(s['present']);
                      final absent = _toInt(s['absent']);
                      final leave = _toInt(s['leave']);
                      final dotColor = s['dotColor'] is Color ? s['dotColor'] as Color : Colors.grey;

                      return _CompactSubjectCard(
                        name: name,
                        classes: classes,
                        present: present,
                        absent: absent,
                        leave: leave,
                        dotColor: dotColor,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }
}

/// Compact subject card tuned to shrink content when space is limited.
class _CompactSubjectCard extends StatelessWidget {
  final String name;
  final int classes;
  final int present;
  final int absent;
  final int leave;
  final Color dotColor;

  const _CompactSubjectCard({
    required this.name,
    required this.classes,
    required this.present,
    required this.absent,
    required this.leave,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    // A LayoutBuilder inside the card helps adapt child sizing precisely.
    return LayoutBuilder(builder: (context, constraints) {
      // Determine a small badge width relative to the card width
      final badgeMaxWidth = (constraints.maxWidth * 0.45).clamp(44.0, 90.0);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title row
            Row(
              children: [
                // Name in a FittedBox so it scales down instead of overflowing
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name.toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
              ],
            ),

            const SizedBox(height: 4),

            // info column - each line wrapped into a FittedBox/Row to prevent overflow
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _smallInfoRow('Classes', classes.toString()),
                    const SizedBox(height: 2),
                    _smallInfoRow('Present', present.toString()),
                    const SizedBox(height: 2),
                    _smallInfoRow('Absent', absent.toString()),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // leave badge aligned to the right; FittedBox avoids overflow at tiny sizes
            Align(
              alignment: Alignment.bottomRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: badgeMaxWidth),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: leave > 0 ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Leave: $leave',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // small key-value row with scaling behavior
  Widget _smallInfoRow(String label, String value) {
    return Row(
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '$label: $value',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}
