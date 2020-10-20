import 'package:flutter/material.dart';
import 'package:estilos/src/pages/shared/form_style.dart';
import 'package:estilos/src/pages/shared/loading.dart';
import 'package:estilos/src/services/auth_service.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            widget.toggleView();
          },
          child: Icon(Icons.keyboard_arrow_left),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.keyboard_arrow_left),
            label: Text('Regresar'),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            Image(image: AssetImage("assets/estilos_logoD.png"), height: 60.0),
            SizedBox(height: 50.0),
            Text(
              'Regístrate con tu correo',
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
                decoration:
                    textInputDecoration.copyWith(hintText: 'Contraseña'),
                obscureText: true,
                validator: (val) => val.length < 6
                    ? 'Ingresa una contraseña con al menos 6 valores'
                    : null,
                onChanged: (val) {
                  setState(() => password = val);
                }),
            SizedBox(height: 20.0, width: 30.0),
            ButtonTheme(
              minWidth: 320.0,
              height: 40.0,
              child: RaisedButton(
                  color: Colors.black87,
                  child: Text(
                    'Registrar cuenta',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result =
                          await _auth.registerMethod(email, password);
                      if(result == null){
                        setState(() {
                            error = 'Por favor utiliza un correo válido';
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
          ]),
        ),
      ),
    );
  }
}
