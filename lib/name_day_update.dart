import 'dart:io';

import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/util/days_month.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'authorization/authorization.dart';

class NameDayUpdate extends StatefulWidget {
  @override
  _NameDayState createState() => _NameDayState();
}

class _NameDayState extends State<NameDayUpdate> {
  int _day = 1;
  int _month = 1;
  bool showDay = false;
  final _formKey = GlobalKey<FormState>();
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('AGGIORNA ONOMASTICO',style: TextStyle(fontWeight: FontWeight.w900,color: pinkColor),),
          centerTitle: true,
          backgroundColor: backgroundColor,
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 100 * 5),
                child: Text(
                  'CAMBIA IL TUO ONOMASTICO\nATTENZIONE!\nHai solo un tentativo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, bottom: 20),
                color: Colors.transparent,
                child: Text('Mese Onomastico',style: TextStyle(color: pinkColor),),
              ),
              Slider(
                inactiveColor: pinkColor,
                activeColor: pinkColor,
                min: 1,
                max: 12,
                label: _month.round().toString(),
                divisions: 100,
                value: _month.toDouble(),
                onChanged: (newRating) {
                  setState(() {
                    _month = newRating.toInt();
                    if (_day > DaysMonth.daysInMonth(_month)) {
                      _day = DaysMonth.daysInMonth(_month);
                    }

                    showDay = true;
                  });
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                color: Colors.transparent,
                child: Text('Giorno Onomastico',style: TextStyle(color: pinkColor),),
              ),
              Slider(
                  inactiveColor: pinkColor,
                  activeColor: pinkColor,
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
                margin: EdgeInsets.only(top: 65, left: 40, right: 40),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: pinkColor,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      _formKey.currentState.save();
                      if (_formKey.currentState.validate()) {
                        Response response = await http.put(
                            '${Environment.siteUrl}/user/${Authorization.getLoggedUser().id}/nameday',
                            body: {
                              "day": _day.toString(),
                              "month": _month.toString()
                            },
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  Authorization.token
                            });
                        if (response.statusCode == 200) {
                          Authorization.saveToken(response.body);
                          Navigator.pushNamedAndRemoveUntil(context, '/events',
                              (Route<dynamic> route) => false);
                        }
                      }
                    },
                    child: Text(
                      "AGGIORNA ONOMASTICO",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
