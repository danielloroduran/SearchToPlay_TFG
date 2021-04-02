import 'package:SearchToPlay/secciones/login.dart';
import 'package:SearchToPlay/secciones/registro.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SearchToPlay',
      initialRoute: '/',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightGreen,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.black,
          ),
          subtitle1: TextStyle(
            color: Colors.grey[800]
          ),
          subtitle2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          )
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightGreen,
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
          subtitle1: TextStyle(
            color: Colors.grey
          ),
          subtitle2: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          )
        )
      ),
      home: RegistroPage(),
    );
  }
}

