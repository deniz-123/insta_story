import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_story/res/enums/media_type.dart';

@immutable
abstract class MediaFile extends Equatable {
  final String id;
  final String url;
  final MediaType type;

  const MediaFile({
    required this.id,
    required this.type,
    required this.url,
  });

  Map<String, dynamic> toJson();

  @override
  List<Object?> get props => [id, url, type];
}
