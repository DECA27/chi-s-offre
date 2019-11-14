import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/second_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as prefix0;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  get style => null;
  bool _incorrectCredentials = false;
  bool _isLoading = false;
  int tapCounter = 0;
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);
  bool _obscureText = true;
  @override
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _isLoading = true;
      });
      final email = await _readEmail();
      final password = await _readPassword();
      if (email != null && password != null) {
        _login(email, password);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeigth = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 100 * 90,
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
      return Scaffold(
          body: Container(
              height: MediaQuery.of(context).size.height / 100 * 100,
              color: backgroundColor,
              child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    Center(
                        child: Column(children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (tapCounter > 5) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('App sviluppata da:',
                                        textAlign: TextAlign.center),
                                    content: Text(
                                        "  -De Cataldo Biagio\n  -Barbaro Giovanni\n  -Caruso Luigi"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          'Ok',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                          tapCounter++;
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: screenHeigth / 100 * 4),
                          child: SizedBox(
                            width: screenWidth / 100 * 50,
                            child: Image.asset(
                              "assets/images/Asset 15.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 100 * 6,
                            left: MediaQuery.of(context).size.width / 100 * 8,
                            right: MediaQuery.of(context).size.width / 100 * 8,
                            bottom:
                                MediaQuery.of(context).size.height / 100 * 2.5),
                        child: TextFormField(
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
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: pinkColor)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            errorText: 'Inserisci la tua email',
                            hintStyle: TextStyle(color: pinkColor),
                            focusColor: pinkColor,
                            helperStyle: TextStyle(color: pinkColor),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: pinkColor)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onSaved: (val) => setState(() {
                            _email = val;
                          }),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 100 / 2,
                            left: MediaQuery.of(context).size.width / 100 * 8,
                            right: MediaQuery.of(context).size.width / 100 * 8,
                            bottom:
                                MediaQuery.of(context).size.height / 100 * 2.5),
                        child: TextFormField(
                            initialValue: "",
                            cursorColor: pinkColor,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'CAMPO OBBLIGATORIO';
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
                                    borderSide: BorderSide(color: pinkColor)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                errorText: 'Inserisci la tua password',
                                hintText: "Password",
                                hintStyle: TextStyle(color: pinkColor),
                                errorStyle: TextStyle(color: pinkColor),
                                errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: pinkColor)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: pinkColor))),
                            onSaved: (val) => setState(() {
                                  _password = val;
                                })),
                      ),
                      Container(
                          child: _incorrectCredentials
                              ? Text(
                                  'Email o Password errati',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 15),
                                )
                              : null),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 100 * 2,
                            left: MediaQuery.of(context).size.width / 100 * 8,
                            right: MediaQuery.of(context).size.width / 100 * 8,
                            bottom:
                                MediaQuery.of(context).size.height / 100 * 0.1),
                        child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width / 4,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                              });

                              _formKey.currentState.save();
                              if (_formKey.currentState.validate()) {
                                _save(_email, _password);

                                _login(_email, _password);
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
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeigth / 100 * 3,
                              horizontal: screenWidth / 100),
                          child: Text('Non sei registrato?')),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: pinkColor,
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Registrazione(),
                                    type: PageTransitionType.fade));
                          },
                          child: Text(
                            'REGISTRATI',
                            style: TextStyle(color: Colors.white),
                          ))
                    ]))
                  ]))));
    }
  }

  _save(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  Future<String> _readEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<String> _readPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('password');
  }

  Future<void> _login(String email, String password) async {
    Authorization.login(email, password).then((validated) => {
          if (validated)
            {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/events', (Route<dynamic> route) => false)
            }
          else
            {
              setState(() {
                _incorrectCredentials = true;
                _isLoading = false;
              })
            }
        });
  }
}
