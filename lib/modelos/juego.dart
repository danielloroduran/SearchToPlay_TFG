import 'package:SearchToPlay/modelos/fechalanzamiento.dart';
import 'package:SearchToPlay/modelos/imagen.dart';
import 'package:SearchToPlay/modelos/video.dart';
import 'package:igdb_client/igdb_client.dart';

class Juego{
  final int id;
  final String nombre;
  final String descripcion;
  final double criticRating;
  final List<IGDBGenres> generos;
  final List<IGDBPlatforms> plataformas;
  final List<FechaLanzamiento> fechaLanzamiento;
  final List<Imagen> capturas;
  final List<Video> videos;
  final int coverId;
  String coverURL;
  Imagen cover;
  
  Juego({this.id, this.nombre, this.descripcion, this.criticRating, this.generos, this.plataformas, this.fechaLanzamiento, this.capturas, this.videos, this.cover, this.coverId, this.coverURL});

  static Juego fromMap(Map map){
    return new Juego(
      id: map['id'],
      nombre: map['name'],
      descripcion: map['description'],
      criticRating: map['aggregated_rating'],
      generos: genresListFromMapList(map['genres']),
      plataformas: platformsListFromMapList(map['platforms']),
      //fechaLanzamiento: map['release_dates'] is List ? ReleaseDate.listFromMapList(map['release_dates']) : null,
      //capturas: Imagen.listFromMapList(map['screenshots']),
      videos: Video.listFromMapList(map['videos']),
      coverId: map['cover'],
    );
  }

  List<Juego> listFromMapList(List<dynamic> maps){
    if(maps == null){
      return new List<Juego>();
    }
    return maps.map((m) => fromMap(m)).toList();
  }

  static List<IGDBGenres> genresListFromMapList(List maps) {
    if (maps == null) {
      return new List<IGDBGenres>();
    }

    return maps.map((m) => IGDBGenres.fromInt(m)).toList();
  }

  static List<IGDBPlatforms> platformsListFromMapList(List maps) {
    if (maps == null) {
      return new List<IGDBPlatforms>();
    }

    return maps.map((m) => IGDBPlatforms.fromInt(m)).toList();
  }
}
