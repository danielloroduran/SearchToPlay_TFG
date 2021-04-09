class Imagen {
  String url;
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
        imageId: map['image_id'],
        width: map['width'],
        height: map['height']
    );
  }

  static List<Imagen> listFromMapList(List<dynamic> maps) {
    if (maps == null) {
      return new List<Imagen>();
    }

    return maps.map((map) => fromMap(map)).toList();
  }

  static String getImageUrl(String imageId, {bool isRetina=false, bool alphaChannel=false}) {
    //String sizeStr = isRetina ? '${size.name}_2x' : '${size.name}';
    String fileExtension = alphaChannel ? 'png' : 'jpg';
   return 'https://images.igdb.com/igdb/image/upload/t_cover_big/${imageId}.$fileExtension';
  }

}