import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/diary_entry.dart';
import '../../../core/diary_provider.dart';


class ClassDiaryScreen extends StatefulWidget {
  final String classId;
  final String className;

  const ClassDiaryScreen({Key? key, required this.classId, required this.className}) : super(key: key);

  @override
  State<ClassDiaryScreen> createState() => _ClassDiaryScreenState();
}

class _ClassDiaryScreenState extends State<ClassDiaryScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<DiaryProvider>().fetchEntries(widget.classId, selectedDate));
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
      context.read<DiaryProvider>().fetchEntries(widget.classId, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiaryProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[100],
        title: Text('${widget.className} Diary'),
        actions: [
          IconButton(icon: const Icon(Icons.calendar_today), onPressed: _pickDate),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchEntries(widget.classId, selectedDate),
        child: Builder(
          builder: (_) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(child: Text('Error: ${provider.error}'));
            }
            if (provider.entries.isEmpty) {
              return const Center(child: Text('No diary entries for this date.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: provider.entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final entry = provider.entries[index];
                return Card(
                  color: Colors.yellow[50],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(

                    leading: _iconForType(entry.type),
                    title: Text(entry.title),
                    subtitle: Text('${entry.details}\nBy ${entry.teacher}'),
                    isThreeLine: true,
                    trailing: Text(
                      '${entry.dateTime.hour}:${entry.dateTime.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _iconForType(DiaryType type) {
    switch (type) {
      case DiaryType.lesson:
        return const Icon(Icons.school);
      case DiaryType.homework:
        return const Icon(Icons.edit_note);
      case DiaryType.sports:
        return const Icon(Icons.sports_soccer);
      case DiaryType.notice:
        return const Icon(Icons.announcement);
      default:
        return const Icon(Icons.note);
    }
  }
}
