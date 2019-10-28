import 'package:fides_calendar/firstpage.dart';
import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/login.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:camera/camera.dart';
import 'package:fides_calendar/screens/info_page.dart';

import 'package:flutter/material.dart';
List<CameraDescription> cameras;

Future<Null> main() async{
  cameras = await availableCameras();
  runApp(MyApp());
  }

class MyApp extends StatelessWidget {
  get locator => null;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FIDES_CALENDAR',
      color: Colors.red,
      home: Scaffold(body: Registrazione()),
    );
  }
}
