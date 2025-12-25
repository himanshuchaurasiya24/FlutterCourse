import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'home_screen.dart';

void main() {
  runApp(
    // ProviderScope is required for Riverpod to work
    // It stores the state of all providers
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Pro Course',
      debugShowCheckedModeBanner: false,

      // Use custom theme from AppTheme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Start with HomeScreen
      home: const HomeScreen(),
    );
  }
}
