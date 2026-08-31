import 'package:campus_meow/domain/models/post.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('post parses API response', () {
    final post = Post.fromJson({
      'id': 'abc',
      'author': {'id': 1, 'nickname': 'Meow', 'school': 'Campus'},
      'title': 'Hello',
      'content': 'World',
      'imageUrls': <String>[],
      'tags': <String>['campus'],
      'createdAt': '2026-08-28T00:00:00Z',
    });
    expect(post.title, 'Hello');
    expect(post.author.nickname, 'Meow');
  });
}
