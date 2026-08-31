import '../../domain/models/post.dart';
import '../services/api_client.dart';

class ForumRepository {
  ForumRepository(this._api);
  final ApiClient _api;

  Future<List<Post>> list({int page = 0}) async {
    final envelope = await _api.get('/posts?page=$page&size=20');
    final data = envelope['data']! as Map<String, Object?>;
    return (data['items']! as List<Object?>)
        .map((item) => Post.fromJson(item! as Map<String, Object?>))
        .toList(growable: false);
  }

  Future<Post> create({required String title, required String content}) async {
    final envelope = await _api.post(
      '/posts',
      body: {
        'title': title,
        'content': content,
        'imageUrls': <String>[],
        'tags': <String>[],
      },
    );
    return Post.fromJson(envelope['data']! as Map<String, Object?>);
  }
}
