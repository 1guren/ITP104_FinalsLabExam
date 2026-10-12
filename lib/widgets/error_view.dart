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
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xlarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: scheme.errorContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 36,
                  color: scheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
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
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
