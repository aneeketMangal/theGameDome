import 'package:flutter/foundation.dart';

class Post {
  final String user;
  final String body;
  final bool isImage;
  Post({@required this.user, @required this.body, this.isImage});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      user: json['user'] as String,
      body: json['text'] as String,
      isImage: false,
    );
  }
}
