import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/screens/second_page.dart';

import 'package:flutter/material.dart';

Future<Null> main() async {
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
      home: Scaffold(body: SecondPage()),
    );
  }
}
