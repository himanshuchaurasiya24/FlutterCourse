import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // App Info
  static const String appName = 'Task Manager';
  static const String appVersion = '1.0.0';

  // Hive Box Names
  static const String taskBoxName = 'tasks';

  // Limits
  static const int maxUndoHistorySize = 50;
  static const int maxTaskTitleLength = 100;
  static const int maxTaskDescriptionLength = 500;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}

/// Color constants
class AppColors {
  AppColors._();

  // Priority Colors
  static const Color highPriority = Colors.red;
  static const Color mediumPriority = Colors.orange;
  static const Color lowPriority = Colors.green;

  // Status Colors
  static const Color overdue = Colors.red;
  static const Color dueToday = Colors.orange;
  static const Color upcoming = Colors.grey;

  // Theme Colors
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
}
