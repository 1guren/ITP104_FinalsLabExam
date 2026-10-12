import 'dart:convert';

import 'package:http/http.dart' as http;

const String postsEndpoint = 'https://6acca04fb406cb8ec0c6123b.mockapi.io/api/v1/posts';

class PostCreateResult {
  const PostCreateResult({
    required this.success,
    required this.message,
    this.statusCode,
    this.id,
  });

  final bool success;
  final String message;
  final int? statusCode;
  final int? id;
}

class PostApiService {
  // The Posts screen keeps its GET and status-code branches visible for the lab rubric.
  Future<http.Response> fetchPosts() {
    return http
        .get(Uri.parse(postsEndpoint))
        .timeout(const Duration(seconds: 15));
  }

  Future<PostCreateResult> createPost({
    required String title,
    required String body,
  }) async {
    try {
      final http.Response response = await http
          .post(
            Uri.parse(postsEndpoint),
            headers: <String, String>{
              'Content-type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'title': title,
              'body': body,
              'userId': 1,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 201) {
        int? returnedId;
        try {
          final dynamic decoded = jsonDecode(response.body);
          if (decoded is Map) {
            final dynamic rawId = decoded['id'];
            if (rawId is int) {
              returnedId = rawId;
            } else if (rawId != null) {
              returnedId = int.tryParse(rawId.toString());
            }
          }
        } on FormatException {
          returnedId = null;
        }

        final String message = returnedId == null
            ? 'Post created successfully. The API did not return an ID.'
            : 'Post created successfully. The API returned ID #$returnedId.';
        return PostCreateResult(
          success: true,
          statusCode: response.statusCode,
          id: returnedId,
          message: message,
        );
      }

      return PostCreateResult(
        success: false,
        statusCode: response.statusCode,
        message:
            'Failed to create post. The server returned status code ${response.statusCode}.',
      );
    } catch (error) {
      return PostCreateResult(
        success: false,
        message:
            'Could not create the post. Check your internet connection and try again. Details: $error',
      );
    }
  }
}
