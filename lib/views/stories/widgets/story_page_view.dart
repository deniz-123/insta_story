import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_story/models/story.dart';
import 'package:insta_story/models/user.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/res/colors.dart';
import 'package:insta_story/utils/dummy_data.dart';
import 'package:insta_story/views/common/base_view.dart';
import 'package:insta_story/views/stories/widgets/story_page_controller.dart';
import 'package:insta_story/views/stories/widgets/story_page_model.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StoryPage extends StatefulWidget {
  final User user;
  final Future<bool> Function(AnimationController controller) onPreviousTap;
  final Function(AnimationController controller) onNextTap;
  final Function(Story story, AnimationController controller)? onViewDetailsTap;
  const StoryPage({
    super.key,
    required this.user,
    required this.onPreviousTap,
    required this.onNextTap,
    this.onViewDetailsTap,
  });

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseView(
        createModel: (context) => StoryPageModel(
            Provider.of<StoryRepository>(context, listen: false),
            this,
            widget.user,
            widget.onNextTap,
            widget.onPreviousTap),
        builder: (context, model, size, padding) {
          final controller = StoryPageController(model);
          return VisibilityDetector(
            key: model.visibilityKey,
            onVisibilityChanged: controller.onVisibilityChanged,
            child: DismissiblePage(
              onDragStart: controller.onDragStart,
              onDragEnd: controller.onDragEnd,
              dismissThresholds: const {
                DismissiblePageDismissDirection.down: .4,
                DismissiblePageDismissDirection.endToStart: .4,
                DismissiblePageDismissDirection.horizontal: .4,
                DismissiblePageDismissDirection.multi: .4,
                DismissiblePageDismissDirection.none: .4,
                DismissiblePageDismissDirection.startToEnd: .4,
                DismissiblePageDismissDirection.up: .4,
                DismissiblePageDismissDirection.vertical: .4
              },
              minRadius: 0,
              maxRadius: 36,
              direction: DismissiblePageDismissDirection.vertical,
              backgroundColor: AppColors.background,
              onDismissed: Navigator.of(context).pop,
              startingOpacity: 1,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: padding.top,
                        ),
                        GestureDetector(
                          onTapUp: (details) => controller.onTapUp(
                              details, MediaQuery.of(context).size),
                          onLongPressStart: controller.onLongPressDown,
                          onLongPressEnd: controller.onLongPressUp,
                          child: Stack(
                            children: [
                              Container(
                                width: size.width,
                                height: size.width * 16 / 9,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  image: model.fileIsVideo
                                      ? null
                                      : DecorationImage(
                                          image: NetworkImage(
                                            model.user.stories[model.index].file
                                                .url,
                                          ),
                                        ),
                                ),
                                child: !model.fileIsVideo
                                    ? null
                                    : model.inittingVideoPlayer ||
                                            model.videoPlayerController == null
                                        ? Center(
                                            child: CupertinoActivityIndicator(
                                              color: AppColors.primary,
                                            ),
                                          )
                                        : VideoPlayer(
                                            model.videoPlayerController!),
                              ),
                              StoryBody(
                                actionsVisible: model.actionsVisible,
                                index: model.index,
                                user: widget.user,
                                size: size,
                                animationController: model.animationController,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class StoryBody extends StatelessWidget {
  final bool actionsVisible;
  final int index;
  final User user;
  final Size size;
  final AnimationController animationController;
  const StoryBody({
    super.key,
    required this.actionsVisible,
    required this.index,
    required this.user,
    required this.size,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final date = DummyData.date;
    final story = user.stories[index];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: !actionsVisible
          ? null
          : Container(
              padding: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withOpacity(.5), Colors.transparent],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < user.stories.length; i++)
                          AnimatedBar(
                            storyIndex: i,
                            index: index,
                            animationController: animationController,
                            user: user,
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 19,
                              backgroundColor: Colors.grey[850],
                              foregroundImage: user.photo.isEmpty
                                  ? null
                                  : NetworkImage(user.photo),
                              child: user.photo.isEmpty
                                  ? const Icon(
                                      CupertinoIcons.person_solid,
                                      color: Colors.white,
                                      size: 19,
                                    )
                                  : null,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      user.username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${date.difference(story.date).inHours}h",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 19,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  final int storyIndex;
  final int index;
  final User user;
  final AnimationController animationController;
  const AnimatedBar(
      {super.key,
      required this.storyIndex,
      required this.index,
      required this.user,
      required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(
            left: storyIndex == 0 ? 0 : 1.5,
            right: storyIndex == user.stories.length - 1 ? 0 : 1.5),
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              Container(
                height: 2,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.3),
                    borderRadius: BorderRadius.circular(6)),
              ),
              AnimatedBuilder(
                animation: animationController,
                builder: (context, child) {
                  return Container(
                    height: 2,
                    width: storyIndex < index
                        ? constraints.maxWidth
                        : storyIndex > index
                            ? 0
                            : constraints.maxWidth * animationController.value,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  );
                },
              )
            ],
          );
        }),
      ),
    );
  }
}
