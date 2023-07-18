import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:insta_story/models/story.dart';
import 'package:insta_story/models/user.dart';
import 'package:insta_story/utils/dummy_data.dart';
import 'package:insta_story/utils/extensions/list_extensions.dart';
import 'package:insta_story/utils/sp_util.dart';

class StoryRepository extends ChangeNotifier {
  final _storiesViewed = <Story>[];
  final _feed = <User>[];

  List<Story> get storiesViewed => _storiesViewed;
  List<User> get feed => _feed;

  StoryRepository() {
    _feed.addAll(DummyData.users);
    final cache = SPUtil.instance.storiesViewed;
    final viewed = cache.map((e) {
      final decoded = jsonDecode(e);
      return Story.fromJson(decoded);
    });
    for (final story in viewed) {
      if (story.date.toLocal().difference(DateTime.now()).inHours.abs() < 24) {
        _storiesViewed.add(story);
        notifyListeners();
      }
    }
    _setDeviceCache();
    sortFeed();
  }

  /// if a is viewed and b is not or vice versa return positive
  /// else return their datetime comparison
  void sortFeed() {
    feed.sort((a, b) {
      final viewedA = viewedAllStories(a);
      final viewedB = viewedAllStories(b);
      if (viewedA && !viewedB) {
        return 1;
      }
      if (!viewedA && viewedB) {
        return -1;
      }
      return -1 * a.stories.last.date.compareTo(b.stories.last.date);
    });
    notifyListeners();
  }

  bool viewedAllStories(User user) {
    return _storiesViewed.containsAll<Story>(user.stories);
  }

  bool viewedStory(Story story) {
    return _storiesViewed.contains(story);
  }

  Future<void> _setDeviceCache() async {
    await SPUtil.instance.setStoriesViewed([]);
    final cache = _storiesViewed.map((e) {
      final json = e.toJson();
      return jsonEncode(json);
    }).toList();
    await SPUtil.instance.setStoriesViewed(cache);
  }

  Future<void> clearCache() async {
    await SPUtil.instance.setStoriesViewed([]);
    _storiesViewed.clear();
    sortFeed();
  }

  void setStoryViewed(Story story) async {
    if (_storiesViewed.contains(story)) return;
    _storiesViewed.add(story);
    _setDeviceCache();
    notifyListeners();
  }

  @override
  void dispose() {
    _setDeviceCache();
    super.dispose();
  }
}
