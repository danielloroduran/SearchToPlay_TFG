import 'dart:io';

import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/secciones/verjuego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/storageservice.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:SearchToPlay/widgets/bottomsheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class PerfilPage extends StatefulWidget{

  final UserService us;
  final IGDBService igdbservice;
  final FirebaseService fs;
  final StorageService ss;

  PerfilPage(this.us, this.igdbservice, this.fs, this.ss);

  @override
  _PerfilPageState createState() => new _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>{

  User _user;
  List<Juego> _listMeGusta, _listCompletado, _listValorado;
  File _cambioFotoPerfil;
  String _providerUser;
  bool _haCambiado;

  void initState(){
    super.initState();
    _providerUser = "";
    _haCambiado = false;
    _usuarioActual();
    _getMeGusta();
    _getCompletado();
    _getValorado();
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Volver atrás",
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            tooltip: "Logros",
            icon: Icon(Icons.emoji_events),
            onPressed: (){
              if(_listMeGusta != null && _listCompletado != null){
                mostrarBottomSheetLogros(context, _listMeGusta.length, _listCompletado.length);
              }else{
                Fluttertoast.showToast(msg: "Espere a que se carguen las listas...");
              }
            },
          )
        ],
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
                    text: _listValorado != null ? _listValorado.length.toString() : "",
                    icon: Icon(Icons.videogame_asset, color: Colors.yellow)
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
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textTheme.headline1.color,
                            ),
                            textAlign: TextAlign.center,
                          ) : CircularProgressIndicator(),
                        ),
                      ),
                    _listCompletado != null && _listCompletado.length > 0 ? _juegosCompletado(context) : Container(
                      child: Center(
                        child: _listCompletado != null && _listCompletado.length == 0 ? Text("Parece que aún\n no has completado ningún juego",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textTheme.headline1.color,
                            ),
                            textAlign: TextAlign.center,
                          ) : CircularProgressIndicator(),
                        ),
                      ),
                    _listValorado != null && _listValorado.length > 0 ? _juegosValorados(context) : Container(
                      child: Center(
                        child: _listValorado != null && _listValorado.length == 0 ? Text("Parece que aún\n no has valorado ningún juego",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).textTheme.headline1.color,
                            ),
                            textAlign: TextAlign.center,
                          ) : CircularProgressIndicator(),
                        ),
                      ),
                  ],
                )
              )
            ],
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Cerrar sesión",
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
      child: Stack(
        children: <Widget>[
          _user?.photoURL != null && _haCambiado == false ? CachedNetworkImage(    
            imageUrl: _user.photoURL,
            progressIndicatorBuilder: (context, url, downloadProgress) => Container(
              height: 150,
              width: 150,
              child: Center(
                child: CircularProgressIndicator(value: downloadProgress.progress),
              ),
            ),
            errorWidget: (context, url, error) => Container(height: 150, width: 150, child: Center(child: Icon(Icons.error, color: Colors.red))),
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
                image: _cambioFotoPerfil == null ? AssetImage('assets/user_profile_icon.png') : FileImage(_cambioFotoPerfil),
              )
            ),
          ),
          Positioned(
            child: _providerUser == "password" ? Tooltip(
              child: InkWell(
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).textTheme.headline1.color,
                  ),
                  child: Icon(Icons.camera_alt, color: Theme.of(context).backgroundColor,),
                ),
                onTap: (){
                  _fuenteImagen(context);
                },
              ),
              message: "Cambiar foto de perfil",
            ) : Container(),
            bottom: 0,
            right: 0,
          )
        ] 
      ),
    );
  }

  Widget _infoUsuario(BuildContext context){
    return Column(
      children: [
        Text(_user?.displayName ?? "",
          style: TextStyle(
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
              itemCount: _listValorado.length,
              itemBuilder: (context, index){
                return _juegoCard(_listValorado[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _juegoCard(Juego juego){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 22, vertical: 5),
        height: 100,
        width: 150,
        child: juego.cover != null ? Hero(
          tag: juego.id.toString(),
          child: CachedNetworkImage(
            imageUrl: widget.igdbservice.getURLCoverFromGame(juego),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.red)),
            imageBuilder: (context, imageProvider) => Container(
              height: 100,
              width: 150,
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
          ),
        ) : 
        Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image_rounded, color: Theme.of(context).textTheme.headline1.color),
              Text(juego.nombre, 
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                ),
              ),
            ],
          )
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context) => VerJuegoPage(juego, widget.fs, widget.igdbservice))).then((value) => {
          _getMeGusta(),
          _getValorado(),
          _getCompletado(),
        });
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
        if(this.mounted){
          setState(() {
            _listMeGusta = tempJuego;
          });
        }
      }

    }else{
      if(this.mounted){
        setState(() {
          _listMeGusta = [];
        });
      }
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
        if(this.mounted){
          setState(() {
            _listCompletado = tempJuego;
          });
        }
      }

    }else{
      if(this.mounted){
        setState(() {
          _listCompletado = [];
        });
      }
    }

  }

  void _getValorado() async{
    DocumentSnapshot snapshotId = await widget.fs.getValorado();
    List<int> tempId = [];
    List<Juego> tempJuego = [];

    if(snapshotId.data() != null){
      snapshotId.data().keys.forEach((element) {
        tempId.add(int.parse(element));
      });

      tempJuego = await widget.igdbservice.recuperarID(tempId);

      if(tempJuego != null){
        if(this.mounted){
          setState(() {
            _listValorado = tempJuego;
          });
        }
      }
    }else{
      if(this.mounted){
        setState(() {
          _listValorado = [];
        });
      }
    }
  }

  void _usuarioActual() async{
    User tempUser = await widget.us.getCurrentUser();

    if(tempUser != null){
      if(this.mounted){
        setState(() {
          _user = tempUser;
          _providerUser = tempUser.providerData.first.providerId;
        });
      }
    }
  }

  void _fuenteImagen(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          title: new Text("Cámara o galería",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.headline1.color,
            )),
          content: new Text("Seleccione desde donde se va a obtener la foto.",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1.color,
            )
          ),
          actions: <Widget>[
            new Row(
              children: <Widget>[
                new TextButton(
                  child: new Text("Cancelar",
                    style: TextStyle(
                      color: Colors.grey
                    )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                new TextButton(
                  child: new Text("Galería",
                    style: TextStyle(
                      color: Theme.of(context).buttonColor
                    )
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _getImagen(false);
                  },
                ),
                new TextButton(
                  child: new Text("Cámara",
                    style: TextStyle(
                      color: Theme.of(context).buttonColor
                    )
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    _getImagen(true);
                  }
                )
              ],
            )
          ],
        );
      }
    );
  }

  Future<void> _getImagen(bool usarCamara) async{

    var imagen;
    if(usarCamara){
      imagen = await ImagePicker().getImage(source: ImageSource.camera);
    }else{
      imagen = await ImagePicker().getImage(source: ImageSource.gallery);
    }

    if(imagen != null){
      setState(() {
        _cambioFotoPerfil = File(imagen.path);
        _haCambiado = true;
      });
      _actualizarDatos();
    }
  }

  void _actualizarDatos() async{
    String _url;
    Map<String, dynamic> _userMap = new Map<String, dynamic>();

    if(_user != null){
      Fluttertoast.showToast(msg: "Actualizando foto...");
      _url = await widget.ss.subirFotoPerfil(_cambioFotoPerfil);  
      _user.updateProfile(photoURL : _url);
      _userMap = {"email" : _user.email, "usuario" : _user.displayName, "fotoperfil" : _url};
      widget.fs.updateUser(_userMap); 

      Fluttertoast.showToast(msg: "Foto de perfil actualizada con éxito");   
    }
  }

}