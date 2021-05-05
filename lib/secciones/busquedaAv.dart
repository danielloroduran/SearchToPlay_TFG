import 'package:SearchToPlay/modelos/genero.dart';
import 'package:SearchToPlay/modelos/plataforma.dart';
import 'package:SearchToPlay/secciones/perfil.dart';
import 'package:SearchToPlay/secciones/resultados.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/igdb.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:flutter/cupertino.dart';
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
              color: Theme.of(context).textTheme.headline6.color
            ),
          ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
              tooltip: "Perfil",
              icon: Icon(Icons.person_rounded),
              onPressed: (){
                Navigator.push(context, CupertinoPageRoute(builder: (context) => PerfilPage(widget.us, widget.igdbservice, widget.fs)));
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text("Mes",
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
                      value: _mesSeleccionado,
                      onChanged: (newValue){
                        setState(() {
                          _mesSeleccionado = newValue;
                        });
                      },
                      items: _listMes.map((id, nombre) {
                        return MapEntry(
                          nombre,
                          DropdownMenuItem(
                            value: id,
                            child: Text(nombre),
                          )
                        );
                      }).values.toList(),
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
                      color: Theme.of(context).textTheme.headline6.color
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
                      color: Theme.of(context).textTheme.headline6.color
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
      Navigator.push(context, CupertinoPageRoute(builder: (context) => ResultadosPage(widget.us, widget.fs, widget.igdbservice, listResultados: tempResultados)));
    }else{

    }
  }
}