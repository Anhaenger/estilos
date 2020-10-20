import 'package:estilos/src/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:estilos/src/pages/shared/form_style.dart';
import 'package:estilos/src/pages/shared/loading.dart';
import 'package:estilos/src/services/auth_service.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  final AuthService _auth = AuthService();
  final HomePageState _authG = HomePageState();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  //GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,

      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            Image(
                  image: AssetImage("assets/estilos_logoD.png"),
                  height: 60.0
            ),
            SizedBox(height: 50.0),
            Text(
              'Inicia sesión con tu correo',
            ),
            SizedBox(height: 20.0),
            TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Correo'),
                validator: (val) => val.isEmpty ? 'Ingresa un correo' : null,
                onChanged: (val) {
                  setState(() => email = val);
                }),
            SizedBox(height: 20.0),
            TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Contraseña'),
                obscureText: true,
                validator: (val) =>
                    val.length < 6 ? 'Ingresa una contraseña con al menos 6 valores' : null,
                onChanged: (val) {
                  setState(() => password = val);
                }),
            SizedBox(height: 20.0, width: 100.0),
            ButtonTheme(
              minWidth: 320.0,
              height: 40.0,
              child: RaisedButton(
                  color: Colors.black87,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInMethod(email, password);
                      if (result == null) {
                        setState(() {
                            error = 'El correo o la contraseña son incorrectos';
                            loading = false;
                        });
                      }
                    }
                  }),
            ),
            SizedBox(height: 12.0),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14.0),
            ),
            SizedBox(height: 20.0, width: 100.0),
            OutlineButton(
              splashColor: Colors.grey,
              onPressed: () async {
                _authG.signInWithGoogle();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,
              borderSide: BorderSide(color: Colors.black87),
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/google_logo.png"),
                        height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Inicia sesión con Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        '¿No tienes cuenta? Regístrate aquí',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
