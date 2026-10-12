import 'package:flutter/material.dart';

import '../app_theme.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    required this.post,
    required this.onTap,
    super.key,
  });

  final Map<String, dynamic> post;
  final VoidCallback onTap;

  String _capitalizedTitle(String value) {
    final String title = value.trim();
    if (title.isEmpty) {
      return 'Untitled post';
    }
    return '${title.substring(0, 1).toUpperCase()}${title.substring(1)}';
  }

  @override
  Widget build(BuildContext context) {
    // Works with int ids (JSONPlaceholder) and String ids (MockAPI).
    final int id = int.tryParse(post['id']?.toString() ?? '') ?? 0;
    final String title = _capitalizedTitle(post['title']?.toString() ?? '');
    final String body = post['body']?.toString() ?? '';
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.medium,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          child: Text(
            id.toString(),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.small),
          child: Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: scheme.primary,
          size: 28,
        ),
      ),
    );
  }
}