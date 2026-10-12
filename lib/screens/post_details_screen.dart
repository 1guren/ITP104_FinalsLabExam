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

    ScaffoldMessenger.of(context).showSnackBar(
      added
          ? AppSnackbar.success('Added to favorites.')
          : AppSnackbar.info('Already in favorites. Your note was kept.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Keep the route argument cast visible, and handle bad arguments gracefully.
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
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xlarge),
            child: Text(
              'This post could not be opened. Return to the posts list and select a post again.',
              textAlign: TextAlign.center,
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xlarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'POST #$id',
                    style: TextStyle(
                      color: scheme.onPrimaryContainer,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.7,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xlarge),
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const Divider(),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.large,
            AppSpacing.small,
            AppSpacing.large,
            AppSpacing.large,
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
                            ),
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            'Already in favorites. Your saved note was kept.',
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
    );
  }
}
