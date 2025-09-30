import 'dart:async';
import 'package:flutter/material.dart';
// Live date & time display (updates every second)
class DateTimeDisplay extends StatefulWidget {
  const DateTimeDisplay({Key? key}) : super(key: key);

  @override
  State<DateTimeDisplay> createState() => DateTimeDisplayState();
}

class DateTimeDisplayState extends State<DateTimeDisplay> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  static const List<String> _months = [
    'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
  ];
  static const List<String> _weekdays = [
    'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime t) {
    final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final m = t.minute.toString().padLeft(2, '0');
    final ap = t.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  String _formatDate(DateTime t) {
    return '${_weekdays[t.weekday % 7]}, ${t.day} ${_months[t.month - 1]} ${t.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_formatDate(_now),
            style: const TextStyle(fontSize: 13, color: Colors.black54,fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(_formatTime(_now),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
      ],
    );
  }
}
