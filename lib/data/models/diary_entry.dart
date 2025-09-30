enum DiaryType { lesson, homework, sports, notice, other }

class DiaryEntry {
  final String id;
  final DateTime dateTime;
  final String title;
  final String details;
  final DiaryType type;
  final String teacher;

  DiaryEntry({
    required this.id,
    required this.dateTime,
    required this.title,
    required this.details,
    required this.type,
    required this.teacher,
  });

//backend engineer: parse from api
// factory DiaryEntry.fromJson(Map<String, dynamic> json) {
//   return DiaryEntry(
//     id: json['id'],
//     dateTime: DateTime.parse(json['datetime']),
//     title: json['title'],
//     details: json['details'],
//     type: _mapType(json['type']),
//     teacher: json['teacher']['name'],
//   );
// }
//
// static DiaryType _mapType(String t) {
//   switch (t) {
//     case 'lesson': return DiaryType.lesson;
//     case 'homework': return DiaryType.homework;
//     case 'sports': return DiaryType.sports;
//     case 'notice': return DiaryType.notice;
//     default: return DiaryType.other;
//   }
// }
}
