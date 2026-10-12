import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../app_theme.dart';
import '../services/favorites_service.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/empty_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  Box<dynamic> get _box => FavoritesService.box;

  Future<bool> _confirmRemoval(Map<String, dynamic> post) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.delete_outline_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 26,
            ),
          ),
          title: const Text('Remove favorite?'),
          content: Text(
            '“${post['title']}” will be removed from your saved collection.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Keep post'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  Future<void> _deleteFromButton(Map<String, dynamic> post) async {
    final bool confirmed = await _confirmRemoval(post);
    if (!confirmed || !mounted) {
      return;
    }

    final int id = post['id'] as int;
    await _favoritesService.remove(id);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(AppSnackbar.info('Removed from favorites.'));
  }

  Future<void> _editNote(Map<String, dynamic> post) async {
    final int id = post['id'] as int;
    final String currentNote = post['note'] as String? ?? '';
    final TextEditingController controller =
        TextEditingController(text: currentNote);

    final String? updatedNote = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          icon: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.noteBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: AppColors.gold,
              size: 28,
            ),
          ),
          title: const Text('Personal note'),
          content: SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Add a short reminder for this saved post.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.large),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: 150,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Type your note here',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.sticky_note_2_outlined),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
              icon: const Icon(Icons.check_rounded, size: 18),
              label: const Text('Save note'),
            ),
          ],
        );
      },
    );
    controller.dispose();

    if (updatedNote == null || !mounted) {
      return;
    }

    await _favoritesService.updateNote(id, updatedNote);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(AppSnackbar.success('Note saved.'));
  }

  Widget _buildCollectionHeader(int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.large),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(color: AppColors.outline),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.tealSoft,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.bookmarks_rounded,
                color: AppColors.teal,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Your saved collection',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xsmall),
                  Text(
                    'Posts you want to keep close.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
                vertical: AppSpacing.small,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3F7),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                count.toString(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.navy,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> post) {
    final int id = post['id'] as int;
    final String title = post['title'] as String? ?? 'Untitled post';
    final String body = post['body'] as String? ?? '';
    final String note = post['note'] as String? ?? '';
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Dismissible(
        key: ValueKey<int>(id),
        direction: DismissDirection.endToStart,
        confirmDismiss: (DismissDirection direction) => _confirmRemoval(post),
        onDismissed: (DismissDirection direction) async {
          await _favoritesService.remove(id);
          if (!mounted) {
            return;
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(AppSnackbar.info('Removed from favorites.'));
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.xlarge),
          decoration: BoxDecoration(
            color: const Color(0xFFFBEAEC),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                'REMOVE',
                style: TextStyle(
                  color: AppColors.danger,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.7,
                ),
              ),
              SizedBox(width: AppSpacing.small),
              Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
                size: 24,
              ),
            ],
          ),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.article_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'SAVED POST  /  ${id.toString().padLeft(2, '0')}',
                            style: textTheme.labelSmall?.copyWith(
                              color: AppColors.teal,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.85,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            title,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xsmall),
                    IconButton.filledTonal(
                      tooltip: 'Edit note',
                      onPressed: () => _editNote(post),
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.tealSoft,
                        foregroundColor: AppColors.teal,
                      ),
                      icon: const Icon(Icons.edit_note_rounded, size: 21),
                    ),
                    const SizedBox(width: AppSpacing.xsmall),
                    IconButton.filledTonal(
                      tooltip: 'Delete favorite',
                      onPressed: () => _deleteFromButton(post),
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFFBEAEC),
                        foregroundColor: AppColors.danger,
                      ),
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.large),
                Text(
                  body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.large),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  decoration: BoxDecoration(
                    color: AppColors.noteBackground,
                    borderRadius: BorderRadius.circular(AppRadius.button),
                    border: Border.all(color: AppColors.noteBorder),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.sticky_note_2_outlined,
                        color: AppColors.gold,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'PERSONAL NOTE',
                              style: textTheme.labelSmall?.copyWith(
                                color: const Color(0xFF8C6A2D),
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xsmall),
                            Text(
                              note.isEmpty ? 'Add a personal note...' : note,
                              style: textTheme.bodyMedium?.copyWith(
                                color: note.isEmpty
                                    ? const Color(0xFF927F60)
                                    : AppColors.textPrimary,
                                fontStyle: note.isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Box<dynamic> box = _box;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to posts',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Favorites'),
            ValueListenableBuilder<Box<dynamic>>(
              valueListenable: box.listenable(),
              builder: (BuildContext context, Box<dynamic> listenableBox, Widget? child) {
                final int count = listenableBox.length;
                return Text(
                  '$count ${count == 1 ? 'saved post' : 'saved posts'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                );
              },
            ),
          ],
        ),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.large),
            child: Icon(Icons.bookmarks_rounded, color: AppColors.teal),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: box.listenable(),
        builder: (BuildContext context, Box<dynamic> listenableBox, Widget? child) {
          final List<Map<String, dynamic>> favorites = listenableBox.values
              .whereType<Map>()
              .map(
                (dynamic value) => Map<String, dynamic>.from(value as Map),
              )
              .toList(growable: false);

          if (favorites.isEmpty) {
            return EmptyState(onBrowse: () => Navigator.pop(context));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.small,
              AppSpacing.large,
              AppSpacing.xlarge,
            ),
            itemCount: favorites.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _buildCollectionHeader(favorites.length);
              }
              return _buildFavoriteCard(favorites[index - 1]);
            },
          );
        },
      ),
    );
  }
}
