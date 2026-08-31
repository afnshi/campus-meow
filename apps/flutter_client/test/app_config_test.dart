import 'package:campus_meow/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test('Android emulator uses the host loopback alias', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    expect(AppConfig.apiBaseUrl, 'http://10.0.2.2:8080/api/v1');
  });

  test('Windows client uses localhost', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;

    expect(AppConfig.apiBaseUrl, 'http://localhost:8080/api/v1');
  });
}
