import 'package:SearchToPlay/modelos/fechalanzamiento.dart';
import 'package:SearchToPlay/modelos/genero.dart';
import 'package:SearchToPlay/modelos/imagen.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/modelos/video.dart';
import 'package:igdb_client/igdb_client.dart';

class Juego{
  final int id;
  final String nombre;
  final String descripcion;
  final double criticRating;
  final List<Genero> generos;
  final int category;
  final List<Plataforma> plataformas;
  final List<FechaLanzamiento> fechaLanzamiento;
  final List<Imagen> capturas;
  final List<Video> videos;
  final Imagen cover;
  
  Juego({this.id, this.nombre, this.descripcion, this.criticRating, this.generos, this.category, this.plataformas, this.fechaLanzamiento, this.capturas, this.videos, this.cover});

  static Juego fromMap(Map map){
    return new Juego(
      id: map['id'],
      nombre: map['name'],
      descripcion: map['summary'],
      criticRating: map['aggregated_rating'],
      generos: Genero.listFromMapList(map['genres']),
      category: map['category'],
      plataformas: Plataforma.listFromMapList(map['platforms']),
      fechaLanzamiento: map['release_dates'] is List ? FechaLanzamiento.listFromMapList(map['release_dates']) : null,
      //capturas: Imagen.listFromMapList(map['screenshots']),
      videos: Video.listFromMapList(map['videos']),
      cover: Imagen.fromMap(map['cover']),
    );
  }

  List<Juego> listFromMapList(List<dynamic> maps){
    if(maps == null){
      return new List<Juego>();
    }
    return maps.map((m) => fromMap(m)).toList();
  }
}
