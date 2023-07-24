import 'package:flutter/material.dart';
import 'package:insta_story/models/story.dart';
import 'package:insta_story/res/enums/media_type.dart';
import 'package:insta_story/views/stories/widgets/story_page_model.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StoryPageController {
  final StoryPageModel _model;

  StoryPageController(this._model) {
    _addListenerToAnimation();
  }

  Future<void> _startAnimation(Story story, {bool reset = true}) async {
    if (_model.disposed) return;
    if (reset) {
      _model.animationController.reset();
    }
    _model.removeVideoPlayer();
    final file = story.file;
    double duration = story.duration;
    if (file.type == MediaType.video) {
      await _model.setVideoPlayerController(file.url);
      duration =
          _model.videoPlayerController!.value.duration.inSeconds.toDouble();
    }
    _model.animationController.duration = Duration(seconds: duration.toInt());
    if (file.type == MediaType.video) {
      _model.videoPlayerController!.play().then((value) {
        _model.animationController.forward(from: 0);
        _model.storyRepository
            .setStoryViewed(_model.user.stories[_model.index]);
      });
    } else {
      _model.animationController.forward(from: 0);
      _model.storyRepository.setStoryViewed(_model.user.stories[_model.index]);
    }
  }

  Future<void> onVisibilityChanged(VisibilityInfo info) async {
    if (_model.disposed) return;
    if (info.visibleFraction < 1 &&
        _model.animationController.isAnimating &&
        _model.visible) {
      final file = _model.user.stories[_model.index].file;
      _model.animationController.stop();
      if (file.type == MediaType.video) {
        await _model.videoPlayerController!.pause();
      }
      _model.setVisible(false);
    } else if (info.visibleFraction == 1 &&
        !_model.animationController.isAnimating) {
      await _startAnimation(
        _model.user.stories[_model.index],
        reset: true,
      );
      _model.setVisible(true);
    }
  }

  Future<void> onNextTap() async {
    if (_model.disposed) return;
    final index = _model.index;
    if (index == _model.user.stories.length - 1) {
      _model.onNextTap(_model.animationController);
    } else {
      _model.setIndex(index + 1);
      await _startAnimation(_model.user.stories[index + 1]);
    }
  }

  Future<void> onPreviousTap() async {
    if (_model.disposed) return;
    final index = _model.index;
    if (index == 0) {
      final res = await _model.onPreviousTap(_model.animationController);
      if (!res) return;
      await _startAnimation(_model.user.stories[index]);
    } else {
      _model.setIndex(index - 1);
      await _startAnimation(_model.user.stories[index - 1]);
    }
  }

  void onTapUp(TapUpDetails details, Size size) {
    if (_model.disposed) return;
    final width = size.width;
    final tapX = details.globalPosition.dx;
    if (tapX < width / 3) {
      onPreviousTap();
    } else {
      onNextTap();
    }
  }

  void onLongPressDown(LongPressStartDetails details) {
    if (_model.disposed) return;
    _model.animationController.stop();
    _model.videoPlayerController?.pause();
    _model.setActionsVisible(false);
  }

  void onLongPressUp(LongPressEndDetails details) {
    if (_model.disposed) return;
    _model.animationController.forward();
    _model.videoPlayerController?.play();
    _model.setActionsVisible(true);
  }

  void onDragStart() {
    if (_model.disposed) return;
    _model.animationController.stop();
  }

  void onDragEnd() {
    if (_model.disposed) return;
    _model.animationController.forward();
  }

  void _addListenerToAnimation() {
    if (_model.addedListenerToAnimation) return;
    _model.addListener(() async {
      if (_model.animationController.isCompleted) {
        await onNextTap();
      }
    });
    _model.setAddedListenerToAnimation(true, notify: false);
  }
}
