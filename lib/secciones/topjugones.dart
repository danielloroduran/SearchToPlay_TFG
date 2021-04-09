import 'package:flutter/material.dart';

class TopJugonesPage extends StatefulWidget{

  @override
  _TopJugonesPageState createState() => new _TopJugonesPageState();
}

class _TopJugonesPageState extends State<TopJugonesPage> {

  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("El Top Jugones",
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