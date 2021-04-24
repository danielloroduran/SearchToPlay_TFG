import 'dart:ui';

import 'package:SearchToPlay/modelos/fechalanzamiento.dart';
import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:like_button/like_button.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VerJuegoPage extends StatefulWidget{

  final Juego juego;
  final FirebaseService fs;
  final IGDBService igdbservice;

  VerJuegoPage(this.juego, this.fs, this.igdbservice);

  @override
  VerJuegoPageState createState() => new VerJuegoPageState();

}

class VerJuegoPageState extends State<VerJuegoPage> with TickerProviderStateMixin{

  bool _meGusta, _finalizado, _puntuado;
  FechaLanzamiento _fechaSeleccionada;
  Plataforma _plataformaSeleccionada;
  List<FechaLanzamiento> _fechasLanzamiento;
  List<bool> _selecciones;

  void initState(){
    super.initState();
    _meGusta = true;
    _finalizado = false;
    _puntuado = false;
    _getFechas();
  }

  Widget build(BuildContext context){
    return SafeArea(
      top: true,
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView(
          children: <Widget>[
            _header(),
            _buttons(),
            _fechaLanzamiento(),
            _descripcion(context),
            _media(context),
            //_similares();
          ],
        )
      ),
    );
  }

  Widget _header(){
    return new Container(
      height: 330,
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
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: widget.juego.cover == null ? null : DecorationImage(
                  image: NetworkImage(widget.igdbservice.getURLCoverFromGame(widget.juego)),
                  fit: BoxFit.fitHeight
                )
              ),
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.juego.nombre,
                    maxLines: 2,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal
                      ),
                    ),
                    /*Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text("Nintendo",
                        style: TextStyle(
                          color: Colors.black87.withOpacity(0.3)
                        ),
                      ),
                    )*/
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
          _fechaSeleccionada != null && _fechaSeleccionada.date.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch ? Padding(
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
          Padding(
            padding: EdgeInsets.only(right: 15, bottom: 30),
            child: IconButton(
              tooltip: "Compartir en redes sociales",
              icon: Icon(
                Icons.share,
                color: Colors.black87,
              ),
              onPressed: (){

              },
              splashColor: Colors.black,
            )
          )
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
              onTap: _comprobarMeGusta,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: LikeButton(
              size: 40,
              likeBuilder: (isFinish){
                return Icon(
                  Icons.check,
                  color: _finalizado ? Colors.green : Colors.grey,
                );
              },
              circleColor: CircleColor(start: Color(0xff43a047), end: Color(0xff81c784)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xff43a047),
                dotSecondaryColor: Color(0xff81c784),
              ),
              onTap: _comprobarSave,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: LikeButton(
              size: 40,
              likeBuilder: (isEvaluated){
                return Icon(
                  Icons.star,
                  color: _puntuado ? Colors.yellow : Colors.grey,
                );
              },
              circleColor: CircleColor(start: Color(0xfffdd835), end: Color(0xfffff176)),
              bubblesColor: BubblesColor(
                dotPrimaryColor: Color(0xfffdd835),
                dotSecondaryColor: Color(0xfffff176),
              ),
              onTap: _comprobarPuntuado,
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
              percent: 0.8,
              footer: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("Crítica",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              center: Text("50"),
              progressColor: Colors.yellow,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: CircularPercentIndicator(
              radius: 70,
              lineWidth: 6.5,
              percent: 0.8,
              footer: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text("Usuarios",
                  style: TextStyle(
                    fontFamily: 'OpenSans'
                  ),
                ),
              ),
              center: Text("82"),
              progressColor: HexColor("#0638EA"),
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
            padding: const EdgeInsets.only(left: 17, bottom: 10),
            child: Row(
              children: <Widget>[
                Text("📅  ",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ),
                _fechaSeleccionada != null ? Text(_fechaSeleccionada.legible,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'OpenSans',
                    color: Theme.of(context).textTheme.headline6.color,
                  ),
                ) : Text(""),
              ],
            ),
          ),
          _fechasLanzamiento != null ? ToggleButtons(
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
          ) : Container(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(),
          )
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
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text("Descripción",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
                color: Theme.of(context).textTheme.headline6.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          widget.juego.descripcion.length <= 75 ? Text(widget.juego.descripcion,
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'OpenSans',
              color: Theme.of(context).textTheme.headline6.color
            ),
          ) : 
          ExpandText(
            widget.juego.descripcion,
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'OpenSans',
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _media(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text("Imágenes y vídeos",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
                color: Theme.of(context).textTheme.headline6.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _cambiarFecha(){
    for(int i = 0; i < _fechasLanzamiento.length; i++){
      if(_fechasLanzamiento[i].plataforma.plataformaId == _plataformaSeleccionada.plataformaId){
        setState(() {
          _fechaSeleccionada = _fechasLanzamiento[i];
        });
      }
    }
  }

  Future<bool> _comprobarMeGusta(bool isLiked) async{
    setState(() {
      print("Gustado");
      _meGusta = !_meGusta;
    });
    return _meGusta;
  }

  Future<bool> _comprobarSave(bool isSave) async{
    setState(() {
      print("Finalizado");
      _finalizado = !_finalizado;
    });
    return _finalizado;
  }

  Future<bool> _comprobarPuntuado(bool isEvaluated) async{
    setState(() {
      _puntuado = !_puntuado;
    });

    return _puntuado;
  }

  void _getFechas() async{
    List tempFechas = await widget.igdbservice.recuperarFecha(widget.juego.id.toString());
    if(tempFechas.isNotEmpty){
      setState(() {
        _fechasLanzamiento = tempFechas;
        _fechaSeleccionada = tempFechas.first;
        _selecciones = List.generate(
          tempFechas.length, (int index){
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
      description: '¡Hoy se lanza '+widget.juego.nombre+' al mercado!',
      startDate: _fechaSeleccionada.date,
      endDate: _fechaSeleccionada.date,
      allDay: true,
    );

    Add2Calendar.addEvent2Cal(event);
  }

}
