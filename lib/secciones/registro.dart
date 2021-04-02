import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';

class RegistroPage extends StatefulWidget{

  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage>{

  bool _estaCargando;
  bool _passwordVisible;
  bool _validateUsuario, _validateEmail, _validatePassword;
  String _falloUsuario, _falloEmail, _falloPassword;
  TextEditingController _usuarioController;
  TextEditingController _emailController;
  TextEditingController _passwordController;

  void initState(){
    super.initState();
    _estaCargando = false;
    _validateUsuario = false;
    _validateEmail = false;
    _validatePassword = false;
    _passwordVisible = false;
    _usuarioController = new TextEditingController();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _emailController.text = "";
    _falloUsuario = "";
    _falloPassword = "";
    _falloEmail = "";
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: _getAppbar(context),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
            child: TextField(
              controller: _usuarioController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: "USUARIO",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorText: _validateUsuario == true ? _falloUsuario : null,
                enabled: true,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                )
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
            child: TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: "EMAIL",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                enabled: true,
                errorText: _validateEmail == true ? _falloEmail : null,
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
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
                    color: Colors.red
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorText: _validatePassword == true ? _falloPassword : null,
                helperText: "Más de 5 caracteres, con al menos número, una letra mayúscula, una minúscula y un caracter especial",
                helperMaxLines: 2,
              ),
              obscureText: _passwordVisible == true ? false : true,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock),
                hintText: "REPETIR CONTRASEÑA",
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
                    color: Colors.red
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                errorText: _validatePassword == true ? _falloPassword : null,
              ),
              obscureText: _passwordVisible == true ? false : true,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(height: 55),
              child: ElevatedButton(
                child: _estaCargando == false ? Text("Registrarse",
                  style: TextStyle(
                    fontSize: 17,
                    color: Theme.of(context).textTheme.subtitle2.color,
                  ),
                ) : CircularProgressIndicator.adaptive(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  primary: HexColor('#4fc522')
                ),
                onPressed: (){
                  _comprobacion();
                },
              )
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 10, 10, 10),
              child: Text("o también puede",
                style: Theme.of(context).textTheme.subtitle1
              ),
            )
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
                    onPressed: (){

                    },
                  )
                )
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("¿Ya tiene cuenta?",
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).textTheme.subtitle1.color,
                  ),
                ),
                TextButton(
                  child: Text("Inicia sesión",
                    style: TextStyle(
                      fontSize: 15,
                      color: HexColor('#4fc522'),
                    ),
                  ),
                  onPressed: (){

                  },
                )
              ],
            )
          )
        ],
      )
    );
  }

  Widget _getAppbar(BuildContext context){
    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        alignment: Alignment.bottomCenter,
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: "Volver atrás",
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            SizedBox(width: 100),
            Expanded(
              child: Text("Registro",
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Theme.of(context).textTheme.headline6.color
                ),
              ),
            ),
          ],
        )
      )
    );
  }

  void _comprobacion(){
    setState(() {
      _estaCargando = true;
    });
    Pattern patron = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = new RegExp(patron);

    if(_passwordController.text.isEmpty && _usuarioController.text.isEmpty){
      setState(() {
        _validateUsuario = true;
        _falloUsuario = "Este campo no puede estar en blanco";
        _validatePassword = true;
        _falloPassword = "Este campo no puede estar en blanco";
        _estaCargando = false;
      });
    }else if(_usuarioController.text.isEmpty){
      setState(() {
        _validateUsuario = true;
        _falloUsuario = "Este campo no puede estar en blanco";
        _validatePassword = false;
        _falloPassword = "";
        _estaCargando = false;
      });  
    }else if(_passwordController.text.isEmpty){
      setState(() {
        _validateUsuario = false;
        _falloUsuario = "";
        _validatePassword = true;
        _falloPassword = "Este campo no puede estar en blanco";
        _estaCargando = false;
      });
    }else if(!regex.hasMatch(_passwordController.text) ||  _passwordController.text.length < 6){
      setState(() {
        _validateUsuario = false;
        _falloUsuario = "";
        _validatePassword = true;
        _falloPassword = "La contraseña no cumple con la seguridad requerida";
        _estaCargando = false;
      });                    
    }else{
      setState(() {
        _validateUsuario = false;
        _falloUsuario = "";
        _validatePassword = false;
        _falloPassword = "";
        _estaCargando = true;
      });
    //_registrarse();
    }


  }
}