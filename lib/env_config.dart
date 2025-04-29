import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static late final String expertModePassword;

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");

    final password = dotenv.env['EXPERT_MODE_PASSWORD'];
    if (password == null || password.isEmpty) {
      throw AssertionError('EXPERT_MODE_PASSWORD is not set in .env file');
    }
    expertModePassword = password;
  }
}
