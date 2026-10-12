import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app_theme.dart';
import 'routes.dart';
import 'screens/favorites_screen.dart';
import 'screens/post_details_screen.dart';
import 'screens/posts_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');
  runApp(const PostReaderApp());
}

class PostReaderApp extends StatelessWidget {
  const PostReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Reader & Favorites',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.posts,
      routes: <String, WidgetBuilder>{
        AppRoutes.posts: (context) => const PostsScreen(),
        AppRoutes.details: (context) => const PostDetailsScreen(),
        AppRoutes.favorites: (context) => const FavoritesScreen(),
      },
    );
  }
}
