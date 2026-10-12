import 'package:flutter/material.dart';

import '../app_theme.dart';

class AppSnackbar {
  AppSnackbar._();

  static SnackBar success(String message) {
    return _build(message, AppColors.success, Icons.check_circle_rounded);
  }

  static SnackBar error(String message) {
    return _build(message, AppColors.danger, Icons.error_outline_rounded);
  }

  static SnackBar info(String message) {
    return _build(message, AppColors.navy, Icons.info_outline_rounded);
  }

  static SnackBar _build(String message, Color color, IconData icon) {
    return SnackBar(
      content: Row(
        children: <Widget>[
          Icon(icon, color: Colors.white, size: 21),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
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
