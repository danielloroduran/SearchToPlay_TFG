import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class InformacionPage extends StatelessWidget{

  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("Información",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 30,
          color: Theme.of(context).textTheme.headline1.color
        ),
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
      body: new Container(
        child: _info(context),
      )
    );
  }

  Widget _info(BuildContext context){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[100],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 256,
            height: 256,
            child: Image(
              image: Theme.of(context).brightness == Brightness.dark ? AssetImage("assets/launch_image_dark.png") : AssetImage("assets/launch_image_light.png"),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Desarrollado por",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.headline1.color,
              ),
            ),
          ),
          Container(
            child: Text("Daniel Loro Durán",
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).textTheme.headline1.color,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: OutlinedButton.icon(
              icon: Icon(Icons.link),
              label: Text("GitHub",
                style: TextStyle(
                  fontWeight: FontWeight.w500
                ),
              ),
              onPressed: (){
                _launchGithub();
              },
            ),
          ),
          Container(
            child: Text("Usando",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Theme.of(context).textTheme.headline1.color,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: FlutterLogo(
                        size: 40
                      ),
                      onTap: (){
                        _launchFlutter();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text("Flutter",
                        style: TextStyle(
                          fontSize: 24
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Image(
                        image: AssetImage("assets/firebase_logo.png"),
                        width: 40,
                        height: 40,
                      ),
                      onTap: (){
                        _launchFirebase();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text("Firebase",
                        style: TextStyle(
                          fontSize: 24
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                      child: Image(
                        image: AssetImage("assets/igdb_logo.jpg"),
                        width: 40,
                        height: 40,
                      ),
                      onTap: (){
                        _launchIGDB();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(" IGDB ",
                        style: TextStyle(
                          fontSize: 24
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _launchGithub() async{
    if(await(canLaunch('https://www.github.com/danielloroduran'))){
      await launch('https://www.github.com/danielloroduran');
    }else{
      Fluttertoast.showToast(msg: "No se ha podido acceder a la página");
    }
  }

  void _launchFlutter() async{
    if(await(canLaunch('https://flutter.dev/'))){
      await launch('https://flutter.dev/');
    }else{
      Fluttertoast.showToast(msg: "No se ha podido acceder a la página");
    }
  }

  void _launchFirebase() async{
    if(await(canLaunch('https://firebase.google.com/'))){
      await launch('https://firebase.google.com/');
    }else{
      Fluttertoast.showToast(msg: "No se ha podido acceder a la página");
    }
  }

  void _launchIGDB() async{
    if(await(canLaunch('https://www.igdb.com/'))){
      await launch('https://www.igdb.com/');
    }else{
      Fluttertoast.showToast(msg: "No se ha podido acceder a la página");
    }
  }
}