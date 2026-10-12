import 'package:flutter/material.dart';

import '../app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    this.title = 'No favorites yet',
    this.message = 'Open a post and save it to build your personal reading collection.',
    this.onBrowse,
    super.key,
  });

  final String title;
  final String message;
  final VoidCallback? onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xlarge),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: AppColors.tealSoft,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.bookmarks_outlined,
                  size: 48,
                  color: AppColors.teal,
                ),
              ),
              const SizedBox(height: AppSpacing.xlarge),
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
              if (onBrowse != null) ...<Widget>[
                const SizedBox(height: AppSpacing.xlarge),
                FilledButton.icon(
                  onPressed: onBrowse,
                  icon: const Icon(Icons.auto_stories_rounded),
                  label: const Text('Browse posts'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
