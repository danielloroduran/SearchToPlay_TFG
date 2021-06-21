import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/secciones/verjuego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResultadosPage extends StatefulWidget{

  final FirebaseService fs;
  final IGDBService igdbservice;
  final String titulo;
  final List<Juego> listResultados;

  ResultadosPage(this.fs, this.igdbservice, this.titulo, this.listResultados);

  @override
  _ResultadosPageState createState() => new _ResultadosPageState();
}

class _ResultadosPageState extends State<ResultadosPage> {

  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: AutoSizeText(
          widget.titulo,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30,
            color: Theme.of(context).textTheme.headline1.color,
          ),
          maxLines: 1,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
          tooltip: "Volver atrás",
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 30, top: 20, right: 30),
        child: Column(
          children: <Widget>[
            _resultadosBusqueda(context)
          ]
        )
      )
    );
  }

  Widget _resultadosBusqueda(BuildContext context){
    return Expanded(
      child:  GridView.builder(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        physics: ClampingScrollPhysics(),
        
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.80,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
        ),
        itemCount: widget.listResultados.length,
        itemBuilder: (context, index){
          return _juegoCard(widget.listResultados[index]);
        },
      ),
    );
  }

  Widget _juegoCard(Juego juego){
    return GestureDetector(
      child: Hero(
        tag: juego.id.toString(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 100,
          width: 150,
          child: juego.cover != null ? CachedNetworkImage(
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
}
