import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


 class Loader{
  static Widget getLoader(BuildContext context){
     return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(237, 18, 81, 1)),
                strokeWidth: 5),
          ),
        ),
      );
  }
}