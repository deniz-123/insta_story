import 'package:insta_story/views/home/home_model.dart';

class HomeController {
  final HomeModel _model;

  const HomeController(this._model);

  Future<void> onClearCacheTap() async {
    _model.setClearingCache(true);
    await _model.storyRepository.clearCache();
    _model.setClearingCache(false);
  }
}
