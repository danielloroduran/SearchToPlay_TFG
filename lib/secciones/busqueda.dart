import 'package:SearchToPlay/modelos/juego.dart';
import 'package:SearchToPlay/secciones/informacion.dart';
import 'package:SearchToPlay/secciones/perfil.dart';
import 'package:SearchToPlay/secciones/verjuego.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/storageservice.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class BusquedaPage extends StatefulWidget{

  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;
  final StorageService ss;

  BusquedaPage(this.us, this.fs, this.igdbservice, this.ss);
  @override
  _BusquedaPageState createState() => new _BusquedaPageState();
}

class _BusquedaPageState extends State<BusquedaPage> with AutomaticKeepAliveClientMixin<BusquedaPage>{

  List _listResultados;
  bool _validateBusqueda;
  String _falloBusqueda;
  TextEditingController _busquedaController;
  bool _sinResultados;
  bool _estaCargando;

  void initState(){
    super.initState();
    _busquedaController = new TextEditingController();
    _sinResultados = false;
    _validateBusqueda = false;
    _estaCargando = false;
    _falloBusqueda = "";
  }

  @override
  bool get wantKeepAlive => true;

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("Búsqueda",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 30,
              color: Theme.of(context).textTheme.headline1.color
            ),
          ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
              tooltip: "Perfil",
              icon: Icon(Icons.person_rounded),
              onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context) => PerfilPage(widget.us, widget.igdbservice, widget.fs, widget.ss)));
              },
            ),
        actions: [
          IconButton(
            tooltip: "Información",
            icon: Icon(Icons.info),
            onPressed: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context) => InformacionPage()));            
            },
          )
        ],
      ),

      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 30, top: 20, right: 30),
        child: Column(
          children: <Widget>[
            _barraBusqueda(context),
            _sinResultados == false ? _resultadosBusqueda(context) : _avisoSinResultados(),
          ]
        )
      )
    );
  }

  Widget _barraBusqueda(BuildContext context){
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        autofocus: false,
        controller: _busquedaController,
        textInputAction: TextInputAction.search,
        onSubmitted: (value){
          _comprobacion();
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          hintText: 'TÍTULO',
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              _comprobacion();
              FocusScope.of(context).unfocus();
            },
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          errorText: _validateBusqueda ? _falloBusqueda : null,
        )
      )
    );
  }

  Widget _resultadosBusqueda(BuildContext context){
    return Expanded(
      child:  _listResultados == null && _estaCargando == true ? Container(child: Center(child: CircularProgressIndicator(),),) :
      _listResultados == null && _estaCargando == false ? Container() : GridView.builder(
        padding: EdgeInsets.only(top: 20),
        physics: ClampingScrollPhysics(),
        
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.90,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: _listResultados.length,
        itemBuilder: (context, index){
          return _juegoCard(_listResultados[index]);
        },
      ),
    );
  }

  Widget _juegoCard(Juego juego){
    return GestureDetector(
      child: Hero(
        tag: juego.id.toString(),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
          height: 100,
          width: 150,
          child: juego.cover != null ? CachedNetworkImage(
            imageUrl: widget.igdbservice.getURLCoverFromGame(juego),
            errorWidget: (context, url, error) => Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              height: 100,
              width: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: imageProvider
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.grey.withOpacity(0.5) : Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(6, 4),
                  )
                ]
              ),
            ),
          ) : 
          Container(
            alignment: Alignment.center,
            child: Text(juego.nombre +"\n [Imagen no disponible]", textAlign: TextAlign.center,)
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      onTap: (){
        Navigator.push(context, CupertinoPageRoute(builder: (context) => VerJuegoPage(juego, widget.fs, widget.igdbservice)));
      },
    );
  }

  Widget _avisoSinResultados(){
    return Padding(
      padding: const EdgeInsets.only(top:230.0),
      child: Center(
        child: Column(
          children: [
            Container(
              child: Text("No se han encontrado resultados",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                )
              )
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Text("😟",
                style: TextStyle(
                  fontSize: 30,
                ),
              )
            ),
          ],
        ),
      ),
    );
  }



  void _comprobacion(){
    if(_busquedaController.text == "" || _busquedaController.text == null){
      setState(() {
        _validateBusqueda = true;
        _falloBusqueda = "Este campo no puede estar en blanco";
      });
    }else{
      setState(() {
        _sinResultados = false;
        _estaCargando = true;
        _validateBusqueda = false;
        _falloBusqueda = "";
      });
      _getBusqueda();
    }
  }

  void _getBusqueda() async{
    try{
      List tempJuegos = await widget.igdbservice.recuperarTitulo(_busquedaController.text);

      if(tempJuegos.isNotEmpty){
        if(this.mounted){
          setState(() {
            _listResultados = tempJuegos;
            _estaCargando = false;
          });
        }
      }else{
        setState((){
          _sinResultados = true;
        });
      }
 
    }catch(e){
      setState(() {
        _estaCargando = false;
      });
      Fluttertoast.showToast(msg: "Se ha producido un error. Vuelva a intentarlo en unos instantes.");
    }
  }
}