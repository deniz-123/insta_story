import 'package:flutter/material.dart';
import 'package:insta_story/views/stories/stories_model.dart';

class StoriesController {
  final StoriesModel _model;

  const StoriesController(this._model);

  Future<bool> onPreviousTap(int index) async {
    if (index != 0) {
      _model.pageController.previousPage(
          duration: const Duration(milliseconds: 250), curve: Curves.linear);
      return false;
    }

    return true;
  }

  Future<void> onNextTap(int index, int maxLength, BuildContext context) async {
    if (index == maxLength) {
      Navigator.of(context).pop();
    } else {
      _model.nextPage();
    }
  }
}
