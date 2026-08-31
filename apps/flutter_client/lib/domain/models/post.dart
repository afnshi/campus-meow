import 'user.dart';

class Post {
  const Post({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.tags,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, Object?> json) => Post(
    id: json['id']! as String,
    author: UserSummary.fromJson(json['author']! as Map<String, Object?>),
    title: json['title']! as String,
    content: json['content']! as String,
    imageUrls: (json['imageUrls']! as List<Object?>).cast<String>(),
    tags: (json['tags']! as List<Object?>).cast<String>(),
    createdAt: DateTime.parse(json['createdAt']! as String),
  );

  final String id;
  final UserSummary author;
  final String title;
  final String content;
  final List<String> imageUrls;
  final List<String> tags;
  final DateTime createdAt;
}
