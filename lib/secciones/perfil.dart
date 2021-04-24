import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget{

  final UserService us;

  PerfilPage(this.us);

  @override
  _PerfilPageState createState() => new _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage>{

  void initState(){
    super.initState();
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
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
}