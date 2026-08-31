import '../../domain/models/user.dart';
import '../services/api_client.dart';

class UserRepository {
  UserRepository(this._api);
  final ApiClient _api;

  Future<User> me() async {
    final envelope = await _api.get('/users/me');
    return User.fromJson(envelope['data']! as Map<String, Object?>);
  }

  Future<User> update({
    required String nickname,
    String? school,
    String? className,
    String? bio,
  }) async {
    final envelope = await _api.put(
      '/users/me',
      body: {
        'nickname': nickname,
        'school': school,
        'className': className,
        'bio': bio,
      },
    );
    return User.fromJson(envelope['data']! as Map<String, Object?>);
  }
}
