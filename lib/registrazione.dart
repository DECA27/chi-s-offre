import 'dart:math';

import 'package:fides_calendar/screens/second_page.dart';
import 'package:fides_calendar/util/days_month.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class Registrazione extends StatefulWidget {
  @override
  _RegistrazioneState createState() => _RegistrazioneState();
}

class _RegistrazioneState extends State<Registrazione> {
  int _day = 1;
  int _month = 1;
  bool showDay = false;

  @override
  Widget build(BuildContext context) {
    double _offset = MediaQuery.of(context).size.height / 30;
    return Scaffold(
      appBar: AppBar(
          title: Center(
              child: Text(
            'REGISTRAZIONE',
            textAlign: TextAlign.center,
          )),
          backgroundColor: Color.fromRGBO(174, 0, 17, 1),
          elevation: 0,
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
            ),
          ]),
      body: ListView(
        
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Color.fromRGBO(174, 0, 17, 1),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://static.iphoneitalia.com/wp-content/uploads/2014/03/iPhone-3G3GS-22.jpg"))),
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 30, left: _offset, right: _offset),
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Nome",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: _offset, left: _offset, right: _offset),
                  child: TextField(
                    obscureText: false,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Cognome",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  color: Colors.transparent,
                  child: Text('Mese di nascita'),
                ),
                Slider(
                  inactiveColor: Colors.black38,
                  activeColor: Colors.black,
                  min: 1,
                  max: 12,
                  label: _month.round().toString(),
                  divisions: 100,
                  value: _month.toDouble(),
                  onChanged: (newRating) {

                    setState(() {

                      _month = newRating.toInt();
                      if (_day> DaysMonth.daysInMonth(_month)){
                        _day= DaysMonth.daysInMonth(_month);
                      }
                      showDay = true;
                    });
                  },
                ),
                 Container(
                  margin: EdgeInsets.only(bottom: 20),
                  color: Colors.transparent,
                  child: Text('Giorno di nascita'),
                ),
                 Slider(
                    inactiveColor: Colors.black38,
                    activeColor: Colors.black,
                    label: _day.round().toString(),
                    divisions: 200,
                    min: 1,
                    max: DaysMonth.daysInMonth(_month).toDouble(),
        
                    value: _day.toDouble(),
                    onChanged: (newRating) {
                      setState(() {
                        _day = newRating.toInt();
                      });
                    }),
                Container(
                  margin: EdgeInsets.only(
                      top: _offset, left: _offset, right: _offset),
                  child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)))),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: _offset, left: _offset, right: _offset),
                  child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Password",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0)))),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: 40, left: _offset, right: _offset),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color.fromRGBO(174, 0, 17, 1),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: SecondPage(),
                                type: PageTransitionType.rightToLeft));
                      },
                      child: Text(
                        "PROCEDI",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
