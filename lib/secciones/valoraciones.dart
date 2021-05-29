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
        child: _listValoraciones != null ? Column(
          children: [
            _valoraciones(context),
          ],
        ) 
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
    return Expanded(
      child:  ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _listValoraciones.length,
        itemBuilder: (context, index){
          return _userTile(context, _listValoraciones[index]);
        },
      ),
    );
  }

  Widget _userTile(BuildContext context, Map<dynamic, dynamic> mapValoraciones){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900] : Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 75,
                width: 80,
                child: mapValoraciones.containsKey("fotoperfil") ? CachedNetworkImage(
                  imageUrl: mapValoraciones["fotoperfil"].toString(),
                  progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                    height: 80,
                    width: 80,
                    child: Center(
                      child: CircularProgressIndicator(value: downloadProgress.progress),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error, color: Colors.red)),
                  imageBuilder: (context, imageProvider) => Container(
                    height: 80,
                    width: 80,
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
                  height: 80,
                  width: 80,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(75),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/user_profile_icon.png')
                    )
                  ),
                ),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(mapValoraciones["usuario"].toString(),
                      overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.videogame_asset,
                            color: Theme.of(context).textTheme.headline1.color,
                          ),
                          Text(" " + mapValoraciones["nota"].toString(),
                            style: TextStyle(
                              color: Theme.of(context).textTheme.headline1.color,
                              fontSize: 18
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 120,
                        child: Text(mapValoraciones["comentario"]?.toString()?? "",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1.color,
                            fontSize: 18
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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
