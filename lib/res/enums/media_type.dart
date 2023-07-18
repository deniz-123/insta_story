enum MediaType { image, video }

extension MediaTypeStringExtension on String {
  MediaType mediaType() {
    switch (this) {
      case "image":
        return MediaType.image;
      case "video":
        return MediaType.video;
      default:
        return MediaType.video;
    }
  }
}
