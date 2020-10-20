import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitWanderingCubes(
          color: Colors.red,
          size: 50.0,
          ),
      ),
    );
    
  }

}