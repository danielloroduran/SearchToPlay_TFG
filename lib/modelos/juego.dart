import 'package:SearchToPlay/modelos/fechalanzamiento.dart';
import 'package:SearchToPlay/modelos/genero.dart';
import 'package:SearchToPlay/modelos/imagen.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/modelos/video.dart';
import 'package:SearchToPlay/modelos/web.dart';

class Juego{
  final int id;
  final String nombre;
  final String descripcion;
  final double notaCritica;
  final List<Genero> generos;
  final int categoria;
  final List<String> companias;
  final List<Plataforma> plataformas;
  final List<FechaLanzamiento> fechaLanzamiento;
  final List<Website> websites;
  final List<Imagen> capturas;
  final List<Video> videos;
  final Imagen cover;
  
  Juego({this.id, this.nombre, this.descripcion, this.notaCritica, this.generos, this.categoria, this.companias, this.plataformas, this.fechaLanzamiento, this.websites, this.capturas, this.videos, this.cover});

  static Juego fromMap(Map map){
    return new Juego(
      id: map['id'],
      nombre: map['name'],
      descripcion: map['summary'],
      notaCritica: map['aggregated_rating'],
      generos: Genero.listFromMapList(map['genres']),
      categoria: map['category'],
      companias: companiasFromMapList(map['involved_companies']),
      plataformas: Plataforma.listFromMapList(map['platforms']),
      fechaLanzamiento: map['release_dates'] is List ? FechaLanzamiento.listFromMapList(map['release_dates']) : null,
      websites: Website.listFromMapList(map['websites']),
      capturas: Imagen.listFromMapList(map['screenshots']),
      videos: Video.listFromMapList(map['videos']),
      cover: Imagen.fromMap(map['cover']),
    );
  }

  List<Juego> listFromMapList(List<dynamic> maps){
    if(maps == null){
      return [];
    }
    return maps.map((m) => fromMap(m)).toList();
  }

  static List<String> companiasFromMapList(List<dynamic> maps){
    List<String> finalList = [];
    if(maps == null){
      return finalList;
    }else{
      for(int i = 0; i < maps.length ; i++){
        Map tempMap = maps[i];
        Map finalMap = tempMap['company'];
        finalList.add(finalMap['name']);
      }
      finalList.sort((a, b) => a.length.compareTo(b.length));
      return finalList;
    }
  }
}