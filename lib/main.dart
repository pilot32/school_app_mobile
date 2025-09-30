import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_app_mvp/features/core/diary_provider.dart';
import 'app.dart';
import 'features/core/student_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> DiaryProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
