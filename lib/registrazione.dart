import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

class Registrazione extends StatefulWidget {
  @override
  _RegistrazioneState createState() => _RegistrazioneState();
}

class _RegistrazioneState extends State<Registrazione> {
  @override
  Widget build(BuildContext context) {
    double _offset = MediaQuery.of(context).size.height / 30;
    double _slidervalue = 1;

    return Scaffold(
      appBar: AppBar(
          title: Text('REGISTRAZIONE'),
          backgroundColor: Color.fromRGBO(174, 0, 17, 1),
          elevation: 9,
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
            ),
          ]),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: _offset, left: _offset, right: _offset),
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
                TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Giorno di nascita'),
                ),
                Slider(
                  inactiveColor: Color.fromRGBO(174, 0, 17, 1),
                  activeColor: Color.fromRGBO(174, 0, 17, 1),
                  min: 1,
                  max: 31,
                  value: _slidervalue,
                  onChanged: (newRating) {
                    setState(() {
                      _slidervalue = newRating;
                    });
                  },
                ),
                TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Mese di nascita'),
                ),
                Slider(
                  inactiveColor: Color.fromRGBO(174, 0, 17, 1),
                  activeColor: Color.fromRGBO(174, 0, 17, 1),
                  min: 1,
                  max: 12,
                  value: _slidervalue,
                  onChanged: (double newRating) {
                    setState(() {
                      _slidervalue = newRating;
                    });
                  },
                ),
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
                  margin: EdgeInsets.only(
                      top: _offset, left: _offset, right: _offset),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Color.fromRGBO(174, 0, 17, 1),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () {},
                      child: Text(
                        "REGISTRATI",
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
