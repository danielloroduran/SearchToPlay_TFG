import 'package:flutter/material.dart';

class BusquedaAvPage extends StatefulWidget{

  @override
  _BusquedaAvPageState createState() => new _BusquedaAvPageState();
}

class _BusquedaAvPageState extends State<BusquedaAvPage> {

  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: Hero(
          tag: 'titulo',
                  child: new Text("Búsqueda Avanzada",
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Theme.of(context).textTheme.headline6.color
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
              tooltip: "Perfil",
              icon: Icon(Icons.person_rounded),
              onPressed: (){
                Navigator.pop(context);
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
    );
  }
}