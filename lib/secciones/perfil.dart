import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/secciones/verjuego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget{

  final UserService us;
  final IGDBService igdbservice;
  final FirebaseService fs;

  PerfilPage(this.us, this.igdbservice, this.fs);

  @override
  _PerfilPageState createState() => new _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>{

  User _user;
  List<Juego> _listMeGusta, _listCompletado;

  void initState(){
    super.initState();
    _usuarioActual();
    _getMeGusta();
    _getCompletado();
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _){
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _fotoPerfil(context),
                    SizedBox(height: 24),
                    _infoUsuario(context),
                    SizedBox(height: 24),
                  ]
                )
              )
            ];
          },
          body: Column(
            children: <Widget>[
              TabBar(
                labelColor: Theme.of(context).textTheme.headline1.color,
                tabs: [
                  Tab(
                    text: _listMeGusta != null ? _listMeGusta.length.toString() : "",
                    icon: Icon(Icons.favorite, color: Colors.pink,)
                  ),
                  Tab(
                    text: _listCompletado != null ? _listCompletado.length.toString() : "",
                    icon: Icon(Icons.check, color: Colors.green)
                  ),
                  Tab(
                    text: "8",
                    icon: Icon(Icons.star, color: Colors.yellow)
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _listMeGusta != null && _listMeGusta.length > 0 ? _juegosMeGusta(context) : Container(
                      child: Center(
                        child: _listMeGusta != null && _listMeGusta.length == 0 ? Text("Parece que aún\n no has dado ningún ❤️",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ) : CircularProgressIndicator(),
                        ),
                      ),
                    _listCompletado != null && _listCompletado.length > 0 ? _juegosCompletado(context) : Container(
                      child: Center(
                        child: _listCompletado != null && _listCompletado.length == 0 ? Text("Parece que aún\n no has completado ningún juego",
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ) : CircularProgressIndicator(),
                        ),
                      ),
                    _juegosValorados(context),
                  ],
                )
              )
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.exit_to_app),
        onPressed: (){
          widget.us.cerrarSesion();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        },
      ),
    );
  }

  Widget _fotoPerfil(BuildContext context){
    return Center(
      child: _user?.photoURL != null ? CachedNetworkImage(                  
        imageUrl: _user.photoURL,
        errorWidget: (context, url, error) => Icon(Icons.error),
        imageBuilder: (context, imageProvider) => Container(
          height: 150,
          width: 150,
          margin: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(75),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageProvider
            )
          ),
        ),
      ) : Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(75),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/user_profile_icon.png'),
          )
        ),
      ),
    );
  }

  Widget _infoUsuario(BuildContext context){
    return Column(
      children: [
        Text(_user?.displayName ?? "",
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Theme.of(context).textTheme.headline1.color,
          ),
        ),
        SizedBox(height: 4),
        Text(_user?.email ?? "",
          style: TextStyle(
            color: Theme.of(context).textTheme.subtitle1.color,
          ),
        )
      ],
    );
  }

  Widget _juegosMeGusta(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Expanded(
            child:  GridView.builder(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              physics: ClampingScrollPhysics(),
              
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.90,
                mainAxisSpacing: 4,
                crossAxisSpacing: 10,
              ),
              itemCount: _listMeGusta.length,
              itemBuilder: (context, index){
                return _juegoCard(_listMeGusta[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _juegosCompletado(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Expanded(
            child:  GridView.builder(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              physics: ClampingScrollPhysics(),
              
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.90,
                mainAxisSpacing: 4,
                crossAxisSpacing: 10,
              ),
              itemCount: _listCompletado.length,
              itemBuilder: (context, index){
                return _juegoCard(_listCompletado[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _juegosValorados(BuildContext context){
    return GridView.count(
      padding: EdgeInsets.zero,
      crossAxisCount: 3,
      children: Colors.primaries.map((color) {
        return Container(color: color, height: 150.0);
      }).toList()
    );
  }

  Widget _juegoCard(Juego juego){
    return GestureDetector(
      child: Hero(
        tag: juego.id.toString(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 22, vertical: 5),
          height: 100,
          width: 150,
          child: juego.cover != null ? CachedNetworkImage(
            imageUrl: widget.igdbservice.getURLCoverFromGame(juego),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              height: 100,
              width: 150,
              //margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fill,
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

  void _getMeGusta() async{
    DocumentSnapshot snapshotId = await widget.fs.getMeGusta();
    List<int> tempId = [];
    List<Juego> tempJuego = [];

    if(snapshotId.data() != null){
      snapshotId.data().keys.forEach((element) {
        tempId.add(int.parse(element));
      });

      tempJuego = await widget.igdbservice.recuperarID(tempId);

      if(tempJuego != null){
        setState(() {
          _listMeGusta = tempJuego;
        });
      }

    }else{
      setState(() {
        _listMeGusta = [];
      });
    }

  }

  void _getCompletado() async{
    DocumentSnapshot snapshotId = await widget.fs.getCompletado();
    List<int> tempId = [];
    List<Juego> tempJuego = [];

    if(snapshotId.data() != null){
      snapshotId.data().keys.forEach((element) {
        tempId.add(int.parse(element));
      });

      tempJuego = await widget.igdbservice.recuperarID(tempId);

      if(tempJuego != null){
        setState(() {
          _listCompletado = tempJuego;
        });
      }

    }else{
      setState(() {
        _listCompletado = [];
      });
    }

  }

  void _usuarioActual() async{
    User tempUser = await widget.us.getCurrentUser();

    if(tempUser != null){
      setState(() {
        _user = tempUser;
      });
    }
  }
}