import 'package:flutter/material.dart';
class AnnouncementsPage extends StatefulWidget {
  final List<Map<String , String>>? initialAnnouncements;
   const AnnouncementsPage({super.key, this.initialAnnouncements});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  late List<Map<String, String>> _announcements;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialAnnouncements != null) {
      _announcements = widget.initialAnnouncements!;
      _loading = false;
    } else {
      _fetchAnnouncements();
    }
  }
  Future<void> _fetchAnnouncements() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    _announcements = [
      {'title': 'Parent-teacher conference scheduled for next Friday', 'time': '2 hours ago'},
      {'title': 'Your Science project has been graded - Great work!', 'time': '1 day ago'},
      {'title': 'Assignment deadline reminder: English essay due tomorrow', 'time': '1 day ago'},
      {'title': 'Annual sports day preparations begin next week', 'time': '3 days ago'},
    ];
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Announcements'),backgroundColor: Colors.blueAccent[100],),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        itemCount: _announcements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final a = _announcements[i];
          return InkWell(
            onTap: () {
              // 📌 Backend: open detail / mark read
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE6E9EE)),
                boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6)],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(a['time'] ?? '', style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ]),
            ),
          );
        },
      ),
    );
  }
}