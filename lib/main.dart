import 'package:flutter/material.dart';
import 'package:magic_suspense/core/theme.dart';
import 'package:magic_suspense/features/home/home_screen.dart';

void main() {
  runApp(const MagicSuspenseApp());
}

class MagicSuspenseApp extends StatelessWidget {
  const MagicSuspenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Suspense',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
