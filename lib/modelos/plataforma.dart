class Plataforma{
  final int plataformaId;
  final String nombre;
  final String abreviacion;
  final String alternativo;

  Plataforma({this.plataformaId, this.nombre, this.abreviacion, this.alternativo});

  static Plataforma fromMap(Map map){
    if(map == null){
      return null;
    }

    return new Plataforma(
      plataformaId: map['id'],
      nombre: map['name'],
      abreviacion: map['abbreviation'],
      alternativo: map['alternative_name']
    );
  }

  static List<Plataforma> listFromMapList(List<dynamic> maps){
    if(maps == null){
      return [];
    }

    return maps.map((map) => fromMap(map)).toList();
  }
}