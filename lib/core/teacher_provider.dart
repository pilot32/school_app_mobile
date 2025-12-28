import 'package:flutter/foundation.dart';
import '../../data/models/teacher.dart';

class TeacherProvider extends ChangeNotifier {
  Teacher? _teacher;
  Teacher? get teacher => _teacher;

  TeacherProvider() {
    // TODO: Replace with real teacher data from API
    _teacher = Teacher(
      id: 'teacher_001',
      name: 'Mr. Arjun Mehta',
      email: 'arjun.mehta@greenwood.edu',
      phone: '+91-98765 43210',
      department: 'Mathematics',
      subjects: ['Mathematics', 'Statistics'],
      classes: ['Class 10-A', 'Class 11-B', 'Class 9-C'],
      profileImageUrl: null,
    );
  }

  void setTeacher(Teacher teacher) {
    _teacher = teacher;
    notifyListeners();
  }

  void clear() {
    _teacher = null;
    notifyListeners();
  }

  void updateTeacherProfile({
    String? name,
    String? email,
    String? phone,
    String? department,
    List<String>? subjects,
    List<String>? classes,
  }) {
    if (_teacher != null) {
      _teacher = Teacher(
        id: _teacher!.id,
        name: name ?? _teacher!.name,
        email: email ?? _teacher!.email,
        phone: phone ?? _teacher!.phone,
        department: department ?? _teacher!.department,
        subjects: subjects ?? _teacher!.subjects,
        classes: classes ?? _teacher!.classes,
        profileImageUrl: _teacher!.profileImageUrl,
      );
      notifyListeners();
    }
  }
}
