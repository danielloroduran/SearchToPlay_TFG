import 'package:SearchToPlay/secciones/tab.dart';
import 'package:SearchToPlay/servicios/firebaseservice.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';

class RegistroPage extends StatefulWidget{

  final UserService us;

  RegistroPage(this.us);
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage>{

  User _user;
  bool _estaCargando;
  bool _passwordVisible;
  bool _validateUsuario, _validateEmail, _validatePassword, _validateSecondPassword;
  String _falloUsuario, _falloEmail, _falloPassword;
  TextEditingController _usuarioController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _secondPasswordController;

  void initState(){
    super.initState();
    _estaCargando = false;
    _validateUsuario = false;
    _validateEmail = false;
    _validatePassword = false;
    _validateSecondPassword = false;
    _passwordVisible = false;
    _usuarioController = new TextEditingController();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _secondPasswordController = new TextEditingController();
    _emailController.text = "";
    _falloUsuario = "";
    _falloPassword = "";
    _falloEmail = "";
  }

  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0,
        centerTitle: true,
        title: new Text("Registro",
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w500,
          fontSize: 30,
          color: Theme.of(context).textTheme.headline6.color
        ),
          ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: IconButton(
              tooltip: "Volver atrás",
              icon: Icon(Icons.arrow_back_ios),
              onPressed: (){
                Navigator.pop(context);
              },
          ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(25, 60, 25, 15),
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
                  focusColor: Colors.white,
                  errorText: _validateUsuario == true ? _falloUsuario : null,
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
              padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
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
                  focusColor: Colors.white,
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
              padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
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
                  focusColor: Colors.white,
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
              padding: EdgeInsets.fromLTRB(25, 15, 25, 10),
              child: TextField(
                controller: _secondPasswordController,
                textInputAction: TextInputAction.done,
                onSubmitted: (value){
                  _comprobacion();
                  FocusScope.of(context).unfocus();
                },
                onChanged: (text){
                  if(_passwordController.text.isNotEmpty && text != _passwordController.text){
                    setState(() {
                      _validateSecondPassword = true;
                    });
                  }else{
                    setState(() {
                      _validateSecondPassword = false;
                    });
                  }
                },
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
                  focusColor: Colors.white,
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
                  errorText: _validateSecondPassword == true ? "Las contraseñas no coinciden" : null,
                ),
                obscureText: _passwordVisible == true ? false : true,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(25, 20, 25, 10),
              child: _estaCargando == false ?ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 55),
                child: ElevatedButton(
                  child:  Text("Registrarse",
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).textTheme.subtitle2.color,
                    ),
                  ),
                  onPressed: (){
                    _comprobacion();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    primary: HexColor('#4fc522'),
                  )
                )
              ) : Center(child: CircularProgressIndicator()),
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
                      text: "Iniciar sesión con Google",
                      onPressed: () async{
                        await widget.us.signInGoogle().then((value) => {
                          setState((){
                            _user = value;
                          }),
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TabPage(_user, widget.us)))
                        });
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
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            )
          ],
        ),
      )
    );
  }

  void _comprobacion(){
    setState(() {
      _estaCargando = true;
    });
    Pattern patron = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~+]).{8,}$';
    RegExp regex = new RegExp(patron);

    if(_emailController.text.isEmpty && _passwordController.text.isEmpty && _usuarioController.text.isEmpty){
      setState(() {
        _validateEmail = true;
        _falloEmail = "Este campo no puede estar en blanco";
        _validateUsuario = true;
        _falloUsuario = "Este campo no puede estar en blanco";
        _validatePassword = true;
        _falloPassword = "Este campo no puede estar en blanco";
        _estaCargando = false;
      });
    }else if(_emailController.text.isEmpty && _usuarioController.text.isEmpty){
      setState(() {
        _validateEmail = true;
        _falloEmail = "Este campo no puede estar en blanco";
        _validateUsuario = true;
        _falloUsuario = "Este campo no puede estar en blanco";
        _validatePassword = false;
        _falloPassword = "";
        _estaCargando = false;
      });
    }else if(_emailController.text.isEmpty && _passwordController.text.isEmpty){
      setState(() {
        _validateEmail = true;
        _falloEmail = "Este campo no puede estar en blanco";
        _validatePassword = true;
        _falloPassword = "Este campo no puede estar en blanco";
        _validateUsuario = false;
        _falloUsuario = "";
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
    }else if(!regex.hasMatch(_passwordController.text) ||  _passwordController.text.length < 5){
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
    _registrarse();
    }
  }

  void _registrarse() async{

    try{
      _user = await widget.us.createUser(_emailController.text, _passwordController.text);
      if(_user != null){
        _user.updateProfile(displayName: _usuarioController.text);
        FirebaseService fs = new FirebaseService(_user.uid);
        Map<String, dynamic> userMap = {"email" : _user.email};
        fs.addUser(userMap);
        _user.sendEmailVerification();
        _dialogoEmail();
      }

    }catch(e){
      switch(e.message.code){
        case "invalid-email":
          setState(() {
            _validateEmail = true;
            _falloEmail = "Email no válido";
          });
          break;
        case "email-already-in-use":
          setState(() {
            _validateEmail = true;
            _falloEmail = "Este email ya está en uso";
          });
          break;
        default:
          setState((){
            _validateEmail = false;
            _falloEmail = "";
          });
      }
    }
  }

  void _dialogoEmail(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          title: new Text("Email de verificación enviado",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          content: new Text("Se ha enviado un email para que verifique su correo electrónico y poder acceder a la aplicación",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,              
            )
          ),
          actions: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                new TextButton(
                  child: new Text("Aceptar",
                    style: TextStyle(
                      color: HexColor('#4fc522'),
                    )
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        );
      }
    );
  }

  

}