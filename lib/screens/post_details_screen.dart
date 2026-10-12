import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../app_theme.dart';
import '../services/favorites_service.dart';
import '../widgets/app_snackbar.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({super.key});

  Future<void> _savePost(
    BuildContext context, {
    required int id,
    required String title,
    required String body,
  }) async {
    final bool added = await FavoritesService().add(
      id: id,
      title: title,
      body: body,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        added
            ? AppSnackbar.success('Added to favorites.')
            : AppSnackbar.info('Already in favorites. Your note was kept.'),
      );
  }

  @override
  Widget build(BuildContext context) {
    final Object? routeArguments =
        ModalRoute.of(context)!.settings.arguments;
    Map<String, dynamic>? post;
    try {
      post = routeArguments as Map<String, dynamic>?;
    } on TypeError {
      post = null;
    }

    if (post == null ||
        post['id'] is! int ||
        post['title'] is! String ||
        post['body'] is! String) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Text('Post Details'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xlarge),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: AppColors.tealSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.article_outlined,
                    color: AppColors.teal,
                    size: 34,
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                Text(
                  'Post unavailable',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  'Return to the posts list and select a post to read its details.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.large),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to posts'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final int id = post['id'] as int;
    final String title = post['title'] as String;
    final String body = post['body'] as String;
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Post Details'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.large),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.tealSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.article_rounded,
                size: 20,
                color: AppColors.teal,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.large,
          AppSpacing.small,
          AppSpacing.large,
          AppSpacing.xlarge,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xlarge),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.medium,
                          vertical: AppSpacing.small,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.14),
                          ),
                        ),
                        child: Text(
                          'POST  #${id.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.9,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.auto_stories_rounded,
                        size: 26,
                        color: Color(0xFFE4C17A),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xlarge),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          height: 1.2,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  Text(
                    'POST READER  /  ARTICLE VIEW',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          letterSpacing: 1.05,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xlarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.tealSoft,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.subject_rounded,
                            color: AppColors.teal,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.medium),
                        Text(
                          'Article',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Text(
                      body,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.large),
                    Divider(color: scheme.outlineVariant),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.bookmark_border_rounded,
                          size: 18,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: Text(
                            'Save this post to find it quickly later.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.outline)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.medium,
              AppSpacing.large,
              AppSpacing.medium,
            ),
            child: ValueListenableBuilder<Box<dynamic>>(
              valueListenable:
                  Hive.box<dynamic>('favoritesBox').listenable(keys: <dynamic>[id]),
              builder: (BuildContext context, Box<dynamic> box, Widget? child) {
                final bool isSaved = box.containsKey(id);
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: isSaved
                      ? Column(
                          key: const ValueKey<String>('saved'),
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.tonalIcon(
                                onPressed: null,
                                icon: const Icon(Icons.favorite_rounded),
                                label: const Text('Saved to Favorites'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.tealSoft,
                                  disabledBackgroundColor: AppColors.tealSoft,
                                  disabledForegroundColor: AppColors.teal,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.small),
                            Text(
                              'Already saved. Your personal note is safe.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        )
                      : SizedBox(
                          key: const ValueKey<String>('save'),
                          width: double.infinity,
                          child: FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.teal,
                            ),
                            onPressed: () => _savePost(
                              context,
                              id: id,
                              title: title,
                              body: body,
                            ),
                            icon: const Icon(Icons.favorite_border_rounded),
                            label: const Text('Save to Favorites'),
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
