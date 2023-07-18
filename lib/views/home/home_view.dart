import 'package:flutter/cupertino.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/res/colors.dart';
import 'package:insta_story/views/common/base_view.dart';
import 'package:insta_story/views/home/home_controller.dart';
import 'package:insta_story/views/home/home_model.dart';
import 'package:insta_story/views/home/widgets/stories.dart';
import 'package:insta_story/views/stories/stories_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final storyRepo = Provider.of<StoryRepository>(context, listen: false);
    final storyRepoListenable = Provider.of<StoryRepository>(context);
    return BaseView(
      createModel: (context) => HomeModel(storyRepo),
      builder: (context, model, size, padding) {
        final controller = HomeController(model);
        return CupertinoPageScaffold(
          backgroundColor: AppColors.background,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: padding.top,
                ),
                SizedBox(
                  width: size.width,
                  height: size.height * .1 + 40,
                  child: Stories(
                    users: storyRepoListenable.feed,
                    onStoryTap: (index) async {
                      await Navigator.of(context).push(
                        CupertinoModalPopupRoute(
                          builder: (context) => StoriesView(index: index),
                        ),
                      );
                      storyRepo.sortFeed();
                    },
                  ),
                ),
                const Spacer(),
                CupertinoButton(
                  color: AppColors.buttonColor,
                  onPressed: controller.onClearCacheTap,
                  child: Text(
                    "Clear Story Cache",
                    style: TextStyle(color: AppColors.buttonForegroundColor),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }
}
