import 'package:SearchToPlay/secciones/busqueda.dart';
import 'package:SearchToPlay/secciones/busquedaAv.dart';
import 'package:SearchToPlay/secciones/inicio.dart';
import 'package:SearchToPlay/secciones/topjugones.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
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

  @override
  void initState(){
    super.initState();
    _fs = new FirebaseService(widget.user.uid);
    _igdbService = new IGDBService(_fs);
    _igdbService.recuperarTop();
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
        //color: Theme.of(context).brightness == Brightness.dark ? HexColor("#1a1a1a") : HexColor("#f5f2f2"),
        //color: HexColor('#4fc522'),
      ),
      body: new TabBarView(
        
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[InicioPage(widget.us, _fs, _igdbService), BusquedaPage(widget.us, _fs, _igdbService), BusquedaAvPage(widget.us, _fs, _igdbService), TopJugonesPage(widget.us, _fs, _igdbService)],
      ),
    );
  }
}