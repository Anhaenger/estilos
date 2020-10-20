import 'package:flutter/material.dart';
import 'package:estilos/models/user.dart';
import 'package:estilos/src/services/auth_service.dart';
import 'package:estilos/src/pages/wrapper.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value:AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}