import 'package:SearchToPlay/secciones/informacion.dart';
import 'package:SearchToPlay/secciones/perfil.dart';
import 'package:SearchToPlay/secciones/resultados.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/storageservice.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class TopJugonesPage extends StatefulWidget{

  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;
  final StorageService ss;

  TopJugonesPage(this.us, this.fs, this.igdbservice, this.ss);
  @override
  _TopJugonesPageState createState() => new _TopJugonesPageState();
}

class _TopJugonesPageState extends State<TopJugonesPage> {

  Map _mapJugones;

  void initState(){
    super.initState();
    _getJugones();
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("El Top Jugones",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30,
            color: Theme.of(context).textTheme.headline1.color
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
              tooltip: "Perfil",
              icon: Icon(Icons.person_rounded),
              onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context) => PerfilPage(widget.us, widget.igdbservice, widget.fs, widget.ss)));
              },
            ),
        actions: [
          IconButton(
            tooltip: "Información",
            icon: Icon(Icons.info),
            onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context) => InformacionPage()));            
            },
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _mapJugones != null ? Container(
          padding: EdgeInsets.only(left: 30, top: 20, right: 30),
          child: Column(
            children: [
              _resultadosJugones(context),
            ],
          )
        ) : Center(
          child: CircularProgressIndicator(),
        ),
      )
    );
  }

  Widget _resultadosJugones(BuildContext context){
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _mapJugones.length,
        itemBuilder: (context, index){
          String key = _mapJugones.keys.elementAt(index);
          return _userTile(key, _mapJugones[key], index);
        },
      ),
    );
  }

  Widget _userTile(String nombre, List idJuegos, int index){
    Color _backgroundColor;
    String _pathImage;
    switch(index){
      case 0:
        _backgroundColor = HexColor("#FFE077");
        _pathImage = "assets/awards/mando_oro.png";
        break;
      case 1:
        _backgroundColor = HexColor("#CCCCD0");
        _pathImage ="assets/awards/mando_plata.png";
        break;
      case 2:
        _backgroundColor = HexColor("#9c5221");
        _pathImage = "assets/awards/mando_bronce.png";
        break;
      default:
        _backgroundColor = HexColor("#C7F0B7");
        _pathImage = "assets/awards/mando_verde.png";
        break;
    }

    return GestureDetector(
      child: Container(
        height: 140.0,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          children: <Widget>[
            Container(
              height: 110,
              child: _userContent(nombre, idJuegos.length, context),
              margin: EdgeInsets.only(left: 46),
              decoration: BoxDecoration(
                color: _backgroundColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.grey[850],
                    blurRadius: 10,
                    offset: Offset(5.0, 12.0),
                  ),
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.grey[850],
                    blurRadius: 10,
                    offset: Offset(-25.0, 10.0),
                  )
                ]
              ),
            ), 
            Positioned(
              child: Container(
                height: 110,
                width: 110,
                alignment: FractionalOffset.centerLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    bottomLeft: Radius.circular(50),
                  ),
                  image: DecorationImage(
                    image: AssetImage(_pathImage),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        _getJuegos(nombre, idJuegos);
      },
    );
  }

  Widget _userContent(String nombre, int length, BuildContext context){
    return Container(
      margin: EdgeInsets.fromLTRB(76, 16, 16, 16),
      constraints: BoxConstraints.expand(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 4),
          Text(nombre,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Container(height: 10),
          Text(length == 1 ? "¡Ha completado $length juego" : "¡Ha completado $length juegos!",
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  void _getJuegos(String nombre, List idJuegos) async{
    
    List<int> idsInt = [];

    idJuegos.forEach((element) {
      idsInt.add(int.tryParse(element));
    });

    List tempJuegos = await widget.igdbservice.recuperarID(idsInt);

    if(tempJuegos.isNotEmpty){
      Navigator.push(context, CupertinoPageRoute(builder: (context) => ResultadosPage(widget.fs, widget.igdbservice, nombre, tempJuegos)));
    }else{
      Fluttertoast.showToast(msg: "Se ha producido un error en tu petición");
    }

  }

  void _getJugones() async{
    Map tempJugones = await widget.fs.getAllCompletado();

    if(tempJugones.isNotEmpty){
      setState(() {
        _mapJugones = tempJugones;
      });
    }
  }


}