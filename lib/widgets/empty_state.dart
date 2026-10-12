import 'package:flutter/material.dart';

import '../app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    this.title = 'No favorites yet',
    this.message = 'Open a post and tap Save to Favorites to keep it here.',
    super.key,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xlarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_border_rounded,
                  size: 44,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
