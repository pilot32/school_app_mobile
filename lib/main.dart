import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:school_app_mvp/features/core/diary_provider.dart';
import 'app.dart';
import 'features/core/student_provider.dart';

void main() {
  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (_)=> DiaryProvider()),
          provider.ChangeNotifierProvider(create: (_) => StudentProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
