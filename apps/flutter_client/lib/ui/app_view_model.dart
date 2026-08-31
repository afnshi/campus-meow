import 'package:flutter/foundation.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/forum_repository.dart';
import '../data/repositories/user_repository.dart';
import '../domain/models/post.dart';
import '../domain/models/user.dart';

class AppViewModel extends ChangeNotifier {
  AppViewModel({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required ForumRepository forumRepository,
  }) : _auth = authRepository,
       _users = userRepository,
       _forum = forumRepository;

  final AuthRepository _auth;
  final UserRepository _users;
  final ForumRepository _forum;

  User? user;
  List<Post> posts = const [];
  bool loading = false;
  String? error;

  bool get authenticated => user != null;

  Future<void> login(String username, String password) => _run(
    () async => user = await _auth.login(username, password),
    refresh: true,
  );

  Future<void> register(String username, String password, String nickname) =>
      _run(
        () async => user = await _auth.register(username, password, nickname),
        refresh: true,
      );

  Future<void> loadPosts() => _run(() async => posts = await _forum.list());

  Future<void> createPost(String title, String content) => _run(() async {
    await _forum.create(title: title, content: content);
    posts = await _forum.list();
  });

  Future<void> updateProfile(
    String nickname,
    String school,
    String className,
    String bio,
  ) => _run(() async {
    user = await _users.update(
      nickname: nickname,
      school: school,
      className: className,
      bio: bio,
    );
  });

  Future<void> logout() async {
    await _auth.logout();
    user = null;
    posts = const [];
    notifyListeners();
  }

  Future<void> _run(
    Future<void> Function() operation, {
    bool refresh = false,
  }) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await operation();
      if (refresh) posts = await _forum.list();
    } on Object catch (exception) {
      error = exception.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
