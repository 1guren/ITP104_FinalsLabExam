import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../services/post_api_service.dart';

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);
    final PostCreateResult result = await PostApiService().createPost(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );

    if (!mounted) {
      return;
    }
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.tealSoft,
          borderRadius: BorderRadius.circular(17),
        ),
        child: const Icon(
          Icons.post_add_rounded,
          color: AppColors.teal,
          size: 29,
        ),
      ),
      title: const Text('Create a post'),
      content: SizedBox(
        width: 390,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Share an idea with a clear title and a short message.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xlarge),
                TextFormField(
                  controller: _titleController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLength: 120,
                  decoration: const InputDecoration(
                    labelText: 'Post title',
                    hintText: 'Enter a descriptive title',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.medium),
                TextFormField(
                  controller: _bodyController,
                  textCapitalization: TextCapitalization.sentences,
                  minLines: 3,
                  maxLines: 5,
                  maxLength: 1000,
                  decoration: const InputDecoration(
                    labelText: 'Post content',
                    hintText: 'Write your message',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the post content.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.small),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 17,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Expanded(
                      child: Text(
                        'Your submission result will appear after the server responds.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: _isSubmitting ? null : _submit,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.send_rounded, size: 18),
          label: Text(_isSubmitting ? 'Submitting' : 'Submit post'),
        ),
      ],
    );
  }
}
