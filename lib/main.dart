import 'package:SearchToPlay/secciones/root.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(411.43, 806.86),
      builder: () => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus.unfocus(),
        child: MaterialApp(
          title: 'SearchToPlay',
          initialRoute: '/',
          theme: ThemeData(
            accentColor: HexColor('#4fc522'),
            buttonColor: HexColor('#4fc522'),
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            primarySwatch: Colors.lightGreen,
            textTheme: TextTheme(
              headline1: TextStyle(
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
            tabBarTheme: TabBarTheme(
              labelColor: HexColor('#4fc522'),
              unselectedLabelColor: HexColor('#858585'),
              
            ),

            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          darkTheme: ThemeData(
            accentColor: HexColor('#4fc522'),
            buttonColor: HexColor('#4fc522'),
            brightness: Brightness.dark,
            primarySwatch: Colors.lightGreen,
            backgroundColor: Colors.black,
            textTheme: TextTheme(
              headline1: TextStyle(
                color: Colors.white,
              ),
              subtitle1: TextStyle(
                color: Colors.grey
              ),
              subtitle2: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              )
            ),
            tabBarTheme: TabBarTheme(
              labelColor: HexColor('#4fc522'),
              unselectedLabelColor: HexColor('#858585'),
            ),
          ),
          home: new RootPage(us: new UserService()),
        ),
      ),
    );
  }
}

