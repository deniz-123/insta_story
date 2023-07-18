import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_story/models/story.dart';

@immutable
class User extends Equatable {
  final String id;
  final String username;
  final String name;
  final String photo;
  final List<Story> stories;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.photo,
    required this.stories,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final stories = <Story>[];
    if (json['stories'] is List<Map<String, dynamic>>) {
      for (final story in json['stories']) {
        stories.add(Story.fromJson(story));
      }
    }
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      photo: json['photo'],
      stories: stories,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "name": name,
      "photo": photo,
    };
  }

  @override
  List<Object?> get props => [];
}
