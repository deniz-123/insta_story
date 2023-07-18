import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_story/models/story.dart';
import 'package:insta_story/models/user.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/res/colors.dart';
import 'package:insta_story/res/enums/media_type.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StoryPage extends StatefulWidget {
  final User user;
  final Future<bool> Function(AnimationController controller) onPreviousTap;
  final Function(AnimationController controller) onNextTap;
  final Function(Story story, AnimationController controller)? onViewDetailsTap;
  const StoryPage(
      {super.key,
      required this.user,
      required this.onPreviousTap,
      required this.onNextTap,
      this.onViewDetailsTap});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin,
        WidgetsBindingObserver {
  late final StoryRepository _storyRepository;
  late final AnimationController _animationController =
      AnimationController(vsync: this);
  VideoPlayerController? _videoPlayerController;
  final GlobalKey _visibilityKey = GlobalKey();
  late int _index;
  bool _visible = true;
  bool _actionsVisible = true;
  bool _inittingVideoPlayer = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    _storyRepository = Provider.of<StoryRepository>(context, listen: false);
    _animationController.addListener(_animationListener);
    final startIndex = widget.user.stories
        .indexWhere((story) => !_storyRepository.viewedStory(story));
    _index = startIndex != -1 ? startIndex : 0;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.stop();
    _animationController.removeListener(_animationListener);
    _animationController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final file = widget.user.stories[_index].file;
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_animationController.isAnimating) {
          if (file.type == MediaType.video) {
            await _videoPlayerController!.play();
          }
          _animationController.forward();
        }
      case AppLifecycleState.detached ||
            AppLifecycleState.paused ||
            AppLifecycleState.inactive:
        if (_animationController.isAnimating) {
          if (file.type == MediaType.video) {
            _animationController.stop();
            await _videoPlayerController!.pause();
          }
        }
    }
  }

  Future<void> _startAnimation(Story story, {bool reset = true}) async {
    if (reset) {
      _animationController.reset();
    }
    if (mounted) {
      _videoPlayerController?.dispose();
    }
    final file = story.file;
    double duration = story.duration;
    if (file.type == MediaType.video) {
      await _setVideoPlayerController(file.url);
      duration = _videoPlayerController!.value.duration.inSeconds.toDouble();
    }
    _animationController.duration = Duration(seconds: duration.toInt());
    if (file.type == MediaType.video) {
      await _videoPlayerController!.play();
    }
    _animationController.forward();
    _storyRepository.setStoryViewed(widget.user.stories[_index]);
  }

  Future<void> _onVisibilityChanged(VisibilityInfo info) async {
    if (info.visibleFraction < 1 &&
        _animationController.isAnimating &&
        _visible) {
      final file = widget.user.stories[_index].file;
      _animationController.stop();
      if (file.type == MediaType.video) {
        await _videoPlayerController!.pause();
      }
      _visible = false;
      setState(() {});
    } else if (info.visibleFraction == 1 && !_animationController.isAnimating) {
      await _startAnimation(
        widget.user.stories[_index],
        reset: true,
      );
      _visible = true;
      setState(() {});
    }
  }

  void _animationListener() {
    if (_animationController.isCompleted) {
      _onNextTap();
    }
  }

  Future<void> _onNextTap() async {
    if (_index == widget.user.stories.length - 1) {
      widget.onNextTap(_animationController);
    } else {
      _index += 1;

      await _startAnimation(widget.user.stories[_index]);
      setState(() {});
    }
  }

  Future<void> _onPreviousTap() async {
    if (_index == 0) {
      final res = await widget.onPreviousTap(_animationController);
      if (!res) return;
      await _startAnimation(widget.user.stories[_index]);
    } else {
      _index -= 1;
      await _startAnimation(widget.user.stories[_index]);
      setState(() {});
    }
  }

  void _onTapUp(TapUpDetails details) {
    final width = MediaQuery.of(context).size.width;
    final tapX = details.globalPosition.dx;
    if (tapX < width / 3) {
      _onPreviousTap();
    } else {
      _onNextTap();
    }
  }

  void _onLongPressDown(LongPressStartDetails details) {
    _animationController.stop();
    _setActionsVisible(false);
  }

  void _onLongPressUp(LongPressEndDetails details) {
    _animationController.forward();
    _setActionsVisible(true);
  }

  void _setActionsVisible(bool val) {
    _actionsVisible = val;
    setState(() {});
  }

  void _setInittingVideoPlayer(bool val) {
    _inittingVideoPlayer = val;
    setState(() {});
  }

  Future<void> _setVideoPlayerController(String url) async {
    _setInittingVideoPlayer(true);
    _videoPlayerController?.dispose();
    final uri = Uri.tryParse(url);
    _videoPlayerController = VideoPlayerController.networkUrl(uri!);
    await _videoPlayerController!.initialize();
    setState(() {});
    _setInittingVideoPlayer(false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final fileIsVideo =
        widget.user.stories[_index].file.type == MediaType.video;

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: DismissiblePage(
        onDragStart: () {
          _animationController.stop();
        },
        onDragEnd: () {
          _animationController.forward();
        },
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
                    onTapUp: _onTapUp,
                    onLongPressStart: _onLongPressDown,
                    onLongPressEnd: _onLongPressUp,
                    child: Stack(
                      children: [
                        Container(
                          width: size.width,
                          height: size.width * 16 / 9,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            image: fileIsVideo
                                ? null
                                : DecorationImage(
                                    image: NetworkImage(
                                      widget.user.stories[_index].file.url,
                                    ),
                                  ),
                          ),
                          child: !fileIsVideo
                              ? null
                              : _inittingVideoPlayer ||
                                      _videoPlayerController == null
                                  ? Center(
                                      child: CupertinoActivityIndicator(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : VideoPlayer(_videoPlayerController!),
                        ),
                        StoryBody(
                          actionsVisible: _actionsVisible,
                          index: _index,
                          user: widget.user,
                          size: size,
                          animationController: _animationController,
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
    final date = DateTime.now();
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
