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
      final http.Response response = await http
          .get(Uri.parse(postsEndpoint))
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
    final int id = int.tryParse(post['id']?.toString() ?? '') ?? 0;
    Navigator.pushNamed(
      context,
      AppRoutes.details,
      arguments: <String, dynamic>{
        'id': id,
        'title': post['title']?.toString() ?? 'Untitled post',
        'body': post['body']?.toString() ?? '',
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(height: AppSpacing.large),
          Text(
            'Loading your reading feed',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsContent() {
    if (_isLoading) {
      return _buildLoading();
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
          112,
        ),
        itemCount: _posts.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return _buildHero(context);
          }
          if (index == 1) {
            return Padding(
              padding: const EdgeInsets.only(
                top: AppSpacing.xlarge,
                bottom: AppSpacing.medium,
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    'RECENT POSTS',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.1,
                        ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                      vertical: AppSpacing.xsmall,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tealSoft,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: AppColors.teal,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Text(
                          '${_posts.length} POSTS',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.teal,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final Map<String, dynamic> post = _posts[index - 2];
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

  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xlarge),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppColors.navy, AppColors.navyDeep],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.13),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -10,
            top: -18,
            child: Icon(
              Icons.auto_stories_rounded,
              size: 128,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.13),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.menu_book_rounded, color: Color(0xFFE4C17A), size: 16),
                    SizedBox(width: AppSpacing.small),
                    Text(
                      'YOUR READING SPACE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.large),
              Text(
                'Ideas worth\ncoming back to.',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 29,
                      height: 1.12,
                      letterSpacing: -0.7,
                    ),
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                'Explore the latest posts and save the ones that matter to you.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                      height: 1.55,
                    ),
              ),
              const SizedBox(height: AppSpacing.large),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.verified_outlined,
                    color: Color(0xFFE4C17A),
                    size: 17,
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    'A focused space for reading',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: AppSpacing.medium),
            const Text('Posts'),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.small),
            child: IconButton.filledTonal(
              tooltip: 'View favorites',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.tealSoft,
                foregroundColor: AppColors.teal,
              ),
              icon: const Icon(Icons.favorite_rounded),
            ),
          ),
        ],
      ),
      body: _buildPostsContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreatePostDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Post'),
      ),
    );
  }
}
