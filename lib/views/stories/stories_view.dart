import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/views/common/base_view.dart';
import 'package:insta_story/views/stories/stories_controller.dart';
import 'package:insta_story/views/stories/stories_model.dart';
import 'package:insta_story/views/stories/widgets/story_page_view.dart';
import 'package:provider/provider.dart';

class StoriesView extends StatelessWidget {
  final int index;
  const StoriesView({super.key, required this.index});

  num _degToRad(num deg) => deg * (pi / 180.0);

  @override
  Widget build(BuildContext context) {
    final storyRepo = Provider.of<StoryRepository>(context);
    return BaseView(
      createModel: (context) => StoriesModel(index.toDouble()),
      builder: (context, model, size, padding) {
        final storiesController = StoriesController(model);
        return PageView.builder(
          controller: model.pageController,
          itemCount: storyRepo.feed.length,
          itemBuilder: (context, index) {
            final leaving = (index - model.index) <= 0;
            final transform = Matrix4.identity();
            final t = index - model.index;
            final rotationY = lerpDouble(0, 45, t)!;
            transform.setEntry(3, 2, 0.003);
            transform.rotateY(-_degToRad(rotationY).toDouble());
            return Transform(
              transform: transform,
              alignment: leaving ? Alignment.centerRight : Alignment.centerLeft,
              child: StoryPage(
                user: storyRepo.feed[index],
                onPreviousTap: (controller) async {
                  return await storiesController.onPreviousTap(index);
                },
                onNextTap: (controller) async {
                  storiesController.onNextTap(
                      index, storyRepo.feed.length - 1, context);
                },
              ),
            );
          },
        );
      },
    );
  }
}
