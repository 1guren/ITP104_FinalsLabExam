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
      title: const Text('Create a post'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 120,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Give your post a title',
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
                  labelText: 'Body',
                  hintText: 'Write something to share',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a body.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Submit'),
        ),
      ],
    );
  }
}
