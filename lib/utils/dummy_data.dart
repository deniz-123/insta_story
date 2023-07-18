import 'package:insta_story/models/media_files/image_file.dart';
import 'package:insta_story/models/media_files/video_file.dart';
import 'package:insta_story/models/story.dart';
import 'package:insta_story/models/user.dart';
import 'package:insta_story/res/enums/media_type.dart';

class DummyData {
  static final _date = DateTime(2023, 7, 18, 24);
  static const _i1 = ImageFile(
    height: 1500,
    width: 1000,
    id: "i1",
    type: MediaType.image,
    url:
        "https://images.unsplash.com/photo-1564754943164-e83c08469116?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8dmVydGljYWx8ZW58MHx8MHx8fDA%3D&w=1000&q=80",
  );
  static const _i2 = ImageFile(
    height: 1920,
    width: 1080,
    id: "i2",
    type: MediaType.image,
    url:
        "https://wallpaper-mania.com/wp-content/uploads/2018/09/High_resolution_wallpaper_background_ID_77701449525.jpg",
  );
  static const _i3 = ImageFile(
    height: 1294,
    width: 728,
    id: "i3",
    type: MediaType.image,
    url:
        "https://c4.wallpaperflare.com/wallpaper/459/731/792/landscape-city-vertical-wallpaper-preview.jpg",
  );
  static const _i4 = ImageFile(
    height: 1080,
    width: 1920,
    id: "i4",
    type: MediaType.image,
    url:
        "https://www.pixelstalk.net/wp-content/uploads/2016/08/1080-x-1920-HD-Image-Vertical.jpg",
  );

  static const _v1 = VideoFile(
    height: 1,
    width: 1,
    duration: 22,
    id: "v1",
    type: MediaType.video,
    url:
        "https://cdn.pixabay.com/vimeo/588566505/lake-84878.mp4?width=360&hash=a7c9863dfd814fa7181cf418b295e01e9b2fd20f",
  );
  static const _v2 = VideoFile(
    height: 1,
    width: 1,
    duration: 6,
    id: "v2",
    type: MediaType.video,
    url:
        "https://cdn.pixabay.com/vimeo/733398970/mountains-125449.mp4?width=720&hash=b641c840692daeaf907a4111a43ee23b1e28866e",
  );

  static final _s1 = Story(
    date: _date.subtract(const Duration(hours: 3)),
    duration: 5,
    file: _i1,
    id: "s1",
  );
  static final _s2 = Story(
    date: _date.subtract(const Duration(hours: 7)),
    duration: 5,
    file: _i2,
    id: "s2",
  );
  static final _s3 = Story(
    date: _date.subtract(const Duration(hours: 11)),
    duration: 5,
    file: _i3,
    id: "s3",
  );
  static final _s4 = Story(
    date: _date.subtract(const Duration(hours: 15)),
    duration: 5,
    file: _i4,
    id: "s4",
  );
  static final _s5 = Story(
    date: _date.subtract(const Duration(hours: 19)),
    duration: 22,
    file: _v1,
    id: "s5",
  );
  static final _s6 = Story(
    date: _date.subtract(const Duration(hours: 23)),
    duration: 6,
    file: _v2,
    id: "s6",
  );

  static final _u1 = User(
    id: "u1",
    name: "Deniz",
    username: "deniz",
    photo:
        "https://www.wallpaperup.com/uploads/wallpapers/2014/10/07/474003/873f1b2c185fdb2c43b65ba3109641ca-187.jpg",
    stories: [_s1.copyWith(id: "deniz-s1"), _s2.copyWith(id: "deniz-s2")],
  );
  static final _u2 = User(
    id: "u2",
    name: "Berkant",
    username: "berkant",
    photo:
        "https://www.wallpaperup.com/uploads/wallpapers/2014/10/07/474006/bd67a648ac9d7336a657cd1b34f17245-187.jpg",
    stories: [_s3.copyWith(id: "berkant-s3"), _s4.copyWith(id: "berkant-s4")],
  );
  static final _u3 = User(
    id: "u2",
    name: "Demirörs",
    username: "demirörs",
    photo:
        "https://www.wallpaperup.com/uploads/wallpapers/2014/07/21/401354/257c583008a5894a7a8ef40f0c594f56-187.jpg",
    stories: [_s2.copyWith(id: "demirörs-s2"), _s5.copyWith(id: "demirörs-s5")],
  );
  static final _u4 = User(
    id: "u2",
    name: "Codeway",
    username: "codeway",
    photo:
        "https://uploads-ssl.webflow.com/6003416b0aa4a84bf3bfbd91/6003416b0aa4a83ae6bfbdd7_razdel.png",
    stories: [_s2.copyWith(id: "codeway-s2"), _s6.copyWith(id: "codeway-s6")],
  );

  static List<User> get users => [_u1, _u2, _u3, _u4];
}
