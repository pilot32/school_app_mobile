import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Minimal MVP: classroom tiles -> resources -> internal pdf viewer
/// Replace TODO comments with your backend integration.

/// ------------------ Models ------------------
class Subject {
  final String id;
  final String title;
  final String teacher;
  final Color color;
  final String avatarInitial;

  Subject({
    required this.id,
    required this.title,
    required this.teacher,
    required this.color,
    required this.avatarInitial,
  });
}

class ResourceItem {
  final String id;
  final String title;
  final String mime; // e.g. 'application/pdf'
  final String url; // file URL (mock or real)
  final DateTime uploadedOn;

  ResourceItem({
    required this.id,
    required this.title,
    required this.mime,
    required this.url,
    required this.uploadedOn,
  });
}

/// ------------------ Mock data (for MVP testing) ------------------
// You will replace these with backend calls where noted.
final List<Subject> _mockSubjects = [
  Subject(id: 's1', title: 'CN Lab CSE-10', teacher: 'Dr. B. Sahoo', color: Colors.deepPurple, avatarInitial: 'B'),
  Subject(id: 's2', title: 'CSE 10 EE', teacher: 'Gayatri Nayak', color: Colors.teal, avatarInitial: 'G'),
];

/// Use a simple public PDF for mock testing:
const String _mockPdfUrl = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';

final Map<String, List<ResourceItem>> _mockResources = {
  's1': [
    ResourceItem(
      id: 'r1',
      title: 'Lab Notes - Week 1 (PDF)',
      mime: 'application/pdf',
      url: _mockPdfUrl,
      uploadedOn: DateTime(2024, 6, 1),
    ),
    ResourceItem(
      id: 'r2',
      title: 'Experiment Writeup (PDF)',
      mime: 'application/pdf',
      url: _mockPdfUrl,
      uploadedOn: DateTime(2024, 7, 3),
    ),
  ],
  's2': [
    ResourceItem(
      id: 'r3',
      title: 'Lecture Slides (PDF)',
      mime: 'application/pdf',
      url: _mockPdfUrl,
      uploadedOn: DateTime(2024, 5, 12),
    ),
  ],
};

/// ------------------ Screens ------------------

/// Entry widget you can push to Navigator
class ClassroomMvpScreen extends StatelessWidget {
  const ClassroomMvpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Minimal scaffold with simple appbar
    return Scaffold(
      appBar: AppBar(title: const Text('Resources'),backgroundColor: Colors.blueAccent[100],),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: _mockSubjects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final s = _mockSubjects[i];
          return _SubjectCard(subject: s, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SubjectResourcesScreen(subject: s)),
            );
          });
        },
      ),
    );
  }
}

/// Simple card similar-feel to screenshot but minimal
class _SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const _SubjectCard({required this.subject, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 120,
          child: Column(
            children: [
              // header band
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.yellow[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          subject.title,
                          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Text(subject.avatarInitial, style: TextStyle(color: subject.color, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),

              // bottom area: teacher + actions (minimal)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(child: Text(subject.teacher)),
                      IconButton(
                        icon: const Icon(Icons.folder_open_outlined),
                        onPressed: onTap, // same behavior: open resources
                        tooltip: 'Open resources',
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Resources list for a subject (fetches from backend or uses mock)
class SubjectResourcesScreen extends StatefulWidget {
  final Subject subject;
  const SubjectResourcesScreen({required this.subject, Key? key}) : super(key: key);

  @override
  State<SubjectResourcesScreen> createState() => _SubjectResourcesScreenState();
}

class _SubjectResourcesScreenState extends State<SubjectResourcesScreen> {
  late Future<List<ResourceItem>> _futureResources;

  @override
  void initState() {
    super.initState();
    _futureResources = _loadResources();
  }

  Future<List<ResourceItem>> _loadResources() async {
    // TODO: BACKEND - replace this with an API call that fetches resources for the subject.
    // Example:
    // final resp = await api.getResources(subjectId: widget.subject.id);
    // return resp.items;
    //
    // Keep authentication tokens, pagination, and mimeType in mind.

    // Simulate a small delay to mimic network fetch
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockResources[widget.subject.id] ?? [];
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final subject = widget.subject;
    return Scaffold(
      appBar: AppBar(title: Text(subject.title)),
      body: FutureBuilder<List<ResourceItem>>(
        future: _futureResources,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Failed to load resources'));
          final items = snap.data ?? [];
          if (items.isEmpty) return const Center(child: Text('No resources yet'));

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final r = items[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(r.title),
                  subtitle: Text('Uploaded: ${_formatDate(r.uploadedOn)}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Only handling PDFs in this MVP. Check mime or file extension in real app.
                    if (r.mime.contains('pdf')) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => PdfViewerScreen(title: r.title, url: r.url)),
                      );
                    } else {
                      // TODO: handle docs or other mime types (optional)
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File type not supported in MVP')));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// Minimal PDF viewer screen (internal)
class PdfViewerScreen extends StatelessWidget {
  final String title;
  final String url;
  const PdfViewerScreen({required this.title, required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NOTE: syncfusion pdf viewer can load network PDFs directly.
    // If your files are protected, fetch bytes with auth and use PdfViewer.memory (advanced).
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.network(url),
    );
  }
}

/// ------------------ Example: how to wire into your app ------------------
/// Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassroomMvpScreen()));
