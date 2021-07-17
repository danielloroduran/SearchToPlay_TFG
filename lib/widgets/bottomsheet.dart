import 'dart:math';
import 'package:flutter/material.dart';

// Algunas de las imágenes utilizadas como trofeos han sido obtenidas de www.flaticon.com

Widget _upBar = Container(
  margin: EdgeInsets.only(top: 15),
  height: 5,
  width: 100,
  decoration: BoxDecoration(
    color: Colors.grey,
    border: Border.all(color: Colors.grey),
    borderRadius: BorderRadius.circular(20)
  ),
);

Widget _imagen(String imagen) => Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Image(
        image: AssetImage("assets/awards/$imagen.png"),
        height: 175,
        width: 175,
      ),
    ),
  );

Widget _itemMensaje(BuildContext context, String texto) => Container(
  margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
  child: Text(texto,
    style: TextStyle(
      color: Theme.of(context).textTheme.headline1.color,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  ),
);

Widget _itemLogro(String imagen, int length, int maxLength) => Expanded(
  child: Container(
    margin: EdgeInsets.symmetric(vertical: 30),
    child: Image(
      image: AssetImage("assets/awards/$imagen.png"),
      color: length >= maxLength ? null : Colors.grey,
      colorBlendMode: length >= maxLength ? null : BlendMode.srcATop,
      height: 100,
      width: 100,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30))
    ),
  ),
);

Container _itemTitulo(BuildContext context, String titulo) =>  Container(
  margin: EdgeInsets.symmetric(vertical: 30),
  child: Text("$titulo",
    style: TextStyle(
      color: Theme.of(context).textTheme.headline1.color,
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
  )
);

void mostrarBottomSheetMG(BuildContext context, int numMeGusta){
  List<String> _randomMensajes = ['Ya has dado $numMeGusta me gusta, ¡sigue así!', '¡Es tu $numMeGusta me gusta!', 'Es tu $numMeGusta me gusta, ¡los ❤️ no paran!', 'Llegas a tu $numMeGustaº me gusta, ¡vaya papaya!'];
  Random _random = new Random();
  String _mensaje = _randomMensajes[_random.nextInt(_randomMensajes.length)];
  if(numMeGusta == 1){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("diploma"),
            _itemMensaje(context, "Es tu primer  ❤️, ¡esperemos que no sea el último!"),
          ],
        );
      }
    );
  }else if(numMeGusta == 5){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("medal"),
            _itemMensaje(context, "¡Has llegado a tu 5º ❤️!"),
          ],
        );
      }
    );      
  }else if(numMeGusta > 5 && numMeGusta < 20 && numMeGusta % 5 == 0){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Sigue así!"),
            _imagen("medal"),
            _itemMensaje(context, _mensaje),
          ],
        );
      }
    );       
  }else if(numMeGusta == 20){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("medal2"),
            _itemMensaje(context, "Es tu me gusta número 20, ¡que no pare la cosa!"),
          ],
        );
      }
    );       
  }else if(numMeGusta == 27){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "VEINTISIETE"),
            _imagen("medal2"),
            _itemMensaje(context, "VEINTISIETE"),
          ],
        );
      }
    );       
  }else if(numMeGusta > 20 && numMeGusta < 100 && numMeGusta % 10 == 0){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Sigue así!"),
            _imagen("trophy"),
            _itemMensaje(context, _mensaje),
          ],
        );
      }
    );      
  }else if(numMeGusta == 100){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("trophy2"),
            _itemMensaje(context, "¡Has llegado a los 100 ❤️!"),
          ],
        );
      }
    );      
  }else if(numMeGusta > 100 && numMeGusta & 10 == 0){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("trophy2"),
            _itemMensaje(context, _mensaje),
          ],
        );
      }
    );      
  }
}

void mostrarBottomSheetCompletados(BuildContext context, int numCompletados){
  List<String> _randomMensajes = ['Ya has completado $numCompletados juegos, ¡sigue así!', '¡Has completado $numCompletados juegos!', 'Es tu $numCompletadosº juego completado, ¡el mando echa humo!', 'Llegas a tu $numCompletadosº juego completado, ¡vaya papaya!'];
  Random _random = new Random();
  String _mensaje = _randomMensajes[_random.nextInt(_randomMensajes.length)];

  if(numCompletados == 1){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("mando_verde_nobg"),
            _itemMensaje(context, "Has completado tu primer juego, ¡esperemos que no sea el último!"),
          ],
        );
      }
    );
  }else if(numCompletados == 5){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("mando_verde_nobg"),
            _itemMensaje(context, "¡Ya has completado 5 juegos!"),
          ],
        );
      }
    );      
  }else if(numCompletados > 5 && numCompletados < 20 && numCompletados % 5 == 0){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Sigue así!"),
            _imagen("mando_verde_nobg"),
            _itemMensaje(context, _mensaje),
          ],
        );
      }
    );       
  }else if(numCompletados == 20){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("mando_bronce_nobg"),
            _itemMensaje(context, "Y ya van 20, ¡que los juegos no paren!"),
          ],
        );
      }
    );       
  }else if(numCompletados == 27){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "VEINTISIETE"),
            _imagen("mando_bronce_nobg"),
            _itemMensaje(context, "VEINTISIETE"),
          ],
        );
      }
    );       
  }else if(numCompletados > 20 && numCompletados < 100 && numCompletados % 10 == 0){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Sigue así!"),
            _imagen("mando_plata_nobg"),
            _itemMensaje(context, _mensaje),
          ],
        );
      }
    );      
  }else if(numCompletados == 100){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Nuevo logro!"),
            _imagen("mando_oro_nobg"),
            _itemMensaje(context, "¡Has llegado a los 100 juegos completados!"),
          ],
        );
      }
    );      
  }else if(numCompletados > 100 && numCompletados & 10 == 0){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _upBar,
            _itemTitulo(context, "¡Sigue así!"),
            _imagen("mando_oro_nobg"),
            _itemMensaje(context, _mensaje),
          ],
        );
      }
    );      
  }
}

void mostrarBottomSheetLogros(BuildContext context, int lengthMG, int lengthCompletado){
  showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    context: context,
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _upBar,
          _itemTitulo(context, "Logros"),
          Expanded(
            child: ListView(
              children: [
                Row(
                  children: <Widget>[
                    _itemLogro("diploma", lengthMG, 1),
                    _itemLogro("medal", lengthMG, 5),
                    _itemLogro("medal2", lengthMG, 20),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _itemLogro("trophy", lengthMG, 50),
                    _itemLogro("trophy2", lengthMG, 100),
                    _itemLogro("mando_verde_nobg", lengthCompletado, 1),
                  ],
                ),
                Row(
                  children: <Widget>[
                    _itemLogro("mando_bronce_nobg", lengthCompletado, 20),
                    _itemLogro("mando_plata_nobg", lengthCompletado, 50),
                    _itemLogro("mando_oro_nobg", lengthCompletado, 100),
                  ],
                ),
              ],
            ),
          ),

        ],
      );
    }
  );  
}

