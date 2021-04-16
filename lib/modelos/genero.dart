class Genero{
  final int generoId;
  final String nombre;

  Genero({this.generoId, this.nombre});

  static Genero fromMap(Map map){
    if(map == null){
      return null;
    }

    return new Genero(
      generoId: map['id'],
      nombre: map['name'],
    );
  }

  static List<Genero> listFromMapList(List<dynamic> maps){
    if(maps == null){
      return new List<Genero>();
    }

    return maps.map((map) => fromMap(map)).toList();
  }
}
