import 'dart:math';
import 'package:flutter/material.dart';

// Algunas de las imágenes utilizadas como trofeos han sido obtenidas de www.flaticon.com

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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/diploma.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("Es tu primer  ❤️, ¡esperemos que no sea el último!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/medal.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("¡Has llegado a tu 5º ❤️!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/medal.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text(_mensaje,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/medal2.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("Es tu me gusta número 20, ¡que no pare la cosa!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("VEINTISIETE",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/medal2.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("VEINTISIETE",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/trophy.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text(_mensaje,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/trophy2.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("¡Has llegado a los 100 ❤️!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/trophy2.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text(_mensaje,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_verde_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("Has completado tu primer juego, ¡esperemos que no sea el último!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_verde_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("¡Ya has completado 5 juegos!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_verde_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text(_mensaje,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_bronce_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("Y ya van 20, ¡que los juegos no paren!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_bronce_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("VEINTISIETE",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_plata_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text(_mensaje,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_oro_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text("¡Has llegado a los 100 juegos completados!",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
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
              child: Text("Nuevo logro",
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Image(
                image: AssetImage("assets/awards/mando_oro_nobg.png"),
                height: 150,
                width: 150,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Text(_mensaje,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }
    );      
  }
}

