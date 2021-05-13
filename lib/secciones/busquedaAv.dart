import 'package:SearchToPlay/modelos/genero.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/secciones/informacion.dart';
import 'package:SearchToPlay/secciones/perfil.dart';
import 'package:SearchToPlay/secciones/resultados.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/storageservice.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class BusquedaAvPage extends StatefulWidget{

  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;
  final StorageService ss;

  BusquedaAvPage(this.us, this.fs, this.igdbservice, this.ss);

  @override
  _BusquedaAvPageState createState() => new _BusquedaAvPageState();
}

class _BusquedaAvPageState extends State<BusquedaAvPage> with AutomaticKeepAliveClientMixin<BusquedaAvPage>{

  List<String> _listOrden = ['Fecha (asc)', 'Fecha (desc)', 'Nombre (asc)', 'Nombre (desc)', 'Nota crítica (asc)', 'Nota crítica (desc)' ];
  Map<int, String> _listMes = {0 : "Cualquiera", 1 : "Enero", 2 : "Febrero", 3 : "Marzo" , 4 : "Abril", 5 : "Mayo", 6 : "Junio", 7 : "Julio", 8 : "Agosto", 9 : "Septiembre", 10 :"Octubre", 11 :"Noviembre", 12 : "Diciembre"};
  List<Genero> _listGeneros = [];
  List<Plataforma> _listPlataformas = [];

  Genero _generoSeleccionado;
  Plataforma _plataformaSeleccionada;
  int _mesSeleccionado = 0;
  String _ordenSeleccionado;
  double _anioSeleccionado = 2000;
  double _notaSeleccionada = 50;
  bool _estaCargando;
  void initState(){
    super.initState();
    _ordenSeleccionado = _listOrden[0];
    _estaCargando = false;
    _getGeneros();
    _getPlataformas();
  }

  bool get wantKeepAlive => true;

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("Búsqueda Avanzada",
            style: TextStyle(
              fontFamily: 'OpenSans',
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
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Theme.of(context).backgroundColor,
        padding: EdgeInsets.only(left: 27, top: 30, right: 27),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Ordenar por ",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                          color: Theme.of(context).textTheme.headline1.color
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      TextButton(
                        child: Text(_ordenSeleccionado ?? "",),
                        onPressed: (){
                          _bottomSheetOrden(context);
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Género ",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        color: Theme.of(context).textTheme.headline1.color
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextButton(
                      child: Text(_generoSeleccionado?.nombre ?? ""),
                      onPressed: (){
                        _bottomSheetGenero(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Plataforma ",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        color: Theme.of(context).textTheme.headline1.color
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextButton(
                      child: _plataformaSeleccionada != null ? (_plataformaSeleccionada.abreviacion != null ? Text(_plataformaSeleccionada.abreviacion) : _plataformaSeleccionada.nombre.length > 14 ? Text(_plataformaSeleccionada.nombre.substring(0, 14) + "...") : Text(_plataformaSeleccionada.nombre)) : Text(""),
                      onPressed: (){
                        _bottomSheetPlataforma(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Mes",
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 25,
                        color: Theme.of(context).textTheme.headline1.color
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextButton(
                      child: Text(_listMes[_mesSeleccionado]),
                      onPressed: () {
                        _bottomSheetMes(context);
                      },
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                children: <Widget>[
                  Text("Año de lanzamiento",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Theme.of(context).textTheme.headline1.color
                    ),
                  )
                ],
              ),
          ),
          Container(
            child:
              Slider(                    
                value: _anioSeleccionado,
                onChanged: (newAnio){
                  setState(() {
                    _anioSeleccionado = newAnio;
                  });
                },
                min: 1970,
                max: DateTime.now().year.toDouble(),
                divisions: DateTime.now().year - 1970,
                label: _anioSeleccionado.toInt().toString(),
              )
            
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("1970"),
                Text(DateTime.now().year.toString()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                children: <Widget>[
                  Text("Nota mínima de la crítica",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Theme.of(context).textTheme.headline1.color
                    ),
                  )
                ],
              ),
            ),
            Container(
              child:  Slider(
                value: _notaSeleccionada,
                onChanged: (newNota){
                  setState(() {
                    _notaSeleccionada = newNota;
                  });
                },
                min: 0,
                max: 100,
                divisions: 100,
                label: _notaSeleccionada.toInt().toString(),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("0"),
                  Text("100"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
              child: _estaCargando == false ? ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 55, width: 350),
                child: ElevatedButton(
                  child: Text("Buscar",
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).textTheme.subtitle2.color,
                    ),
                  ), 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    primary: HexColor('#4fc522')
                  ),
                  onPressed: (){
                    _buscar();
                  },
                )
              ) : Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        )
      ),
    );
  }

  void _getGeneros() async{
    List tempGeneros = await widget.igdbservice.recuperarGeneros();
    if(this.mounted){
      setState(() {
        _listGeneros = tempGeneros;
        _listGeneros.insert(0, new Genero(generoId: 0, nombre: "Cualquiera"));
        _generoSeleccionado = _listGeneros[0];
      });
    }
  }

  void _getPlataformas() async{
    List tempPlataformas = await widget.igdbservice.recuperarPlataformas();
    if(this.mounted){
      setState(() {
        _listPlataformas = tempPlataformas;
        _plataformaSeleccionada = _listPlataformas[0];
      });
    }

  }

  void _buscar() async{
    setState((){
      _estaCargando = true;
    });
    List tempResultados = await widget.igdbservice.recuperarAvanzado(_ordenSeleccionado, _generoSeleccionado.generoId, _plataformaSeleccionada.plataformaId, _anioSeleccionado.toInt(), _notaSeleccionada.toInt(), _mesSeleccionado);
    
    setState((){
      _estaCargando = false;
    });

    if(tempResultados.isNotEmpty){
      Navigator.push(context, CupertinoPageRoute(builder: (context) => ResultadosPage(widget.us, widget.fs, widget.igdbservice, "Resultados", tempResultados)));
    }else{
      Fluttertoast.showToast(msg: "No se han encontrado resultados.");
    }
  }

  void _bottomSheetOrden(BuildContext context){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text("Ordenar por",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric( horizontal: 10),
                    child: ListView.builder(
                      itemCount: _listOrden.length,
                      itemBuilder: (context, index){
                        return RadioListTile(
                          activeColor: Theme.of(context).buttonColor,
                          title: Text(_listOrden[index]),
                          value: _listOrden[index],
                          groupValue: _ordenSeleccionado,
                          onChanged: (value){
                            state((){
                              _ordenSeleccionado = value;
                            });
                            setState(() {
                              _ordenSeleccionado = value;
                            });
                          },
                        );
                      },
                    ),
                  )
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _bottomSheetGenero(BuildContext context){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text("Género",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric( horizontal: 10),
                    child: ListView.builder(
                      itemCount: _listGeneros.length,
                      itemBuilder: (context, index){
                        return RadioListTile(
                          activeColor: Theme.of(context).buttonColor,
                          title: Text(_listGeneros[index].nombre),
                          value: _listGeneros[index],
                          groupValue: _generoSeleccionado,
                          onChanged: (value){
                            state((){
                              _generoSeleccionado = value;
                            });
                            setState(() {
                              _generoSeleccionado = value;
                            });
                          },
                        );
                      },
                    ),
                  )
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _bottomSheetPlataforma(BuildContext context){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text("Plataforma",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric( horizontal: 10),
                    child: ListView.builder(
                      itemCount: _listPlataformas.length,
                      itemBuilder: (context, index){
                        return RadioListTile(
                          activeColor: Theme.of(context).buttonColor,
                          title: _listPlataformas[index].abreviacion != null ? Text(_listPlataformas[index].abreviacion) : _listPlataformas[index].nombre.length > 30 ? Text(_listPlataformas[index].nombre.substring(0, 30) + "...") : Text(_listPlataformas[index].nombre),
                          value: _listPlataformas[index],
                          groupValue: _plataformaSeleccionada,
                          onChanged: (value){
                            state((){
                              _plataformaSeleccionada = value;
                            });
                            setState(() {
                              _plataformaSeleccionada = value;
                            });
                          },
                        );
                      },
                    ),
                  )
                ),
              ],
            );
          }
        );
      }
    );
  }

  void _bottomSheetMes(BuildContext context){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, StateSetter state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 5,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20)
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 30),
                  child: Text("Mes",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: _listMes.length,
                      itemBuilder: (context, index){
                        int key = _listMes.keys.elementAt(index);
                        return RadioListTile(
                          title: Text(_listMes[key]),
                          value: key,
                          groupValue: _mesSeleccionado,
                          onChanged: (value){
                            state((){
                              _mesSeleccionado = value;
                            });
                            setState(() {
                              _mesSeleccionado = value;
                            });
                          },
                        );
                      },
                    ),
                  )
                ),
              ],
            );
          }
        );
      }
    );
  }
}