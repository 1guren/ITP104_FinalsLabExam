import 'package:flutter/material.dart';

import '../app_theme.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xlarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 370),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEAEC),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 38,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(height: AppSpacing.xlarge),
              Text(
                'We could not load the posts',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xlarge),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
