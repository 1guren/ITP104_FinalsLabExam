# Post Reader & Favorites

Flutter 3.29.3 / Dart 3.7.2 lab project. The app uses Material 3, JSONPlaceholder, and Hive local storage.

## Run the app

1. Install Flutter 3.29.3 or a compatible Flutter SDK and Android Studio.
2. Open this folder in your IDE or terminal.
3. Run `flutter pub get`.
4. Start an Android emulator or connect an Android device with internet access.
5. Run `flutter run`.

The Android INTERNET permission is already present in `android/app/src/main/AndroidManifest.xml`.

## Features

- Three named routes: `/`, `/details`, and `/favorites`.
- Fetch posts from JSONPlaceholder with loading, error, retry, and pull-to-refresh states.
- Submit a post with title/body validation and an on-screen result message.
- Save posts to Hive, edit their personal notes, and remove favorites with confirmation or swipe.
- Hive favorites persist after a full app restart.
- A shared Material 3 theme and reusable widgets are defined under `lib/`.

JSONPlaceholder simulates new-post creation. A successful POST returns a demo ID, but the new post is not added to the GET list.

## Requirement traceability

| Requirement | Implementation |
| --- | --- |
| 1.1 | `lib/main.dart`, `initialRoute` and the three-entry `routes` map |
| 1.2 | `lib/screens/posts_screen.dart`, `_openPostDetails()` and named navigation; both other screens use `Navigator.pop()` |
| 1.3 | `lib/screens/posts_screen.dart`, AppBar favorites action |
| 1.4 | `lib/screens/posts_screen.dart`, `_openPostDetails()` passes `id`, `title`, and `body` |
| 1.5 | `lib/screens/post_details_screen.dart`, `ModalRoute.of(context)!.settings.arguments` cast and validation |
| 1.6 | `lib/screens/post_details_screen.dart` and `lib/screens/favorites_screen.dart`, explicit back controls and system back support |
| 2.1 | `lib/screens/posts_screen.dart` and `lib/services/post_api_service.dart`, `http` package |
| 2.2 | `lib/screens/posts_screen.dart`, `initState()` calls `_fetchPosts()`, which calls `http.get()` with a timeout |
| 2.3 | `lib/screens/posts_screen.dart`, status 200 branch, `jsonDecode()`, `ListView.builder`; `lib/widgets/post_card.dart`, `ListTile` |
| 2.4 | `lib/screens/posts_screen.dart`, status and exception branches; `lib/widgets/error_view.dart`, visible error and Retry |
| 2.5 | `lib/screens/posts_screen.dart`, New Post FAB; `lib/widgets/create_post_dialog.dart`, Form, validators, and submit loading state |
| 2.6 | `lib/services/post_api_service.dart`, `http.post()`, required headers, `jsonEncode()`, and timeout |
| 2.7 | `lib/services/post_api_service.dart`, 201 check and returned API ID; `lib/widgets/app_snackbar.dart`, green/red result messages |
| 3.1 | `lib/main.dart`, async Hive initialization and `favoritesBox` opening before `runApp()` |
| 3.2 | `lib/screens/post_details_screen.dart`, Save button; `lib/services/favorites_service.dart`, duplicate guard and `put(id, map)` with the note field |
| 3.3 | `lib/screens/favorites_screen.dart`, `ValueListenableBuilder`, `box.listenable()`, and `box.values`; `lib/widgets/empty_state.dart` |
| 3.4 | `lib/screens/favorites_screen.dart`, `_editNote()`; `lib/services/favorites_service.dart`, `updateNote()` |
| 3.5 | `lib/screens/favorites_screen.dart`, confirmed delete button and `Dismissible`; `lib/services/favorites_service.dart`, `box.delete()` |
| 3.6 | `lib/main.dart` and `lib/services/favorites_service.dart`, persistent Hive box without clearing data |
| 3.7 | `lib/services/favorites_service.dart` and `lib/screens/favorites_screen.dart`, safe `Map<String, dynamic>.from()` conversion |
| A.1 | `lib/app_theme.dart`, shared Material 3 `ThemeData`, component themes, spacing, and radius constants |
| A.2 | Separate screen, service, and reusable widget files under `lib/` |
| A.3 | Loading, error, POST result, favorite, note, and delete feedback in the app UI |

## Demo and recording checklist

1. Launch the app and show the posts list.
2. Open a post and show its title, ID, and body on the details screen.
3. Tap New Post, submit valid title/body values, and show the success message with the API ID. You can also try empty fields to show inline validation.
4. Save a post to favorites and show the Saved to Favorites state.
5. Open Favorites and add or edit a personal note.
6. Delete a favorite using the trash icon and confirm the dialog. Optionally demonstrate swipe-to-delete.
7. Save another favorite, fully close the app, reopen it, and show that the favorite and note remain.
8. Capture the screenshots or screen recording required by the instructor.
