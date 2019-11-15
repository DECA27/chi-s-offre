import 'dart:convert';
import 'dart:math';

import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
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
  bool _isLoading = false;
  int _day = 1;
  int _month = 1;
  bool showDay = false;
  final _formKey = GlobalKey<FormState>();
  String _errorsMessage = '';
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);
  bool _obscureText = true;
  @override
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<Iterable> _saveUser(Map user) async {
    Iterable errors = [];
    var client = new http.Client();
    print(user);
    try {
      final response = await client.post(
          "${Environment.siteUrl}users",
          body: user);

      if (response.statusCode == 422) {
        errors = jsonDecode(response.body);
      } else if (response.statusCode == 200) {
        Authorization.token = "Bearer " + response.body;
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
    if (_isLoading) {
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
                valueColor: AlwaysStoppedAnimation<Color>(pinkColor),
                strokeWidth: 5),
          ),
        ),
      );
    } else {
      AppBar appBar = AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Center(
              child: Text(
            'REGISTRAZIONE',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900, color: pinkColor),
          )),
          backgroundColor: backgroundColor,
          elevation: 0,
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
            ),
          ]);
      var screenHeigth =
          MediaQuery.of(context).size.height - appBar.preferredSize.height;
      var screenWidth = MediaQuery.of(context).size.width;
      double _offset = screenWidth / 100 * 5;

      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: appBar,
        body: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 100 * 90,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeigth / 100 * 2),
                      child: Text(
                        _errorsMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _offset,
                          vertical: screenHeigth / 100 * 1),
                      child: TextFormField(
                        style: TextStyle(fontSize: screenHeigth / 100 * 2.5),
                        initialValue: "",
                        cursorColor: pinkColor,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'CAMPO OBBLIGATORIO';
                          }
                          return null;
                        },
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: pinkColor)),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth / 100 * 5,
                              vertical: screenHeigth / 100 * 2),
                          hintText: "Nome",
                          errorText: 'Inserisci il tuo nome',
                          errorStyle: TextStyle(color: pinkColor),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: pinkColor)),
                          focusColor: pinkColor,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: pinkColor),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onSaved: (val) => setState(() {
                          userData.firstName = val;
                        }),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _offset,
                          vertical: screenHeigth / 100 * 1),
                      child: TextFormField(
                          style: TextStyle(fontSize: screenHeigth / 100 * 2.5),
                          initialValue: "",
                          cursorColor: pinkColor,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'CAMPO OBBLIGATORIO';
                            }
                            return null;
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: pinkColor)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth / 100 * 5,
                                  vertical: screenHeigth / 100 * 2),
                              hintText: "Cognome",
                              errorText: 'Inserisci il tuo cognome',
                              errorStyle: TextStyle(color: pinkColor),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: pinkColor)),
                              focusColor: pinkColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: pinkColor),
                                  borderRadius: BorderRadius.circular(10))),
                          onSaved: (val) => setState(() {
                                userData.lastName = val;
                              })),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: screenHeigth / 100 * 2),
                      color: Colors.transparent,
                      child: Text(
                        'Mese di nascita',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenHeigth / 100 * 2.5,
                            color: pinkColor),
                      ),
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
                      margin: EdgeInsets.only(top: screenHeigth / 100 * 2),
                      color: Colors.transparent,
                      child: Text(
                        'Giorno di nascita',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: screenHeigth / 100 * 2.5,
                            color: pinkColor),
                      ),
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
                      margin: EdgeInsets.symmetric(
                          horizontal: _offset,
                          vertical: screenHeigth / 100 * 1),
                      child: TextFormField(
                          style: TextStyle(fontSize: screenHeigth / 100 * 2.5),
                          initialValue: "",
                          cursorColor: pinkColor,
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
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth / 100 * 5,
                                  vertical: screenHeigth / 100 * 2),
                              hintText: "Email",
                              errorText: 'Inserisci una email',
                              errorStyle: TextStyle(color: pinkColor),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: pinkColor)),
                              focusColor: pinkColor,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: pinkColor),
                                  borderRadius: BorderRadius.circular(10.0))),
                          onSaved: (val) => setState(() {
                                userData.email = val;
                              })),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: _offset,
                          vertical: screenHeigth / 100 * 1),
                      child: TextFormField(
                          style: TextStyle(fontSize: screenHeigth / 100 * 2.5),
                          initialValue: "",
                          cursorColor: pinkColor,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'CAMPO OBBLIGATORIO';
                            }

                            if (value.length < 6) {
                              return 'MINIMO 6 CARATTERI';
                            }

                            return null;
                          },
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: pinkColor,
                                  ),
                                  onPressed: () {
                                    _toggle();
                                  },
                                ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: Colors.black)),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenWidth / 100 * 5,
                                  vertical: screenHeigth / 100 * 2),
                              hintText: "Password",
                              errorText: 'Inserisci una password',
                              errorStyle: TextStyle(color: pinkColor),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: pinkColor)),
                              focusColor: pinkColor,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0))),
                          onSaved: (val) => setState(() {
                                userData.password = val;
                              })),
                    ),
                    Expanded(
                      child: Align(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: _offset,
                              right: _offset,
                              bottom: screenHeigth / 100 * 2),
                          child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width,
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                });
                                _formKey.currentState.save();
                                if (_formKey.currentState.validate()) {
                                  userData.birthDateDay = _day;
                                  userData.birthDateMonth = _month;

                                  _saveUser(userData.toJson())
                                      .then((errors) => {
                                            if (errors.length > 0)
                                              {
                                                setState(() {
                                                  _isLoading = false;
                                                  _errorsMessage = errors
                                                      .map((error) =>
                                                          error['param'] +
                                                          ': ' +
                                                          error['msg'])
                                                      .join('\n');
                                                }),
                                                print(errors),
                                              }
                                            else
                                              {
                                                Authorization.login(
                                                    userData.email,
                                                    userData.password),
                                                {
                                                  Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          child: SecondPage(),
                                                          type:
                                                              PageTransitionType
                                                                  .rightToLeft))
                                                }
                                              }
                                          })
                                      .catchError((error) => {print(error)});
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                              child: Icon(
                                Icons.check_circle,
                                color: pinkColor,
                                size: 60,
                              )),
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
}
