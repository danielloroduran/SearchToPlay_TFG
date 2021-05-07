import 'package:SearchToPlay/modelos/plataforma.dart';

class FechaLanzamiento{

  final int id;
  final Plataforma plataforma;
  final DateTime date;
  final int y;
  final int m;
  final String legible;
  final int region;

  FechaLanzamiento({this.id, this.plataforma, this.date, this.y, this.m, this.legible, this.region});

  static FechaLanzamiento fromMap(Map map){
    return new FechaLanzamiento(
      id: map['id'],
      date: dateTimeFromMsecSinceEpoch(map['date']),
      y: map['y'],
      m: map['m'],
      legible: map['human'], 
      plataforma: Plataforma.fromMap(map['platform']),
      region: map['region'],
    );
  }

  static DateTime dateTimeFromMsecSinceEpoch(int timestamp) {
    if (timestamp == null) {
      return new DateTime.now();
    }
    return new DateTime.fromMillisecondsSinceEpoch(1000*timestamp, isUtc: true);
}

  static List<FechaLanzamiento> listFromMapList(List<dynamic> mapList) {
    if (mapList == null) {
      return [];
    }

    return mapList.map((m) => fromMap(m)).toList();
  }
  
}