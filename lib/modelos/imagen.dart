class Imagen {
  final String url;
  final String imageId;
  final int width;
  final int height;

  Imagen({
    this.url,
    this.imageId,
    this.width,
    this.height,
  });

  static Imagen fromMap(Map map) {
    if (map == null) {
      return null;
    }

    return new Imagen(
      url: map['url'],
      imageId: map['image_id'],
      width: map['width'],
      height: map['height']
    );
  }

  static List<Imagen> listFromMapList(List<dynamic> maps) {
    if (maps == null) {
      return [];
    }

    return maps.map((map) => fromMap(map)).toList();
  }
}