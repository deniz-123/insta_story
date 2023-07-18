import 'package:flutter/material.dart';
import 'package:insta_story/models/user.dart';
import 'package:insta_story/repositories/story_repository.dart';
import 'package:insta_story/res/colors.dart';
import 'package:provider/provider.dart';

class Avatar extends StatelessWidget {
  final User user;
  final double radius;
  final Function() onTap;
  const Avatar(
      {super.key,
      required this.user,
      required this.onTap,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<StoryRepository>(context);
    final viewedAll = repo.viewedAllStories(user);
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: viewedAll ? AppColors.secondary : AppColors.story,
            child: CircleAvatar(
              radius: radius - 2,
              backgroundColor: AppColors.background,
              child: CircleAvatar(
                radius: radius - 3,
                foregroundImage: NetworkImage(user.photo),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            user.username,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.primary),
          )
        ],
      ),
    );
  }
}
