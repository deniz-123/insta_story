import 'package:flutter/cupertino.dart';
import 'package:insta_story/models/user.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/res/enums/media_type.dart';
import 'package:video_player/video_player.dart';

class StoryPageModel extends ChangeNotifier with WidgetsBindingObserver {
  final GlobalKey visibilityKey = GlobalKey();
  final TickerProvider vsync;
  final User user;
  final Function(AnimationController) onNextTap;
  final Function(AnimationController) onPreviousTap;
  late final StoryRepository storyRepository;
  late final AnimationController animationController =
      AnimationController(vsync: vsync);
  late int _index;
  VideoPlayerController? _videoPlayerController;
  bool _addedListenerToAnimation = false;
  bool _inittingVideoPlayer = true;
  bool _actionsVisible = true;
  bool _disposed = false;
  bool _visible = true;

  VideoPlayerController? get videoPlayerController => _videoPlayerController;
  bool get addedListenerToAnimation => _addedListenerToAnimation;
  bool get fileIsVideo => user.stories[index].file.type == MediaType.video;
  bool get inittingVideoPlayer => _inittingVideoPlayer;
  bool get actionsVisible => _actionsVisible;
  bool get disposed => _disposed;
  bool get visible => _visible;
  int get index => _index;

  StoryPageModel(this.storyRepository, this.vsync, this.user, this.onNextTap,
      this.onPreviousTap) {
    WidgetsBinding.instance.addObserver(this);
    final startIndex =
        user.stories.indexWhere((story) => !storyRepository.viewedStory(story));
    _index = startIndex != -1 ? startIndex : 0;
    animationController.addListener(notifyListeners);
  }

  Future<void> setVideoPlayerController(String url) async {
    setInittingVideoPlayer(true);
    _videoPlayerController?.dispose();
    final uri = Uri.tryParse(url);
    _videoPlayerController = VideoPlayerController.networkUrl(uri!);
    await _videoPlayerController!.initialize();
    notifyListeners();
    setInittingVideoPlayer(false);
  }

  void setActionsVisible(bool val) {
    _actionsVisible = val;
    notifyListeners();
  }

  void setInittingVideoPlayer(bool val) {
    _inittingVideoPlayer = val;
    notifyListeners();
  }

  void setIndex(int val, {bool notify = false}) {
    _index = val;
    if (notify) {
      notifyListeners();
    }
  }

  void setVisible(bool val) {
    _visible = val;
    notifyListeners();
  }

  void setAddedListenerToAnimation(bool val, {bool notify = true}) {
    _addedListenerToAnimation = val;
    if (notify) {
      notifyListeners();
    }
  }

  void addListenerToAnimation(Function() fn) {
    animationController.addListener(fn);
  }

  void removeVideoPlayer() {
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    notifyListeners();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final file = user.stories[_index].file;
    switch (state) {
      case AppLifecycleState.resumed:
        if (!animationController.isAnimating) {
          if (file.type == MediaType.video) {
            await _videoPlayerController!.play();
          }
          animationController.forward();
        }
      case AppLifecycleState.detached ||
            AppLifecycleState.paused ||
            AppLifecycleState.inactive:
        if (animationController.isAnimating) {
          if (file.type == MediaType.video) {
            animationController.stop();
            await _videoPlayerController!.pause();
          }
        }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    animationController.stop();
    animationController.dispose();
    _videoPlayerController?.dispose();
    _disposed = true;
    super.dispose();
  }
}
