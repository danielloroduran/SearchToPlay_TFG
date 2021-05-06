import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/secciones/perfil.dart';
import 'package:SearchToPlay/secciones/verjuego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget{

  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;

  InicioPage(this.us, this.fs, this.igdbservice);

  @override
  _InicioPageState createState() => new _InicioPageState();

}

class _InicioPageState extends State<InicioPage> with AutomaticKeepAliveClientMixin<InicioPage>{

  List _listJuegosTop;
  List _listJuegosMes;
  void initState(){
    super.initState();
      _getJuegosTop();
      _getJuegosMes();
  }

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("Inicio",
        style: TextStyle(
          fontFamily: 'OpenSans',
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
                Navigator.push(context, CupertinoPageRoute(builder: (context) => PerfilPage(widget.us, widget.igdbservice, widget.fs)));            
              },
            ),
        actions: [
          IconButton(
            tooltip: "Información",
            icon: Icon(Icons.info),
            onPressed: (){

            },
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 27, top: 30),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Lanzamientos del mes 📅",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 29,
                    color: Theme.of(context).textTheme.headline1.color
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: _juegosMes(),
            ),
            Row(
              children: [
                Text("Los más populares 🔥",
                  style: TextStyle(
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500,
                    fontSize: 29,
                    color: Theme.of(context).textTheme.headline1.color
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: _juegosTop()
            ),
          ],
        )
      ),      
    );
  }

  Widget _juegosMes(){
    return new Container(
      height: MediaQuery.of(context).size.height / 3.4,
      child: _listJuegosMes == null ? Center(child: CircularProgressIndicator()) : ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _listJuegosMes.length,
        itemBuilder: (context, index){
          return _juegoCard(_listJuegosMes[index]);
        }   
      ),
    );
  }

  Widget _juegosTop(){
    return new Container(
      height: MediaQuery.of(context).size.height / 3.4,
      child: _listJuegosTop == null ? Center(child: CircularProgressIndicator()) : ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _listJuegosTop.length,
        itemBuilder: (context, index){
          return _juegoCard(_listJuegosTop[index]);
        }  
      ),
    );
  }

  Widget _juegoCard(Juego juego){
    return Hero(
      tag: juego.id.toString(),
        child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: 150,
        height: 200,
        child: GestureDetector(
          child: juego.cover == null ? Container(
            alignment: Alignment.center,
            child: Text(juego.nombre +"\n [Imagen no disponible]", textAlign: TextAlign.center,)
          ) : null,
          onTap: (){
            Navigator.push(context, CupertinoPageRoute(builder: (context) => VerJuegoPage(juego, widget.fs, widget.igdbservice)));
          },
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: juego.cover == null ? null : DecorationImage(
            image: NetworkImage(widget.igdbservice.getURLCoverFromGame(juego)),
            fit: BoxFit.fitHeight
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(6, 4),
            )
          ]
        ),    
      ),
    );
  }

  void _getJuegosTop() async{
    List tempJuegos = await widget.igdbservice.recuperarTop();

    if(this.mounted){
      setState(() {
        _listJuegosTop = tempJuegos;
      });
    }
  }

  void _getJuegosMes() async{
    List tempJuegos = await widget.igdbservice.recuperarMes();
    if(this.mounted){
      setState(() {
        _listJuegosMes = tempJuegos;
      });
    }
  }

}