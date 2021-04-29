import 'package:SearchToPlay/secciones/tab.dart';
import 'package:SearchToPlay/secciones/registro.dart';
import 'package:SearchToPlay/servicios/userservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget{

  final UserService us;
  LoginPage(this.us);
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  User _user;
  String _falloEmail, _falloPassword;
  bool _validateEmail, _validatePassword;
  bool _passwordVisible;
  bool _estaCargando;


  void initState(){
    super.initState();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _validateEmail = false;
    _validatePassword = false;
    _passwordVisible = false;
    _estaCargando = false;
    _falloEmail = "Email no válido";
    _falloPassword = "";
  }

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
      child: Scaffold(
        body: new Container(
          color: Theme.of(context).backgroundColor,
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
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 15),
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
                      focusColor: Colors.white,
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
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                  child: TextField(
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (value){
                      _comprobacion();
                      FocusScope.of(context).unfocus();
                    },
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
                      focusColor: Colors.white,
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
                  child: _estaCargando == false ? ConstrainedBox(
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
                  ) : Center(child: CircularProgressIndicator(),)
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
                          onPressed: () async {
                            await widget.us.signInGoogle().then((value) => {
                              setState((){
                                _user = value;
                              })
                            });
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabPage(_user, widget.us)));
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
                          _passwordOlvidada(context);
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RegistroPage(widget.us)));
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
        _estaCargando = true;
        _validateEmail = false;
        _validatePassword = false;
        _falloEmail = "";
        _falloPassword = "";
      });
      iniciarSesion();
    }
  }

  void iniciarSesion() async {
    final formState = _formKey.currentState;
    if(formState.validate()){
      formState.save();
      try{
        _user = await widget.us.signInEmail(_emailController.text, _passwordController.text);
        if(_user != null && _user.emailVerified){
          setState(() {
            _estaCargando = false;
          });
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TabPage(_user, widget.us)));
        }else{
          setState(() {
            _estaCargando = false;
          });
          _dialogoEmail();
        }
      }catch(e){
        switch(e.message.code){
          case "invalid-email":
          setState(() {
            _falloEmail = "Email incorrecto";
            _validateEmail = true;
            _estaCargando = false;
          });
          break;
          case "user-not-found":
          setState(() {
            _falloEmail = "Email no encontrado";
            _validateEmail = true;
            _estaCargando = false;
          });
          break;
          case "wrong-password":
          setState(() {
            _falloPassword = "Contraseña incorrecta";
            _validatePassword = true;
            _estaCargando = false;
          });
          break;
        }
      }
    }
  }

  void _dialogoEmail(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: new Text("Email sin verificar",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.headline6.color,
            ),
          ),
          content: new Text("Parece que no ha verificado su email. En caso de no haber recibido el enlace de confirmación, pulse Reenviar",
            style: TextStyle(
              color: Theme.of(context).textTheme.headline6.color,              
            )
          ),
          actions: <Widget>[
            new Row(
              children: <Widget>[
                new TextButton(
                  child: new Text("Cerrar",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.subtitle2.color,
                    )
                  ),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                new TextButton(
                  child: new Text("Reenviar",
                    style: TextStyle(
                      color: Theme.of(context).buttonColor,
                    )
                  ),
                  onPressed: (){
                    _user.sendEmailVerification();
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ],
        );
      }
    );
  }

  void _passwordOlvidada(context){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: new Text("Contraseña olvidada",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.headline6.color,
                ),
              ),
              content: new Container(
                height: _validateEmail ? 207 : 183,
                width: 300,
                child: new Column(
                  children: <Widget>[
                    SizedBox(height: 4),
                    Text("Introduzca el email al que le será enviado el enlace de recuperación de contraseña",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                    ),
                    SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: new TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "EMAIL",
                          prefixIcon: Icon(Icons.email),
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
                            borderRadius: BorderRadius.circular(20),
                          ),
                          errorText: _validateEmail ? _falloEmail : null,
                        ),
                        autofocus: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: new Text("Cerrar",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.subtitle2.color,
                            ),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: new Text("Enviar",
                            style: TextStyle(
                              color: Theme.of(context).buttonColor,
                            )
                          ),
                          onPressed: (){
                            if(_emailController.text.isEmpty){
                              setState((){
                                _validateEmail = true;
                                _falloEmail = "Este campo no puede estar en blanco";
                              });
                            }else{
                              widget.us.newPassword(_emailController.text);
                              setState((){
                                _validateEmail = false;
                                _falloEmail = "";
                                _emailController.text = "";
                              });
                              Navigator.pop(context);
                            }
                          }
                        )
                      ],
                    )
                  ],
                )
              )
            );
          }
        );
      }
    );
  }

}
