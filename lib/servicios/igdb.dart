import 'package:SearchToPlay/modelos/fechalanzamiento.dart';
import 'package:SearchToPlay/modelos/genero.dart';
import 'package:SearchToPlay/modelos/imagen.dart';
import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igdb_client/igdb_client.dart';


class IGDBService {
  FirebaseService _fs;
  var _token;
  var _client;
  var _accessToken;
  String _clientId;
  String _clientSecret;
  List<String> _gameFields = ['name', 'category', 'summary', 'aggregated_rating', 'genres.*', 'involved_companies.company.name', 'dlcs', 'expanded_games', 'expansions', 'ports', 'remakes', 'remasters', 'involved_companies.*', 'release_dates.*', 'release_dates.platform.*', 'websites.category', 'websites.url', 'screenshots.*', 'videos.*', 'cover.*'];

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

  Future<List<Juego>> recuperarTitulo(String titulo) async {
    await _comprobarToken();
    IGDBResponse gamesResponse = await _client.games(new IGDBRequestParameters(
        search: titulo, 
        fields: _gameFields, 
        limit: 100,
    ));
    if(gamesResponse.isSuccess()){
      return gamesResponse.data.map((e) => Juego.fromMap(e)).toList();
    }else{
      return [];
    }
  }

  Future<List<Juego>> recuperarTop() async{
    await _comprobarToken();
    IGDBResponse gamesResponse = await _client.games(new IGDBRequestParameters(
      fields: _gameFields,
      filters: 'aggregated_rating != null & aggregated_rating_count > 10', 
      order: 'aggregated_rating desc',
      limit: 50,
    ));
    if(gamesResponse.isSuccess()){
      return gamesResponse.data.map((e) => Juego.fromMap(e)).toList();
    }else{
      return [];
    }
  }

  Future<List<Juego>> recuperarMes() async {
    await _comprobarToken();
    int mesActual = DateTime.now().month;
    int anioActual = DateTime.now().year;
    IGDBResponse gamesResponse = await _client.games(new IGDBRequestParameters(
      fields: _gameFields,
      filters: 'release_dates.m = '+mesActual.toString()+' & release_dates.y = '+anioActual.toString()+' & (release_dates.region = 1 | release_dates.region = 8)', 
      order: 'release_dates.date asc',
      limit: 150,
    ));
    if(gamesResponse.isSuccess()){
      return gamesResponse.data.map((e) => Juego.fromMap(e)).toList();
    }else{
      return [];
    }
  }

  Future<List<Plataforma>> recuperarPlataformas() async{
    await _comprobarToken();
    IGDBResponse plataformasResponse = await _client.platforms(new IGDBRequestParameters(
      fields: ['name', 'abbreviation'],
      order: 'name asc',
      limit: 190
    ));
    if(plataformasResponse.isSuccess()){
      return plataformasResponse.data.map((e) => Plataforma.fromMap(e)).toList();
    }else{
      return [];
    }
  }

  Future<List<Genero>> recuperarGeneros() async{
    await _comprobarToken();
    IGDBResponse generosResponse = await _client.genres(new IGDBRequestParameters(
      fields: ['name'],
      order: 'name asc',
      limit: 50
    ));
    if(generosResponse.isSuccess()){
      return generosResponse.data.map((e) => Genero.fromMap(e)).toList();
    }else{
      return [];
    }
  }

  Future<List<FechaLanzamiento>> recuperarFecha(String id) async{
    await _comprobarToken();
    IGDBResponse fechasResponse = await _client.releaseDates(new IGDBRequestParameters(
      fields: ['date', 'y', 'm', 'human', 'region', 'platform.*'],
      filters: 'game = '+id+' & (region = 1 | region = 8)',
      order: 'date asc',
    ));
    if(fechasResponse.isSuccess()){
      return fechasResponse.data.map((e) => FechaLanzamiento.fromMap(e)).toList();
    }else{
      return [];
    }
  }

  Future<List<Juego>> recuperarAvanzado(String orden, int generoId, int plataformaId, int anio, int nota, int mes) async{
    await _comprobarToken();
    String order;
    IGDBResponse busquedaResponse;
    switch (orden) {
      case 'Fecha (asc)':
        order = 'first_release_date asc';
        break;
      case 'Fecha (desc)':
        order = 'first_release_date desc';
        break;
      case 'Nombre (asc)':
        order = 'name asc';
        break;
      case 'Nombre (desc)':
        order = 'name desc';
        break;
      case 'Nota crítica (asc)':
        order = 'aggregated_rating asc';
        break;
      case 'Nota crítica (desc)':
        order = 'aggregated_rating desc';
        break;
    }

    if(mes == 0){
      if(generoId == 0){
        busquedaResponse = await _client.games(new IGDBRequestParameters(
          fields: _gameFields,
          order: order,
          filters: "release_dates.platform = ("+plataformaId.toString()+") & release_dates.y =" + anio.toString() + " & (aggregated_rating >=" + nota.toString() + " | aggregated_rating = null) & (aggregated_rating_count > 5 | aggregated_rating_count = null);",
          limit: 50,
        ));
      }else{
        busquedaResponse = await _client.games(new IGDBRequestParameters(
          fields: _gameFields,
          order: order,
          filters: "genres = ("+generoId.toString()+ ") & release_dates.platform = ("+plataformaId.toString()+") & release_dates.y =" + anio.toString() + " & (aggregated_rating >=" + nota.toString() + " | aggregated_rating = null) & (aggregated_rating_count > 5 | aggregated_rating_count = null);",
          limit: 50,
        ));
      }
    }else{
      if(generoId == 0){
        busquedaResponse = await _client.games(new IGDBRequestParameters(
          fields: _gameFields,
          order: order,
          filters: "release_dates.platform = ("+plataformaId.toString()+") & release_dates.m ="+ mes.toString() +" & release_dates.y =" + anio.toString() + " & (aggregated_rating >=" + nota.toString() + " | aggregated_rating = null) & (aggregated_rating_count > 5 | aggregated_rating_count = null);",
          limit: 50,
        )); 
      }else{
        busquedaResponse = await _client.games(new IGDBRequestParameters(
          fields: _gameFields,
          order: order,
          filters: "genres = ("+generoId.toString()+ ") & release_dates.platform = ("+plataformaId.toString()+") & release_dates.m ="+ mes.toString() +" & release_dates.y =" + anio.toString() + " & (aggregated_rating >=" + nota.toString() + " | aggregated_rating = null) & (aggregated_rating_count > 5 | aggregated_rating_count = null);",
          limit: 50,
        )); 
      }     
    }

    if(busquedaResponse.isSuccess()){
      return busquedaResponse.data.map((e) => Juego.fromMap(e)).toList();
    }else{
      return [];
    }
  }

  Future<List<Juego>> recuperarID(List<int> idJuego) async{
    await _comprobarToken();
    if(idJuego.isNotEmpty){
      IGDBResponse gameIdResponse = await _client.games(new IGDBRequestParameters(
        fields: _gameFields,
        ids: idJuego,
      ));
      if (gameIdResponse.isSuccess()){
        return gameIdResponse.data.map((e) => Juego.fromMap(e)).toList();
      }
    }

    return [];

  }
  String getURLCoverFromGame(Juego juego){
    return getImageURL(juego.cover);
  }

  List<String> getScreenshotFromGame(Juego juego){
    List<String> imageList = [];

    juego.capturas.forEach((element) {
      imageList.add(getImageURL(element));
    });
    return imageList;
  }

  String getImageURL(Imagen imagen){
    if(imagen == null || imagen.imageId == null){
      return null;
    }

    return IGDBHelpers.getImageUrl(imagen.imageId, IGDBImageSizes.HD720P);
  }
}
