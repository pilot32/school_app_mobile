// TODO Implement this library.
import 'package:flutter/foundation.dart';
import '../../data/models/student.dart';

class StudentProvider extends ChangeNotifier {
  Student? _student;
  Student? get student => _student;
  StudentProvider() {
    // 👇 TEMPORARY: preload a dummy logged-in student for testing
    _student = Student(
      name: 'Test User',
      studentClass: 'Class 10-A',
      rollNo: '0001',
    );
  }
  //the red color shows its a temporary code from the start to end
  void setStudent(Student s) {
    _student = s;
    notifyListeners();
  }

  void clear() {
    _student = null;
    notifyListeners();
  }
}
