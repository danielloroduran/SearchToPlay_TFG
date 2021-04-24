import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:flutter/material.dart';

class TopJugonesPage extends StatefulWidget{

  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;

  TopJugonesPage(this.us, this.fs, this.igdbservice);
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
        backgroundColor: Theme.of(context).backgroundColor,
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
      body: Container(child: Text("El Top Jugones"))
    );
  }
}