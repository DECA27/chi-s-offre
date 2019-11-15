import 'package:fides_calendar/chat.dart';
import 'package:fides_calendar/firstpage.dart';
import 'package:fides_calendar/innovation_lab.dart';
import 'package:fides_calendar/launch_screen.dart';
import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/login.dart';
import 'package:fides_calendar/name_day.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:fides_calendar/screens/second_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

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
        '/': (context) => LaunchScreen(),
        '/innovation lab': (context) => InnovationLab(),
        '/firstpage': (context) => FirstPage(),
        '/login': (context) => Login(),
        '/events': (context) => ListaEventi(),
        '/nameDayError': (context) => NameDay()
      },
      debugShowCheckedModeBanner: false,
      title: 'FIDES_CALENDAR',
    );
  }
}
