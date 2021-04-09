import 'package:SearchToPlay/secciones/root.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: new RootPage(us: new UserService()),
    );
  }
}

