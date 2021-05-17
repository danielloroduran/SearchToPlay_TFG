import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/secciones/informacion.dart';
import 'package:SearchToPlay/secciones/perfil.dart';
import 'package:SearchToPlay/secciones/verjuego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/storageservice.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InicioPage extends StatefulWidget{

  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;
  final StorageService ss;

  InicioPage(this.us, this.fs, this.igdbservice, this.ss);

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
      height: 243.h,
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
      height: 243.h,
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
    return GestureDetector(
      child: Hero(
        tag: juego.id.toString(),
        child: Container(
          height: 150,
          width: 200,
          child: juego.cover != null ? CachedNetworkImage(
            imageUrl: widget.igdbservice.getURLCoverFromGame(juego),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              height: 150,
              width: 200,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: imageProvider
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
          ) : 
          Container(
            alignment: Alignment.center,
            child: Text(juego.nombre +"\n [Imagen no disponible]", textAlign: TextAlign.center,)
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context) => VerJuegoPage(juego, widget.fs, widget.igdbservice)));
      },
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