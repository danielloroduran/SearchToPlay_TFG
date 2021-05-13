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
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: _listValoraciones == null ? Center(
          child: CircularProgressIndicator() ,
        ):
        _valoraciones(context),
      )
    );
  }

  Widget _valoraciones(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Expanded(
            child:  GridView.builder(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              physics: ClampingScrollPhysics(),
              
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.90,
                mainAxisSpacing: 4,
                crossAxisSpacing: 10,
              ),
              itemCount: _listValoraciones.length,
              itemBuilder: (context, index){
                return _userCard(_listValoraciones[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _userCard(Map<dynamic, dynamic> mapValoraciones){
    return Column(
      children: [
        Stack(
          children: <Widget>[
            CircleAvatar(
              child: mapValoraciones.containsKey("fotoperfil") ? CachedNetworkImage(    
                imageUrl: mapValoraciones['fotoperfil'],
                progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                  height: 150,
                  width: 150,
                  child: Center(
                    child: CircularProgressIndicator(value: downloadProgress.progress),
                  ),
                ),
                imageBuilder: (context, imageProvider) => Container(
                  height: 150,
                  width: 150,
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
                height: 70,
                width: 70,
              )
            )
          ],
        ),
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
