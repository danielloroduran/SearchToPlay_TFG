import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget{

  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  // FirebaseUser _user;
  String _falloEmail, _falloPassword;
  bool _validateEmail, _validatePassword;
  bool _passwordVisible;


  void initState(){
    super.initState();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _validateEmail = false;
    _validatePassword = false;
    _passwordVisible = false;
    _falloEmail = "";
    _falloPassword = "";
  }

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Scaffold(
        body: new Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 15, top: 10, bottom: 0, right: 15),
                  child: Center(
                    child: Theme.of(context).brightness == Brightness.light ? Image.asset('assets/launch_image_light.png') : Image.asset('assets/launch_image_dark.png'),
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "EMAIL",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      errorText: _validateEmail ? _falloEmail : null,
                    ),
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      hintText: "CONTRASEÑA",
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible == false ? Icons.visibility : Icons.visibility_off),
                        onPressed: (){
                          setState((){
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                      errorText: _validatePassword ? _falloPassword : null
                    ),
                    obscureText: _passwordVisible == true ? false : true,
                  )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 55),
                    child: ElevatedButton(
                      child: Text("Iniciar Sesión",
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).textTheme.subtitle2.color,
                        )
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        primary: HexColor('#4fc522')
                        
                      ),
                      onPressed: (){
                        _comprobacion();
                      },                      
                    ),
                  )
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 10, 10, 10),
                    child: Text("o también puede",
                      style: Theme.of(context).textTheme.subtitle1
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: 55),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Container(
                        child: SignInButton(
                          Buttons.Google,
                          text: "Iniciar sesión con Google",
                          onPressed: (){

                           }
                        ),
                      ),
                    ),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(
                        child: Text("¿Olvidó su contraseña?",
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).textTheme.subtitle1.color,
                          )
                        ),
                        onPressed: (){

                        },
                      ),
                      TextButton(
                        child: Text("Registrarse",
                          style: TextStyle(
                            fontSize: 15,
                            color: HexColor('#4fc522'),
                          )
                        ),
                        onPressed: (){

                        },
                      ),                  
                    ],
                  ),
                )
              ],
            )
          )
        ),
      )
    );
  }

  void _comprobacion(){
    if(_emailController.text == "" && _passwordController.text == ""){
      setState(() {
        _validateEmail = true;
        _validatePassword = true;
        _falloEmail = "Introduzca un email";
        _falloPassword = "Introduzca una contraseña";
      });                      
    }else if(_emailController.text == ""){
      setState(() {
        _validateEmail = true;
        _validatePassword = false;
        _falloEmail = "Introduzca un email";
        _falloPassword = "";
      });
    }else if(_passwordController.text == ""){
      setState(() {
        _validateEmail = false;
        _validatePassword = true;
        _falloEmail = "";
        _falloPassword = "Introduzca una contraseña";
      });
    }else{
      setState(() {
        _validateEmail = false;
        _validatePassword = false;
        _falloEmail = "";
        _falloPassword = "";
      });
      //iniciarSesion();
    }
  }
}
