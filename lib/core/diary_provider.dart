import 'package:flutter/material.dart';

import '../../data/models/diary_entry.dart';
class DiaryProvider extends ChangeNotifier{
  bool isLoading=false;
  String? error;
  List<DiaryEntry> entries =[];
  Future<void> fetchEntries(String classid,DateTime date) async{
    isLoading=true;
    error = null;
    notifyListeners();


    try {
      // --- Backend engineer: replace mock data with API call ---
      // final response = await http.get(Uri.parse('$baseUrl/classes/$classId/diary?date=${date.toIso8601String()}'));
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   entries = (data['data'] as List).map((e) => DiaryEntry.fromJson(e)).toList();
      // } else {
      //   throw Exception('Failed to load');
      //}
      await Future.delayed(const Duration(seconds: 1)); // simulate loading
      entries = [
        DiaryEntry(
          id: '1',
          dateTime: DateTime(date.year, date.month, date.day, 9, 0),
          title: 'Math: Algebra',
          details: 'Quadratic equations explained, homework Q1–10.',
          type: DiaryType.lesson,
          teacher: 'Mrs. Sharma',
        ),
        DiaryEntry(
          id: '2',
          dateTime: DateTime(date.year, date.month, date.day, 11, 0),
          title: 'Sports',
          details: 'Football practice and warm-ups.',
          type: DiaryType.sports,
          teacher: 'Mr. Singh',
        ),
      ];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();

    }

  }
}