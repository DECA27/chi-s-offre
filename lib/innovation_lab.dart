import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InnovationLab extends StatefulWidget {
  @override
  _InnovationLab createState() => _InnovationLab();
}

class _InnovationLab extends State<InnovationLab> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(
          context, '/firstpage', (Route<dynamic> route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Image.asset(
          "assets/images/innovation lab - Copia.png",
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ));
  }
}
