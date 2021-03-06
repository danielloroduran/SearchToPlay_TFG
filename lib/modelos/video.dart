class Video {
  final String name;
  final String videoId; // youtube slug

  Video({this.name, this.videoId});

  static Video fromMap(Map<String, dynamic> map) {
    return new Video(
      name: map['name'],
      videoId: map['video_id'],
    );
  }

  static List<Video> listFromMapList(List<dynamic> maps) {
    if (maps == null) {
      return [];
    }

    return maps
        .whereType<Map>()
        .map((m) => fromMap(m)).toList();
  }
}