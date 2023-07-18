import 'package:insta_story/models/media_files/media_file.dart';
import 'package:insta_story/res/enums/media_type.dart';

class VideoFile extends MediaFile {
  final double width;
  final double height;
  final double duration;

  const VideoFile({
    required this.height,
    required this.width,
    required this.duration,
    required super.id,
    required super.type,
    required super.url,
  });

  factory VideoFile.fromJson(Map<String, dynamic> json) {
    return VideoFile(
      height: json['height'],
      width: json['width'],
      duration: json['duration'],
      id: json['id'],
      type: (json['type'] as String).mediaType(),
      url: json['url'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": super.id,
      "url": super.url,
      "type": super.type.name,
      "width": width,
      "height": height,
      "duration": duration,
    };
  }
}
