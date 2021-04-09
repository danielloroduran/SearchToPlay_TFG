import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:SearchToPlay/secciones/tab.dart';
import 'package:SearchToPlay/secciones/login.dart';

enum AuthStatus{
  NO_DETERMINADO,
  NO_LOGEADO,
  LOGEADO
}

class RootPage extends StatefulWidget{

  final UserService us;
  RootPage({this.us});

  @override
  _RootPageState createState() => new _RootPageState();

}

class _RootPageState extends State<RootPage>{
  AuthStatus authStatus = AuthStatus.NO_DETERMINADO;
  User _user;

  @override
  void initState(){
    super.initState();
    widget.us.getCurrentUser().then((user){
      setState(() {
        if(user!= null){
          _user = user;
        }
        authStatus = user == null ? AuthStatus.NO_LOGEADO : AuthStatus.LOGEADO; 
      });
    });
  }

  Widget build(BuildContext context){
    switch(authStatus){
      case AuthStatus.NO_DETERMINADO:
        return pantallaCarga();
        break;
      case AuthStatus.NO_LOGEADO:
        return new LoginPage(widget.us);
        break;
      case AuthStatus.LOGEADO:
        if(_user != null){
          return TabPage(_user, widget.us);
        }else{
          return pantallaCarga();
        }
        break;
      default:
        return pantallaCarga();
    }
  }

  Widget pantallaCarga(){
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      )
    );
  }
}