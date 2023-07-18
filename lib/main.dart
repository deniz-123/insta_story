import 'package:flutter/cupertino.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/utils/app_config.dart';
import 'package:insta_story/views/home/home_view.dart';
import 'package:provider/provider.dart';

void main() async {
  await AppConfig.init();
  runApp(const InstaStory());
}

class InstaStory extends StatelessWidget {
  const InstaStory({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => StoryRepository())),
      ],
      builder: (context, child) {
        return const CupertinoApp(
          home: HomeView(),
        );
      },
    );
  }
}
