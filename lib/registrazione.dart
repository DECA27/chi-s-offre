import 'dart:convert';
import 'dart:math';

import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/screens/second_page.dart';
import 'package:fides_calendar/util/days_month.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class FormData {
  String email;
  String password;
  String firstName;
  String lastName;
  int birthDateMonth;
  int birthDateDay;

  Map<String, String> toJson() {
    return {
      'birthDateDay': birthDateDay.toString(),
      'birthDateMonth': birthDateMonth.toString(),
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

class Registrazione extends StatefulWidget {
  @override
  _RegistrazioneState createState() => _RegistrazioneState();
}

class _RegistrazioneState extends State<Registrazione> {
  FormData userData = new FormData();

  int _day = 1;
  int _month = 1;
  bool showDay = false;
  final _formKey = GlobalKey<FormState>();

  Future<Iterable> _saveUser(Map user) async {
    Iterable errors = [];
    var client = new http.Client();
    print(user);
    try {
      final response = await client.post(
          "https://immense-anchorage-57010.herokuapp.com/api/users",
          body: user);

      if (response.statusCode == 422) {
        errors = jsonDecode(response.body);
      } else if (response.statusCode == 200) {
        Authorization.token = "Bearer "+response.body;
      } else {
        throw Exception('Failed to load events');
      }
      return errors;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin:
                        EdgeInsets.only(top: 30, left: _offset, right: _offset),
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'CAMPO OBBLIGATORIO';
                        }
                        return null;
                      },
                      obscureText: false,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        hintText: "Nome",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                      onSaved: (val) => setState(() {
                        userData.firstName = val;
                      }),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: _offset, left: _offset, right: _offset),
                    child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'CAMPO OBBLIGATORIO';
                          }
                          return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Cognome",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        onSaved: (val) => setState(() {
                              userData.lastName = val;
                            })),
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
                        if (_day > DaysMonth.daysInMonth(_month)) {
                          _day = DaysMonth.daysInMonth(_month);
                        }
                        userData.birthDateMonth = _month;

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
                          userData.birthDateDay = _day;
                        });
                      }),
                  Container(
                    margin: EdgeInsets.only(
                        top: _offset, left: _offset, right: _offset),
                    child: TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'CAMPO OBBLIGATORIO';
                          }
                          if (!value.contains('@')) {
                            return 'EMAIL NON VALIDA';
                          }

                          return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        onSaved: (val) => setState(() {
                              userData.email = val;
                            })),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: _offset, left: _offset, right: _offset),
                    child: TextFormField(
                        
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'CAMPO OBBLIGATORIO';
                          }

                          if (value.length < 6) {
                            return 'MINIMO 6 CARATTERI';
                          }

                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0))),
                        onSaved: (val) => setState(() {
                              userData.password = val;
                            })),
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
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate())
                            _saveUser(userData.toJson())
                                .then((errors) => {
                                      if (errors.length > 0)
                                        {print(errors)}
                                      else
                                        {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: SecondPage(),
                                                  type: PageTransitionType
                                                      .rightToLeft))
                                        }
                                    })
                                .catchError((error) => {print(error)});
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
          ),
        ],
      ),
    );
  }
}
