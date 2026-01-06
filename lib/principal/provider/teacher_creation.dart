import 'package:flutter_riverpod/legacy.dart';
import 'package:school_app_mvp/principal/apiService/teacher_creation.dart';
import 'package:school_app_mvp/principal/models/teacher_creation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class TeacherState {
  final bool isLoading;
  final String? error;

  const TeacherState({
    this.isLoading = false,
    this.error,
  });
}
final teacherProvider =
StateNotifierProvider<TeacherNotifier, TeacherState>(
      (ref) => TeacherNotifier(TeacherApiService()),
);

class TeacherNotifier extends StateNotifier<TeacherState> {
  TeacherNotifier(this._api) : super(const TeacherState());

  final TeacherApiService _api;

  Future<void> createTeacher(CreateTeacherRequest request) async {
    state = TeacherState(isLoading: true);

    try {
      await _api.createTeacher(request);
      state = const TeacherState();
    } catch (e) {
      state = TeacherState(error: e.toString());
    }
  }
}


