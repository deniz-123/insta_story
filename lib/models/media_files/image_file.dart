import 'package:insta_story/models/media_files/media_file.dart';
import 'package:insta_story/res/enums/media_type.dart';

class ImageFile extends MediaFile {
  final double width;
  final double height;

  const ImageFile({
    required this.height,
    required this.width,
    required super.id,
    required super.type,
    required super.url,
  });

  factory ImageFile.fromJson(Map<String, dynamic> json) {
    return ImageFile(
      height: json['height'],
      width: json['width'],
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
      "height": height
    };
  }
}
