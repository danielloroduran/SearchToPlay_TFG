import 'package:SearchToPlay/modelos/imagen.dart';
import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igdb_client/igdb_client.dart';
import 'dart:convert';
import 'package:date_utils/date_utils.dart';


class IGDBService {
  FirebaseService _fs;
  var _token;
  var _client;
  var _accessToken;
  String _clientId;
  String _clientSecret;

  IGDBService(this._fs);

  void _comprobarToken() async {
    DocumentSnapshot _clientKeys = await _fs.getKey();

    _clientId = _clientKeys['client_id'];
    _clientSecret = _clientKeys['secret'];

    int timeNowSec = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    DocumentSnapshot timeTokenSnapshot = await _fs.getAppToken();
    int timeToken = timeTokenSnapshot['timeToExpire'];

    if (timeToken - timeNowSec < 432000) {
      await actualizarToken();
    } else {
      await recuperarToken();
    }

    if (_client == null) {
      _client = new IGDBClient("TEST_SEARCH_TO_PLAY", _clientId, _accessToken);
    }
  }

  void actualizarToken() async {
    // Nuevo token
    _token = await IGDBClient.getOauthToken(_clientId, _clientSecret);

    _accessToken = _token.accessToken;
    // Guardo el token en Firestore
    int _fechaExpiracion = ((DateTime.now().millisecondsSinceEpoch ~/ 1000) + _token.expiresIn);

    Map<String, dynamic> _tokentoFS = {
      "accessToken": _token.accessToken,
      "expiresIn": _token.expiresIn,
      "timeToExpire": _fechaExpiracion
    };

    await _fs.updateAppToken(_tokentoFS);
  }

  void recuperarToken() async {
    DocumentSnapshot _accessTokenSnapshot = await _fs.getAppToken();
    _accessToken = _accessTokenSnapshot['accessToken'];
  }

  // Recuperar juegos por título
  void recuperarTitulo(String titulo) async {
    await _comprobarToken();
    var gamesResponse = await _client.games(new IGDBRequestParameters(
        search: titulo, fields: ['name', 'summary'], 
        limit: 100));
    _printResponse(gamesResponse);
  }

  Future<List<Juego>> recuperarTop() async{
    await _comprobarToken();
    IGDBResponse gamesResponse = await _client.games(new IGDBRequestParameters(
      fields: ['name', 'summary', 'aggregated_rating', 'genres', 'platforms', 'release_dates', 'screenshots', 'videos', 'cover'],
      filters: 'aggregated_rating != null & aggregated_rating_count > 10', 
      order: 'aggregated_rating desc',
      limit: 20,
    ));
    if(gamesResponse.isSuccess()){
      return gamesResponse.data.map((e) => Juego.fromMap(e)).toList();
    }
    //_printResponse(gamesResponse);
  }

  Future<List<Juego>> recuperarMes() async {
    await _comprobarToken();
    int mesActual = DateTime.now().month;
    int anioActual = DateTime.now().year;
    int tiempoPrimerDia = DateTime(anioActual, mesActual, 1, 0, 0).millisecondsSinceEpoch~/1000;
    int tiempoUltimoDia = DateTime(anioActual, mesActual, Utils.lastDayOfMonth(DateTime(anioActual, mesActual)).day, 23, 59).millisecondsSinceEpoch~/1000;
    IGDBResponse gamesResponse = await _client.games(new IGDBRequestParameters(
      fields: ['name', 'summary', 'aggregated_rating', 'genres', 'platforms', 'release_dates', 'screenshots', 'videos', 'cover'],
      filters: 'first_release_date > '+tiempoPrimerDia.toString()+' & first_release_date < '+tiempoUltimoDia.toString(), 
      order: 'first_release_date asc',
      limit: 100,
    ));
    if(gamesResponse.isSuccess()){
      return gamesResponse.data.map((e) => Juego.fromMap(e)).toList();
    }    
  }

  Future<Imagen> recuperarCovers(int id) async{
    await _comprobarToken();
    IGDBResponse coversResponse = await _client.covers(new IGDBRequestParameters(
      ids: [id]
    ));
    List<Imagen> res = coversResponse.data.map((e) => Imagen.fromMap(e)).toList();
    return res[0];
  }

  void recuperarID() async{
    await _comprobarToken();
    var gameIdResponse = await _client.games(new IGDBRequestParameters(
      ids: [43378, 115276],
    ));
    _printResponse(gameIdResponse);
  }
  
  void recuperarVideo() async{
    await _comprobarToken();
    var gameVideoReponse = await _client.gameVideos(new IGDBRequestParameters(
      ids: [24906],
    ));
    _printResponse(gameVideoReponse);
  }
  
  void _printResponse(IGDBResponse resp) {
    print(resp.toMap().length);
    print(IGDBHelpers.getPrettyStringFromMap(resp.toMap()));
  }
}
