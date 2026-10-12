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
    final int id = int.tryParse(post['id']?.toString() ?? '') ?? 0;
    final String title = _capitalizedTitle(post['title']?.toString() ?? '');
    final String body = post['body']?.toString() ?? '';
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.medium,
        ),
        minVerticalPadding: AppSpacing.medium,
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            id.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'POST  /  ${id.toString().padLeft(2, '0')}',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.teal,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(height: 1.3),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.small),
          child: Text(
            body,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
        ),
        trailing: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.tealSoft,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.teal,
            size: 18,
          ),
        ),
      ),
    );
  }
}
