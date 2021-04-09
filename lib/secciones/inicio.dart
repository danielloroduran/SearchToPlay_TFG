import 'package:SearchToPlay/modelos/imagen.dart';
import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget{

  final User user;
  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;

  InicioPage(this.user, this.us, this.fs, this.igdbservice);

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
          color: Theme.of(context).textTheme.headline6.color
        ),
          ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
              tooltip: "Perfil",
              icon: Icon(Icons.person_rounded),
              onPressed: (){

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
      body: Container(
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
                    color: Theme.of(context).textTheme.headline6.color
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
                    color: Theme.of(context).textTheme.headline6.color
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: _juegosTop()
            ),
          ],
        )
      )
      
    );
  }

  Widget _juegosTop(){
    return new Container(
      height: _listJuegosTop == null ? 40 : 210,
          child: _listJuegosTop == null ? CircularProgressIndicator() : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _listJuegosTop.length,
            itemBuilder: (context, index){

              return _juegoCard(_listJuegosTop[index]);
            }

        
      ),
    );
  }

    Widget _juegosMes(){
    return new Container(
      height: _listJuegosMes == null ? 40 : 210,
          child: _listJuegosMes == null ? CircularProgressIndicator() : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _listJuegosMes.length,
            itemBuilder: (context, index){

              return _juegoCard(_listJuegosMes[index]);
            }

        
      ),
    );
  }

  Widget _juegoCard(Juego juego){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 150,
      height: 200,
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage("https://images-na.ssl-images-amazon.com/images/I/81NPLf6o0LL._AC_SY606_.jpg"),
          fit: BoxFit.fill,
        )
      ),*/
      child: InkWell(
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: juego.cover == null ? null : DecorationImage(
              image: NetworkImage(juego.cover.url),
              fit: BoxFit.fitHeight
            )
          ),
        ),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onTap: (){

        },
      ),
    );
  }

  void _getJuegosTop() async{
    List tempJuegos = await widget.igdbservice.recuperarTop();
    for(int i = 0; i < tempJuegos.length;i++){
      tempJuegos[i].cover = await widget.igdbservice.recuperarCovers(tempJuegos[i].coverId);
      tempJuegos[i].cover.url = 'https://images.igdb.com/igdb/image/upload/t_cover_big/'+tempJuegos[i].cover.imageId+'.jpg';
    }  
    setState(() {
      _listJuegosTop = tempJuegos;
    });

  }

    void _getJuegosMes() async{
    List tempJuegos = await widget.igdbservice.recuperarMes();
    for(int i = 0; i < tempJuegos.length;i++){
      if(tempJuegos[i].coverId != null){
        tempJuegos[i].cover = await widget.igdbservice.recuperarCovers(tempJuegos[i].coverId);
        tempJuegos[i].cover.url = 'https://images.igdb.com/igdb/image/upload/t_cover_big/'+tempJuegos[i].cover.imageId+'.jpg';        
      }else{
        tempJuegos[i].cover = new Imagen(url: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png');
      }
      
    }  
    setState(() {
      _listJuegosMes = tempJuegos;
    });

  }

}