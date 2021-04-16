import 'package:SearchToPlay/modelos/genero.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class BusquedaAvPage extends StatefulWidget{

  final UserService us;
  final FirebaseService fs;
  final IGDBService igdbservice;

  BusquedaAvPage(this.us, this.fs, this.igdbservice);

  @override
  _BusquedaAvPageState createState() => new _BusquedaAvPageState();
}

class _BusquedaAvPageState extends State<BusquedaAvPage> with AutomaticKeepAliveClientMixin<BusquedaAvPage>{

  List<String> _listOrden = ['Fecha (asc)', 'Fecha (desc)', 'Nombre (asc)', 'Nombre (desc)', 'Nota crítica (asc)', 'Nota crítica (desc)' ];
  List<Genero> _listGeneros = [];
  List<Plataforma> _listPlataformas = [];
  Genero _generoSeleccionado;
  Plataforma _plataformaSeleccionada;
  String _ordenSeleccionado;
  double _anioSeleccionado = 2000;
  double _notaSeleccionada = 50;
  void initState(){
    super.initState();
    _ordenSeleccionado = _listOrden[0];
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
              color: Theme.of(context).textTheme.headline6.color
            ),
          ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
              tooltip: "Perfil",
              icon: Icon(Icons.person_rounded),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
        actions: [
          IconButton(
            tooltip: "Información",
            icon: Icon(Icons.info),
            onPressed: (){

            },
          )
        ],
      ),
      body: Container(
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
                          color: Theme.of(context).textTheme.headline6.color
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      DropdownButton(
                        value: _ordenSeleccionado,
                        onChanged: (newValue){
                          setState(() {
                            _ordenSeleccionado = newValue;
                          });
                        },
                        items: _listOrden.map((valueItem){
                          return DropdownMenuItem(
                            value: valueItem,
                            child: Text(valueItem)
                          );
                        }).toList(),
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
                      Text("Género ",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                          color: Theme.of(context).textTheme.headline6.color
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      DropdownButton(
                        value: _generoSeleccionado,
                        onChanged: (newValue){
                          setState(() {
                            _generoSeleccionado = newValue;
                          });
                        },
                        items: _listGeneros == [] ? [] : _listGeneros.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: valueItem.nombre.length > 15 ? Text(valueItem.nombre.substring(0, 15) + "...") : Text(valueItem.nombre),
                          );
                        }).toList(),
                      )],
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
                      Text("Plataforma ",
                        style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                          color: Theme.of(context).textTheme.headline6.color
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      DropdownButton(
                        value: _plataformaSeleccionada,
                        onChanged: (newValue){
                          setState(() {
                            _plataformaSeleccionada = newValue;
                          });
                        },
                        items: _listPlataformas == [] ? [] : _listPlataformas.map((valueItem) {
                          return DropdownMenuItem(
                            value: valueItem,
                            child: valueItem.abreviacion != null ? Text(valueItem.abreviacion) : valueItem.nombre.length > 14 ? Text(valueItem.nombre.substring(0, 14) + "...") : Text(valueItem.nombre),
                          );
                        }).toList(),
                      )
                    ],
                  )
                ],
              ),
           ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Text("Año de lanzamiento",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Theme.of(context).textTheme.headline6.color
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
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
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Text("Nota de la crítica",
                    style: TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                      color: Theme.of(context).textTheme.headline6.color
                    ),
                  )
                ],
              ),
            ),
            Container(
              child:
                Slider(
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 100, 0, 10),
              child: ConstrainedBox(
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

                  },
                )
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
}