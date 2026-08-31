import '../../domain/models/user.dart';
import '../services/api_client.dart';
import '../services/token_storage.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokens);
  final ApiClient _api;
  final TokenStorage _tokens;

  Future<User> login(String username, String password) => _authenticate(
    '/auth/login',
    {'username': username, 'password': password},
  );

  Future<User> register(String username, String password, String nickname) =>
      _authenticate('/auth/register', {
        'username': username,
        'password': password,
        'nickname': nickname,
      });

  Future<void> logout() => _tokens.clear();

  Future<User> _authenticate(String path, Map<String, Object?> body) async {
    final envelope = await _api.post(path, body: body);
    final data = envelope['data']! as Map<String, Object?>;
    await _tokens.write(data['accessToken']! as String);
    return User.fromJson(data['user']! as Map<String, Object?>);
  }
}
