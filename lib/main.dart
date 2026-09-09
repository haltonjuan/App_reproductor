import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/library_screen.dart';

void main() {
  runApp(const LeekApp());
}

class LeekApp extends StatelessWidget {
  const LeekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leek',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const LibraryScreen(),
    );
  }
}
