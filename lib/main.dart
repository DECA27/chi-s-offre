import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/login.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/screens/info_page.dart';

import 'package:fides_calendar/screens/second_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<Null> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  get locator => null;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/events': (context) => ListaEventi()
      },
      debugShowCheckedModeBanner: false,
      title: 'FIDES_CALENDAR',
      color: Colors.red,
    );
  }
}
