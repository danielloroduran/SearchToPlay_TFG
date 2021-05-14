import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ValoracionesPage extends StatefulWidget{

  final String idJuego;
  final FirebaseService fs;

  ValoracionesPage(this.idJuego, this.fs);
  
  @override
  _ValoracionesPageState createState() => new _ValoracionesPageState();

}

class _ValoracionesPageState extends State<ValoracionesPage>{

  List<Map<dynamic, dynamic>> _listValoraciones;
  void initState(){
    super.initState();
    _getValoraciones();
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Valoraciones",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 30,
            color: Theme.of(context).textTheme.headline1.color
            ),
          ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: _listValoraciones != null ? _valoraciones(context) 
        : Container(
          child: Center(
            child: 
            CircularProgressIndicator(),
          ),
        )
      ),
    );
  }

  Widget _valoraciones(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Expanded(
            child:  GridView.builder(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              physics: ClampingScrollPhysics(),
              
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.9,
                mainAxisSpacing: 25,
                crossAxisSpacing: 15,
              ),
              itemCount: _listValoraciones.length,
              itemBuilder: (context, index){
                return _userCard(context, _listValoraciones[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _userCard(BuildContext context, Map<dynamic, dynamic> mapValoraciones){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: <Widget>[
            mapValoraciones.containsKey("fotoperfil") ? CachedNetworkImage(    
              imageUrl: mapValoraciones["fotoperfil"].toString(),
              progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                height: 100,
                width: 100,
                child: Center(
                  child: CircularProgressIndicator(value: downloadProgress.progress),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: imageProvider
                  )
                ),
              ),
            ) : Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(75),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/user_profile_icon.png')
                )
              ),
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Theme.of(context).textTheme.headline1.color,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0.0, 10.0)
                        )
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.videogame_asset,
                          color: Theme.of(context).backgroundColor,
                        ),
                        Text(" "+mapValoraciones["nota"].toString(),
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                          ),)
                      ],
                    ),
                  )
                ],
              ),
              bottom: 0,
              right: 0,
            )
          ] 
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(mapValoraciones["usuario"].toString(),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.headline1.color,
                fontSize: 15
              ),
            ),
          ),
        )
      ],
    );
  }

  void _getValoraciones() async{
    List<Map<dynamic, dynamic>> _tempList = await widget.fs.getValoradoId(widget.idJuego);

    if(_tempList != null){
      setState(() {
        _listValoraciones = _tempList;
      });
    }
  }
}
