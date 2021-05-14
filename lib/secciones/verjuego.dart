import 'dart:ui';

import 'package:SearchToPlay/modelos/fechalanzamiento.dart';
import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/modelos/video.dart';
import 'package:SearchToPlay/secciones/valoraciones.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/widgets/bottomsheet.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class VerJuegoPage extends StatefulWidget{

  final Juego juego;
  final FirebaseService fs;
  final IGDBService igdbservice;

  VerJuegoPage(this.juego, this.fs, this.igdbservice);

  @override
  _VerJuegoPageState createState() => new _VerJuegoPageState();

}

class _VerJuegoPageState extends State<VerJuegoPage> with TickerProviderStateMixin{

  final GoogleTranslator traductor = GoogleTranslator();

  bool _meGusta, _completado, _valorado, _btnSwitch;
  FechaLanzamiento _fechaSeleccionada;
  Plataforma _plataformaSeleccionada;
  List<FechaLanzamiento> _fechasLanzamiento;
  List<bool> _selecciones;
  List<String> _capturas;
  String _region, _descripcionEng, _descripcionEsp;
  double _nota, _notaMedia;

  void initState(){
    super.initState();
    _meGusta = false;
    _completado = false;
    _valorado = false;
    _btnSwitch = false;
    _comprobarMeGusta();
    _comprobarCompletado();
    _comprobarValorado();
    _region = "";
    _descripcionEng = widget.juego.descripcion ?? "No disponible";
    _descripcionEsp = "No disponible";
    _traducirDesc();
    _capturas = widget.igdbservice.getScreenshotFromGame(widget.juego);
    _getFechas();
    _getMediaValorado();
  }

  Widget build(BuildContext context){
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(
          children: <Widget>[
            _header(context),
            _buttons(),
            Divider(color: Colors.grey),
            _fechaLanzamiento(),
            _generos(context),
            _descripcion(context),
            _mediaImagen(context),
            _mediaVideo(context),
            //_similares();
          ],
        )
      ),
    );
  }

  Widget _header(BuildContext context){
    return new Container(
      height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height - 420 : MediaQuery.of(context).size.height,
      child: new Stack(
        children: <Widget>[
          new Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF9BFBC1), Color(0xFFF3F9A7)],
                tileMode: TileMode.clamp,
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.0, 1.0],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            heightFactor: 3.5,
            child: _contenido(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: widget.juego.websites != null ?  Container(
            child: IconButton(
              tooltip: "Webs relacionadas con este juego",
              icon: Icon(
                Icons.add_circle,
                color: Colors.black87,
              ),
              onPressed: (){
                _mostrarWebs(context);
              },
              splashColor: Colors.black,
            )
          ) : Container(),
          ),
          _appBar(),
        ],
      )
    );
  }

  Widget _contenido(){
    return new Container(
      margin: EdgeInsets.only(top: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Hero(
            tag: widget.juego.id.toString(),
            child: Container(
              height: 190,
              width: 200,
              child: widget.juego.cover != null ? CachedNetworkImage(
                imageUrl: widget.igdbservice.getURLCoverFromGame(widget.juego),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  height: 190,
                  width: 200,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: imageProvider
                    ),
                  ),
                ),
              ) : 
              Container(
                alignment: Alignment.center,
                child: Text("[Imagen no disponible]", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black
                  ),
                  )
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ), 
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 80,
                      child: Text(widget.juego.nombre,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: widget.juego.companias != null && widget.juego.companias.length > 0 ? Text(widget.juego.companias[0],
                        style: TextStyle(
                          color: Colors.black54
                        ),
                      ) : Container(),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _appBar() {
    return new Align(
      heightFactor: 0.35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, bottom: 30),
            child: IconButton(
              tooltip: "Volver atrás",
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
              ),
              onPressed: (){
                Navigator.pop(context);
              },
              splashColor: Colors.black,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _fechaSeleccionada != null && _fechaSeleccionada.date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch ? Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: IconButton(
                tooltip: "Añadir al calendario",
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                onPressed: (){
                  _anadirACalendario();
                },
                splashColor: Colors.black,
              ),
            ) : Container(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30, right: 15),
            child: IconButton(
              tooltip: "Compartir en redes sociales",
              icon: Icon(
                Icons.share,
                color: Colors.black87,
              ),
              onPressed: (){
                if(_fechaSeleccionada.date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch){
                  Share.share("Estoy viendo información acerca de "+widget.juego.nombre+" en SearchToPlay, que se lanza el "+_fechaSeleccionada.legible+" en "+_plataformaSeleccionada.abreviacion);
                }else{
                  Share.share("Estoy viendo información acerca de "+widget.juego.nombre+" en SearchToPlay, que se lanzó el "+_fechaSeleccionada.legible+" en "+_plataformaSeleccionada.abreviacion);
                }
              },
              splashColor: Colors.black,
            )
          ),
        ],
      )
    );
  }

  Widget _buttons(){
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 25.0, bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: LikeButton(
              size: 40,
              likeBuilder: (isLiked){
                return Icon(
                  Icons.favorite,
                  color: _meGusta ? Colors.pink : Colors.grey,
                );
              },
              circleColor: CircleColor(start: Color(0xffd81b60), end: Color(0xfff06292)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xffd81b60),
                dotSecondaryColor: Color(0xfff06292),
              ),
              onTap: _setMeGusta,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: LikeButton(
              size: 40,
              likeBuilder: (isFinish){
                return Icon(
                  Icons.check,
                  color: _completado ? Colors.green : Colors.grey,
                );
              },
              circleColor: CircleColor(start: Color(0xff43a047), end: Color(0xff81c784)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xff43a047),
                dotSecondaryColor: Color(0xff81c784),
              ),
              onTap: _setCompletado,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: _nota != null ? 19 : 20, bottom: 8, left: 8, right: 8),
            child: Column(
              children: [
                LikeButton(
                  size: 40,
                  likeBuilder: (isEvaluated){
                    return Icon(
                      Icons.videogame_asset,
                      color: _valorado ? Colors.yellow : Colors.grey,
                    );
                  },
                  circleColor: CircleColor(start: Color(0xfffdd835), end: Color(0xfffff176)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xfffdd835),
                    dotSecondaryColor: Color(0xfffff176),
                  ),
                  onTap: _setValorado,
                ),
                Text(_nota != null ? _nota.toString() : ""),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircularPercentIndicator(
              radius: 70,
              lineWidth: 6.5,
              percent: widget.juego.notaCritica != null ? widget.juego.notaCritica / 100 : 0.0,
              circularStrokeCap: CircularStrokeCap.round,
              footer: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("Crítica",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              center: Text(widget.juego.notaCritica != null ? (widget.juego.notaCritica / 10).toStringAsFixed(2) : "N/A"),
              progressColor: Colors.yellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: GestureDetector(
              child: CircularPercentIndicator(
                radius: 70,
                lineWidth: 6.5,
                percent: _notaMedia != null ? _notaMedia / 10 : 0.0,
                circularStrokeCap: CircularStrokeCap.round,
                footer: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text("Usuarios",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                center: Text(_notaMedia != null ? _notaMedia.toStringAsFixed(2) : "N/A"),
                progressColor: HexColor("#0638EA"),
              ),
              onTap: () {
                if(_notaMedia != null){
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => ValoracionesPage(widget.juego.id.toString(), widget.fs)));
                }else{
                  Fluttertoast.showToast(msg: "No hay valoraciones disponibles");
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _fechaLanzamiento(){
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _fechaSeleccionada != null ? Text("📅  "+_fechaSeleccionada.legible + " " +  _region,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                ) : Text("📅  No disponible"),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _fechasLanzamiento != null ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: CustomToggleButtons(
                borderColor: Colors.grey[850],
                selectedBorderColor: HexColor('#4fc522'),
                children: _fechasLanzamiento.map((value){
                  if(value.plataforma.abreviacion != null){
                    return Text(value.plataforma.abreviacion);
                  }else if(value.plataforma.alternativo != null){
                    return Text(value.plataforma.alternativo);
                  }else{
                    return Text(value.plataforma.nombre);
                  }
                }).toList(),
                isSelected: _selecciones,
                onPressed: (int index){
                  for(int i = 0; i < _selecciones.length; i++){
                    setState(() {
                      if(i == index){
                        _selecciones[i] = true;
                        _plataformaSeleccionada = _fechasLanzamiento[i].plataforma;
                      }else{
                        _selecciones[i] = false;
                      }
                    });
                  }
                  _cambiarFecha();
                },
              ),
            ) : Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget _generos(BuildContext context){
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Géneros",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1.color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 30,
            margin: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.juego.generos.length,
                      itemBuilder: (context, index){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: Theme.of(context).textTheme.headline1.color)
                          ),
                          child: Text(widget.juego.generos[index].nombre,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline1.color,
                              fontSize: 12
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripcion(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      padding: EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: MediaQuery.of(context).size.width / 2.9),
              Text("Descripción",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(flex: 1),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _btnSwitch ? Tooltip(
                  message: "Traducir",
                  child: TextButton(
                    child: Text("🇺🇸"),
                    onPressed: (){
                      setState(() {
                        _btnSwitch = !_btnSwitch;
                      });
                    },
                  ),
                ) : Tooltip(
                  message: "Deshacer traducción",
                  child: TextButton(
                    child: Text("🇪🇸"),
                    onPressed: (){
                      setState(() {
                        _btnSwitch = !_btnSwitch;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: _btnSwitch ? Container(
              key: Key("esp"),
              child: _descripcionEsp.length <= 75 ? Text(_descripcionEsp,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).textTheme.headline1.color,
                )
              ) : ExpandText(_descripcionEsp,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).textTheme.headline1.color
                ),
              ),
            ) : Container(
              key: Key("eng"), 
              child: _descripcionEng.length <= 75 ? Text(_descripcionEng,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).textTheme.headline1.color,
                )
              ) : ExpandText(_descripcionEng,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'OpenSans',
                  color: Theme.of(context).textTheme.headline1.color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mediaImagen(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Text("Imágenes",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
                color: Theme.of(context).textTheme.headline1.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _capturas.length > 0 ? Container(
            height: MediaQuery.of(context).size.height / 5.5,
            width: MediaQuery.of(context).size.width - 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _capturas.length,
              itemBuilder: (contex, index){
                return _imageCard(context, index, _capturas[index]);
              },
            ),
          ) : Container(
            child: Text("No hay imágenes disponibles",
              textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  Widget _mediaVideo(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("Vídeos",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
                color: Theme.of(context).textTheme.headline1.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          widget.juego.videos.length > 0 ? Container(
            height: MediaQuery.of(context).size.height / 5.5,
            width: MediaQuery.of(context).size.width - 30,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.juego.videos.length,
              itemBuilder: (contex, index){
                return _videoCard(context, widget.juego.videos[index]);
              },
            ),
          ) : Container(
            child: Text("No hay vídeos disponibles",
              textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  Widget _imageCard(BuildContext context, int index, String url){
    return GestureDetector(
      child: Hero(
        tag: url,
        child: CachedNetworkImage(                  
          imageUrl: url,
          errorWidget: (context, url, error) => Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            height: 180,
            width: 200,
            margin: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imageProvider
              )
            ),
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (_) => DetallesImagen(index, url)));
      },
    );
  }

  Widget _videoCard(BuildContext context, Video video){
    return new InkWell(
      child: new Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: 'https://img.youtube.com/vi/${video.videoId}/0.jpg',
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              height: 180,
              width: 200,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: imageProvider
                )
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              height: 50,
              width: 200,
              child: Icon(Icons.play_circle_outline, color: Colors.black),
            ),
          )
        ],
      ),
      onTap: () async{
        String url = 'https://youtu.be/${video.videoId}';
        if(await canLaunch(url)){
          await launch(url).then((value) => {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
          });
        }else{
          Fluttertoast.showToast(msg: "No se ha podido abrir este vídeo. Vuelva a intentarlo.");
        }
      },
    );
  }

  void _cambiarFecha(){
    for(int i = 0; i < _fechasLanzamiento.length; i++){
      if(_fechasLanzamiento[i].plataforma.plataformaId == _plataformaSeleccionada.plataformaId){
        setState(() {
          _fechaSeleccionada = _fechasLanzamiento[i];
          if(_fechasLanzamiento[i].region == 1){
            _region = "[🇪🇺]";
          }else{
            _region = "[🌎]";
          }
        });
      }
    }
  }

  Future<bool> _setMeGusta(bool isLiked) async{
    if (_meGusta == false){
      Map<String, String> data = new Map<String, String>();

      data[widget.juego.id.toString()] = widget.juego.nombre;

      int numMeGusta = await widget.fs.addMeGusta(data);

      setState((){
        _meGusta = !_meGusta;
      });

      mostrarBottomSheetMG(context, numMeGusta); // BottomSheet.dart

    }else{
      widget.fs.removeMeGusta(widget.juego.id.toString());
      setState(() {
        _meGusta = !_meGusta;
      });
    }

    return _meGusta;

  }

  void _comprobarMeGusta() async{
    widget.fs.comprobarMeGusta(widget.juego.id.toString()).then((value) {
      setState((){
        _meGusta = value;
      });
    });
  }

  Future<bool> _setCompletado(bool isLiked) async{
    if (_completado == false){
      Map<String, String> data = new Map<String, String>();

      data[widget.juego.id.toString()] = widget.juego.nombre;

      int numCompletado = await widget.fs.addCompletado(data);

      setState((){
        _completado = !_completado;
      });

      mostrarBottomSheetCompletados(context, numCompletado); // BottomSheet.dart

    }else{
      widget.fs.removeCompletado(widget.juego.id.toString());
      setState(() {
        _completado = !_completado;
      });
    }

    return _completado;

  }

  void _comprobarCompletado() async{
    widget.fs.comprobarCompletado(widget.juego.id.toString()).then((value) {
      setState((){
        _completado = value;
      });
    });
  }

  Future<bool> _setValorado(bool isEvaluated) async{

    _dialogValorar(context);

    return _valorado;

  }

  void _comprobarValorado() async{
    bool _tempValorado = await widget.fs.comprobarValorado(widget.juego.id.toString());

    if(_tempValorado){
      String tempNota = await widget.fs.getNotaValorado(widget.juego.id.toString());
      if(tempNota != ""){
        setState(() {
          _nota = double.parse(tempNota);
        });
      }
    }
    setState(() {
      _valorado = _tempValorado;
    });

  }

  void _getMediaValorado() async{
    double _tempNota = await widget.fs.getMediaValorado(widget.juego.id.toString());

    if(_tempNota != null){
      setState(() {
        _notaMedia = _tempNota;
      });
    }
  }

  void _getFechas() async{
    List _tempFechas = await widget.igdbservice.recuperarFecha(widget.juego.id.toString());
    if(_tempFechas.isNotEmpty){
      setState(() {
        _fechasLanzamiento = _tempFechas;
        _fechaSeleccionada = _tempFechas.first;
        _plataformaSeleccionada = _tempFechas.first.plataforma;
        if(_tempFechas.first.region == 1){
          _region = "[🇪🇺]";
        }else{
          _region = "[🌎]";
        }
        _selecciones = List.generate(
          _tempFechas.length, (int index){
            if(index == 0){
              return true;
            }
            return false;
          }
        );
      });
    }
  }

  void _anadirACalendario(){
    final Event event = Event(
      title: 'Lanzamiento '+ widget.juego.nombre,
      description: '¡Hoy se lanza '+widget.juego.nombre+' al mercado! Lo anotaré para no olvidarme...',
      startDate: _fechaSeleccionada.date,
      endDate: _fechaSeleccionada.date,
      allDay: true,
    );

    Add2Calendar.addEvent2Cal(event);
  }

  void _traducirDesc() async{
    if(_descripcionEng != null){
      String tempDesc = (await traductor.translate(_descripcionEng, to: 'es')).toString();
      setState(() {
        _descripcionEsp = tempDesc ?? "No disponible";
      });
    }
  }

  void _dialogValorar(BuildContext context){
    double _tempNotaDialog; 

    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          title: new Text("Tu valoración",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
          content: Container(
            height: 128,
            child: Column(
              children: [
                Text("Añade tu valoración para "+widget.juego.nombre,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: RatingBar.builder(
                    glowColor: Colors.transparent,
                    initialRating: _nota ?? 0,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 10,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.videogame_asset,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _tempNotaDialog = rating;
                    },
                  ),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cerrar",
                style: TextStyle(
                  color: Theme.of(context).textTheme.subtitle1.color
                ),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("Enviar valoración",
                style: TextStyle(
                  color: Theme.of(context).buttonColor,
                ),
              ),
              onPressed: (){
                widget.fs.addValorado(widget.juego.id.toString(), _tempNotaDialog.toString());
                setState((){
                  _nota = _tempNotaDialog;
                  _valorado = true;
                });
                widget.fs.getMediaValorado(widget.juego.id.toString()).then((value) => {
                  if(value != null){
                    setState(() {
                      _notaMedia = value;
                    })
                  }
                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  void _mostrarWebs(BuildContext context){
    showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          title: new Text("Más acerca de este juego",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.headline1.color,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: widget.juego.websites.length,
              itemBuilder: (context, index){
                String nombre, icon;
                switch(widget.juego.websites[index].categoria){
                  case 1:
                    icon = "assets/icon/oficial.png";
                    nombre = "Web oficial";
                  break;
                  case 2:
                    icon = "assets/icon/wikia.png";
                    nombre = "Wikia";
                    break;
                  case 3:
                    icon = "assets/icon/wikipedia.png";
                    nombre = "Wikipedia";
                    break;
                  case 4:
                    icon = "assets/icon/facebook.png";
                    nombre = "Facebook";
                    break;
                  case 5:
                    icon = "assets/icon/twitter.png";
                    nombre = "Twitter";
                    break;
                  case 6:
                    icon = "assets/icon/twitch.png";
                    nombre = "Twitch";
                    break;
                  case 8:
                    icon = "assets/icon/instagram.png";
                    nombre = "Instagram";
                    break;
                  case 9:
                    icon = "assets/icon/youtube.png";
                    nombre = "Youtube";
                    break;
                  case 10:
                    icon = "assets/icon/apple.png";
                    nombre = "App Store (iPhone)";
                    break;
                  case 11:
                    icon = "assets/icon/apple.png";
                    nombre = "App Store (iPad)";
                    break;
                  case 12:
                    icon = "assets/icon/android.png";
                    nombre = "Google Play Store";
                    break;
                  case 13:
                    icon = "assets/icon/steam.png";
                    nombre = "Steam";
                    break;
                  case 14:
                    icon = "assets/icon/reddit.png";
                    nombre = "Reddit";
                    break;
                  case 15:
                    icon = "assets/icon/itch.png";
                    nombre = "Itch.io";
                    break;
                  case 16:
                    icon = "assets/icon/epicgames.png";
                    nombre = "Epic Games Store";
                    break;
                  case 17:
                    icon = "assets/icon/gog.png";
                    nombre = "GOG";
                    break;
                  case 18:
                    icon = "assets/icon/discord.png";
                    nombre = "Discord";
                    break;
                }
                return Card(
                  elevation: 8,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[600] : Colors.grey[300],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              width: 1,
                              color: Colors.grey
                            )
                          )
                        ),
                        child: Image(
                          image: AssetImage(icon),
                          width: 50,
                          height: 50,
                        ),
                      ),
                      title: Text(nombre,
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          color: Theme.of(context).textTheme.headline1.color,
                        ),),
                      onTap: () async{
                        if( await canLaunch(widget.juego.websites[index].url)){
                          await launch(widget.juego.websites[index].url).then((value) => {
                            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
                          });
                        }else{
                          Fluttertoast.showToast(msg: "No se ha podido acceder a esta página. Vuelva a intentarlo.");
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            new Row(
              children: <Widget>[
                new TextButton(
                  child: new Text("Cerrar",
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                    )
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      }
    );
  }


}

class DetallesImagen extends StatelessWidget {

  final String url;
  final int index;
  DetallesImagen(this.index, this.url);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return WillPopScope(
      onWillPop: (){
        if(MediaQuery.of(context).orientation == Orientation.landscape){
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: GestureDetector(
          child: Center(
            child: Hero(
              tag: index,
              child: CachedNetworkImage(                  
                imageUrl: url,
                errorWidget: (context, urlError, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider) => Container(
                  height: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.height : double.infinity,
                  width: MediaQuery.of(context).orientation == Orientation.portrait ? MediaQuery.of(context).size.width : double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider
                    )
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
