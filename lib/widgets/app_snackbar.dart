import 'package:flutter/material.dart';

import '../app_theme.dart';

class AppSnackbar {
  AppSnackbar._();

  static SnackBar success(String message) {
    return _build(message, const Color(0xFF237A4B), Icons.check_circle_outline);
  }

  static SnackBar error(String message) {
    return _build(message, const Color(0xFFB3261E), Icons.error_outline);
  }

  static SnackBar info(String message) {
    return _build(message, const Color(0xFF394A8A), Icons.info_outline);
  }

  static SnackBar _build(String message, Color color, IconData icon) {
    return SnackBar(
      content: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white),
          const SizedBox(width: AppSpacing.medium),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(AppSpacing.large),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
    );
  }
}
