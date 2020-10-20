import 'package:flutter/material.dart';
import 'package:estilos/src/pages/home_screen.dart';
import 'package:estilos/models/user.dart';
import 'package:estilos/src/pages/authenticate/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    // return either Home or Authenticate widget
    if(user == null){
      return Authenticate();
    } else {
      return Home();
    }
  }
}