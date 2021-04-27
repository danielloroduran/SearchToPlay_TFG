class Website {

  final int id;
  final String url;
  final int categoria;

  Website({this.id, this.url, this.categoria});

  static Website fromMap(Map map) {
    if (map == null) {
      return null;
    }

    return new Website(
      id: map['id'],
      url: map['url'],
      categoria: map['category'],
    );
  }

  static List<Website> listFromMapList(List<dynamic> maps){
    if(maps == null){
      return [];
    }

    return maps.map((map) => fromMap(map)).toList();
  }
}