import 'package:flutter/cupertino.dart';
import 'package:insta_story/repositories/story_repository.dart';

class HomeModel extends ChangeNotifier {
  final StoryRepository storyRepository;
  bool _clearingCache = false;

  bool get clearingCache => _clearingCache;

  HomeModel(this.storyRepository);

  void setClearingCache(bool val) {
    _clearingCache = val;
    notifyListeners();
  }

  void notify() => notifyListeners();
}
