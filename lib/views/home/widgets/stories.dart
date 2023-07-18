import 'package:flutter/cupertino.dart';
import 'package:insta_story/models/user.dart';
import 'package:insta_story/views/home/widgets/avatar.dart';

class Stories extends StatelessWidget {
  final List<User> users;
  final Function(int index) onStoryTap;
  const Stories({super.key, required this.users, required this.onStoryTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 10 : 0, right: 10),
          child: Avatar(
            user: users[index],
            radius: MediaQuery.of(context).size.height * .05,
            onTap: () {
              onStoryTap(index);
            },
          ),
        );
      },
    );
  }
}
