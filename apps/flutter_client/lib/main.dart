import 'package:flutter/material.dart';

import 'app.dart';
import 'config/app_config.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/forum_repository.dart';
import 'data/repositories/user_repository.dart';
import 'data/services/api_client.dart';
import 'data/services/token_storage.dart';
import 'ui/app_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(
    baseUrl: AppConfig.apiBaseUrl,
    tokens: tokenStorage,
  );
  runApp(
    CampusMeowApp(
      viewModel: AppViewModel(
        authRepository: AuthRepository(apiClient, tokenStorage),
        userRepository: UserRepository(apiClient),
        forumRepository: ForumRepository(apiClient),
      ),
    ),
  );
}
