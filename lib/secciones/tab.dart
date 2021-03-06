import 'package:SearchToPlay/secciones/busqueda.dart';
import 'package:SearchToPlay/secciones/busquedaAv.dart';
import 'package:SearchToPlay/secciones/inicio.dart';
import 'package:SearchToPlay/secciones/topjugones.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/storageservice.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TabPage extends StatefulWidget{

  final User user;
  final UserService us;

  TabPage(this.user, this.us, {Key key}) : super(key: key);

  @override
  _TabPageState createState() => new _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin{

  FirebaseService _fs;
  IGDBService _igdbService;
  TabController _tabController;
  StorageService _ss;

  @override
  void initState(){
    super.initState();
    _fs = new FirebaseService(widget.user.uid);
    _igdbService = new IGDBService(_fs);
    _ss = new StorageService(widget.user.uid);
    _tabController = new TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: new TabBar(
          onTap: (value){
            FocusScope.of(context).unfocus();
          },
          indicatorColor: Colors.transparent,
          labelColor: Theme.of(context).tabBarTheme.labelColor,
          unselectedLabelColor: Theme.of(context).tabBarTheme.unselectedLabelColor,
          tabs: <Widget>[
            new Tab(
              icon: Icon(Icons.home),
            ),
            new Tab(
              icon: Icon(Icons.search),
            ),
            new Tab(
              icon: Icon(Icons.zoom_in),
            ),
            new Tab(
              icon: Icon(Icons.emoji_events),
            )
          ],
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[InicioPage(widget.us, _fs, _igdbService, _ss), BusquedaPage(widget.us, _fs, _igdbService, _ss), BusquedaAvPage(widget.us, _fs, _igdbService, _ss), TopJugonesPage(widget.us, _fs, _igdbService, _ss)],
      ),
    );
  }
}