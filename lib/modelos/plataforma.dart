class Plataforma{
  final int plataformaId;
  final String nombre;
  final String abreviacion;

  Plataforma({this.plataformaId, this.nombre, this.abreviacion});

  static Plataforma fromMap(Map map){
    if(map == null){
      return null;
    }

    return new Plataforma(
      plataformaId: map['id'],
      nombre: map['name'],
      abreviacion: map['abbreviation'],
    );
  }

  static List<Plataforma> listFromMapList(List<dynamic> maps){
    if(maps == null){
      return new List<Plataforma>();
    }

    return maps.map((map) => fromMap(map)).toList();
  }
}