import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF003399);
  static const accent = Color(0xFFFF5722);
  static const background = Colors.white;
  static const cardBackground = Color(0xFFF5F5F5);
  static const textColor = Colors.black;
  static const subtitleTextColor = Colors.blueAccent;
}

class AppTextStyles {
  static const title = TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary);
  static const body = TextStyle(fontSize: 14, color: AppColors.textColor);
  static const subtitle = TextStyle(fontSize: 16, color: AppColors.subtitleTextColor, fontWeight: FontWeight.w500);
  static const price = TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold);
}
