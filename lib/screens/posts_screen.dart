import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../app_theme.dart';
import '../routes.dart';
import '../services/post_api_service.dart';
import '../widgets/app_snackbar.dart';
import '../widgets/create_post_dialog.dart';
import '../widgets/error_view.dart';
import '../widgets/post_card.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Map<String, dynamic>> _posts = <Map<String, dynamic>>[];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final http.Response response =
          await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'))
              .timeout(const Duration(seconds: 15));

      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body) as List<dynamic>;
        final List<Map<String, dynamic>> loadedPosts = decoded
            .map(
              (dynamic item) => Map<String, dynamic>.from(item as Map),
            )
            .toList(growable: false);

        setState(() {
          _posts = loadedPosts;
          _isLoading = false;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'The server returned status code ${response.statusCode}. Please try again.';
        });
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage =
            'Check your internet connection and retry. Details: $error';
      });
    }
  }

  Future<void> _openCreatePostDialog() async {
    final PostCreateResult? result = await showDialog<PostCreateResult>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => const CreatePostDialog(),
    );

    if (!mounted || result == null) {
      return;
    }

    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        result.success
            ? AppSnackbar.success(result.message)
            : AppSnackbar.error(result.message),
      );
  }

  void _openPostDetails(Map<String, dynamic> post) {
    Navigator.pushNamed(
      context,
      AppRoutes.details,
      arguments: <String, dynamic>{
        'id': post['id'],
        'title': post['title'],
        'body': post['body'],
      },
    );
  }

  Widget _buildPostsContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.large),
            Text('Loading posts...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return ErrorView(message: _errorMessage!, onRetry: _fetchPosts);
    }

    return RefreshIndicator(
      onRefresh: _fetchPosts,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.large,
          AppSpacing.small,
          AppSpacing.large,
          104,
        ),
        itemCount: _posts.length,
        itemBuilder: (BuildContext context, int index) {
          final Map<String, dynamic> post = _posts[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.medium),
            child: PostCard(
              post: post,
              onTap: () => _openPostDetails(post),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: <Widget>[
          IconButton(
            tooltip: 'View favorites',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          const SizedBox(width: AppSpacing.small),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.large,
              AppSpacing.large,
              AppSpacing.large,
              AppSpacing.small,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'LATEST POSTS',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        letterSpacing: 1.2,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: AppSpacing.xsmall),
                Text(
                  'Read something interesting.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xsmall),
                Text(
                  'Open a post to see the full story or save it for later.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(child: _buildPostsContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePostDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Post'),
      ),
    );
  }
}
