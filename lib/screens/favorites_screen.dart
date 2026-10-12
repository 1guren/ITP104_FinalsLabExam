import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
          title: const Text('Remove favorite?'),
          content: Text(
            'Remove "${post['title']}" from your favorites?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
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
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackbar.info('Removed from favorites.'),
    );
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
          title: const Text('Personal note'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 150,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Add a note about this post',
              alignLabelWithHint: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
              child: const Text('Save note'),
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
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackbar.success('Note saved.'),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> post) {
    final int id = post['id'] as int;
    final String title = post['title'] as String? ?? 'Untitled post';
    final String body = post['body'] as String? ?? '';
    final String note = post['note'] as String? ?? '';
    final ColorScheme scheme = Theme.of(context).colorScheme;

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
          ScaffoldMessenger.of(context).showSnackBar(
            AppSnackbar.info('Removed from favorites.'),
          );
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: AppSpacing.xlarge),
          decoration: BoxDecoration(
            color: scheme.errorContainer,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: scheme.onErrorContainer,
            size: 28,
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
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.small),
                    IconButton(
                      tooltip: 'Edit note',
                      onPressed: () => _editNote(post),
                      icon: const Icon(Icons.edit_outlined),
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      tooltip: 'Delete favorite',
                      onPressed: () => _deleteFromButton(post),
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: scheme.error,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  body,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.large),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.medium),
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: 0.48),
                    borderRadius: BorderRadius.circular(AppRadius.button),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.sticky_note_2_outlined,
                        color: scheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: Text(
                          note.isEmpty ? 'Add a personal note...' : note,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: note.isEmpty
                                    ? scheme.onSurfaceVariant
                                    : scheme.onSurface,
                                fontStyle: note.isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
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
        toolbarHeight: 72,
        leading: IconButton(
          tooltip: 'Back',
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
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                );
              },
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<Box<dynamic>>(
        valueListenable: box.listenable(),
        builder: (BuildContext context, Box<dynamic> listenableBox, Widget? child) {
          // Hive returns dynamic maps, so normalize each saved value before reading it.
          final List<Map<String, dynamic>> favorites = listenableBox.values
              .whereType<Map>()
              .map(
                (dynamic value) => Map<String, dynamic>.from(value as Map),
              )
              .toList(growable: false);

          if (favorites.isEmpty) {
            return const EmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.large),
            itemCount: favorites.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildFavoriteCard(favorites[index]);
            },
          );
        },
      ),
    );
  }
}
