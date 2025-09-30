import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/student_app_bar.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/student_class_activity.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/student_profile.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/widgets/bottom_nav_bar.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/widgets/date_time_display.dart';
import 'package:school_app_mvp/features/dashboard/presentation/student/widgets/quick_options_subjects.dart';
import '../../../../data/models/student.dart';
import '../../../core/student_provider.dart';
import 'announcements_page.dart';
import 'attendance_report.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if(index==2){
      // open the profile screen instead of switching tab
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const StudentProfileScreen()),
      );
      return; // don't change _selectedIndex
    }

    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final Student? student = Provider.of<StudentProvider>(context).student;

    final List<Widget> _pages = [
      _DashboardBody(student: student),
      const Center(child: Text('Assignments Page')), // replace later
      const Center(child: Text('Profile Page')),     // replace later
    ];


    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/* ----------------- Dashboard Body ----------------- */
class _DashboardBody extends StatelessWidget {
  final Student? student;

  const _DashboardBody({required this.student});

  @override
  Widget build(BuildContext context) {
    if (student == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    // 📌 Backend: replace with real API data
    final sampleSchedules = [
      {
        'time': '09:00 AM',
        'title': 'Mathematics',
        'room': 'Ms. Sarah Johnson • Room 101'
      },
      {
        'time': '10:30 AM',
        'title': 'English',
        'room': 'Mr. Savita bhabhi • Room 205'
      },
      {
        'time': '12:00 PM',
        'title': 'Science',
        'room': 'Dr. kallu kalia • Lab 1'
      },
      {
        'time': '02:00 PM',
        'title': 'History',
        'room': 'Mr. Horny geeta • Room 103'
      },
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //  appBar stays full-width
            StudentAppBar(
              portalTitle: 'Name of the school',
              portalSubtitle: 'Track your academic progress and stay informed',
              studentName: student!.name,
              studentClass: student!.studentClass,
              rollNo: student!.rollNo,
            ),

            //  padding only for widgets below
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 14),

                  const DateTimeDisplay(),
                  const SizedBox(height: 14),

                  const Row(
                    children: [
                      Expanded(
                        child: _DemoCard(
                            title: 'Overall Attendance', value: '94%'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  const _AnnouncementSection(
                    announcements: [
                      {
                        'title': 'PTM on Oct 5 — 9:00 AM',
                        'body': 'Parents meeting in main hall'
                      }, {
                        'title': 'Holiday Notice',
                        'body': 'School closed on Oct 2 for Gandhi Jayanti'
                      }, {
                        'title': 'Science Fair',
                        'body': 'Register by Oct 10 to participate'
                      },
                    ],
                  ),
                  const SizedBox(height: 14),

                  _ScheduleSection(schedules: sampleSchedules),
                  const SizedBox(height: 14),

                  Row(
                    children: [Expanded(
                          child: _QuickAction(
                              icon: Icons.assignment_outlined, label: 'Attendance', onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_)=> const AttendanceReportScreen() )
                                );
                          })),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _QuickAction(icon: Icons.chat_bubble_outline, label: 'Class Activity', onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_)=>const ClassDiaryScreen(
                                  classId: '10A',
                                  className: 'class-10A',
                                ))
                              );


                          })),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _QuickAction(icon: Icons.subject, label: 'Subjects', onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_)=>const ClassroomMvpScreen()));
                          })),
                      const SizedBox(width: 10),
                      Expanded(
                          child: _QuickAction(
                              icon: Icons.question_answer, label: 'Ask Doubt', onTap: () {})),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/* ----------------- Small UI helpers ----------------- */

class _DemoCard extends StatelessWidget {
  final String title;
  final String value;
  const _DemoCard({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

class _ScheduleSection extends StatelessWidget {
  final List<Map<String, String>> schedules;
  const _ScheduleSection({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Today\'s Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          TextButton(onPressed: () { /* 📌 Backend: open full timetable */ }, child: const Text('View all')),
        ]),
        const SizedBox(height: 8),
        Column(
          children: List.generate(schedules.length, (i) {
            final s = schedules[i];
            return Padding(
              padding: EdgeInsets.only(bottom: i == schedules.length - 1 ? 0 : 10),
              child: _ScheduleCard(
                time: s['time'] ?? '',
                title: s['title'] ?? '',
                room: s['room'] ?? '',
                onTap: () { /* 📌 Backend: open lesson detail */ },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final String time;
  final String title;
  final String room;
  final VoidCallback onTap;
  const _ScheduleCard({required this.time, required this.title, required this.room, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9EE)),
          boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6)],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(room, style: const TextStyle(color: Colors.black54)),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(time, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.onTap, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 4)],
          ),
          child: Icon(icon),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]),
    );
  }
}

/* ----------------- Announcements ----------------- */

class _AnnouncementSection extends StatelessWidget {
  final List<Map<String, String>> announcements;
  const _AnnouncementSection({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Announcements',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,)),
            //SizedBox(width: 60),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AnnouncementsPage(initialAnnouncements: announcements),
                    ),
                  );
                },

                child: const Text('See all'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.88),
            padEnds: false,
            itemCount: announcements.length,
            itemBuilder: (context, i) {
              final a = announcements[i];
              return Padding(
                // only the fist item will not get any gap
                //it will have breathing area provided by the scaffold of the widget tree
                //the pageEnds false give no extra spacing
                padding: EdgeInsets.only(right: i == announcements.length - 1 ? 0 : 12),
                child: _AnnouncementCard(
                  title: a['title'] ?? '',
                  body: a['body'] ?? '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AnnouncementsPage(initialAnnouncements: announcements),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final String title;
  final String body;
  final VoidCallback onTap;
  const _AnnouncementCard({required this.title, required this.body, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        elevation: 3,
        clipBehavior: Clip.antiAlias, // <--- ensures children/shadow are clipped to rounded shape


        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6E9EE)),
            boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(body, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}
