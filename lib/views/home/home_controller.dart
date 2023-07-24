import 'package:flutter/cupertino.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/views/home/home_model.dart';
import 'package:insta_story/views/stories/stories_view.dart';

class HomeController {
  final HomeModel _model;

  const HomeController(this._model);

  Future<void> onClearCacheTap() async {
    _model.setClearingCache(true);
    await _model.storyRepository.clearCache();
    _model.setClearingCache(false);
  }

  Future<void> onStoryTap(
      int index, BuildContext context, StoryRepository storyRepo) async {
    await Navigator.of(context).push(
      CupertinoModalPopupRoute(
        builder: (context) => StoriesView(index: index),
      ),
    );
    storyRepo.sortFeed();
  }
}
