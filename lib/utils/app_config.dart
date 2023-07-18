import 'package:flutter/cupertino.dart';
import 'package:insta_story/utils/sp_util.dart';

class AppConfig {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await SPUtil.init();
  }
}
