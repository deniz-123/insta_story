import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_story/models/media_files/image_file.dart';
import 'package:insta_story/models/media_files/media_file.dart';
import 'package:insta_story/models/media_files/video_file.dart';

@immutable
class Story extends Equatable {
  final String id;
  final double duration;
  final DateTime date;
  final MediaFile file;

  const Story({
    required this.date,
    required this.duration,
    required this.file,
    required this.id,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    MediaFile file;
    final f = json["file"];
    final type = f['type'];
    if (type == "image") {
      file = ImageFile.fromJson(f);
    } else {
      file = VideoFile.fromJson(f);
    }
    return Story(
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      file: file,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "duration": duration,
      "date": date.toIso8601String(),
      "file": file.toJson(),
    };
  }

  Story copyWith({
    String? id,
    double? duration,
    DateTime? date,
    MediaFile? file,
  }) {
    return Story(
      date: date ?? this.date,
      duration: duration ?? this.duration,
      file: file ?? this.file,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [id, duration, date, file];
}
