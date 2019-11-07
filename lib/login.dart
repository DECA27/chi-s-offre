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
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(174, 0, 30, 1)),
                strokeWidth: 5),
          ),
        ),
      );
    } else {
      return Scaffold(
          body: Container(
              height: MediaQuery.of(context).size.height / 100 * 100,
              color: Colors.white,
              child: Form(
                  key: _formKey,
                  child: ListView(children: <Widget>[
                    Center(
                        child: Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: screenHeigth / 100 * 4),
                        child: SizedBox(
                          width: screenWidth / 100 * 50,
                          child: Image.asset(
                            "assets/images/Asset 2.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 100 * 5,
                            left: MediaQuery.of(context).size.width / 100 * 8,
                            right: MediaQuery.of(context).size.width / 100 * 8,
                            bottom:
                                MediaQuery.of(context).size.height / 100 * 2.5),
                        child: TextFormField(
                          initialValue: "",
                          cursorColor: Colors.black,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'CAMPO OBBLIGATORIO';
                            }
                            return null;
                          },
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                                borderSide: BorderSide(color: Colors.black)),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            hintText: "Email",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                          onSaved: (val) => setState(() {
                            _email = val;
                          }),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 100,
                            left: MediaQuery.of(context).size.width / 100 * 8,
                            right: MediaQuery.of(context).size.width / 100 * 8,
                            bottom:
                                MediaQuery.of(context).size.height / 100 * 2.5),
                        child: TextFormField(
                            initialValue: "",
                            cursorColor: Colors.black,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'CAMPO OBBLIGATORIO';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32.0))),
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
                            top: MediaQuery.of(context).size.height / 100 * 5,
                            left: MediaQuery.of(context).size.width / 100 * 8,
                            right: MediaQuery.of(context).size.width / 100 * 8,
                            bottom:
                                MediaQuery.of(context).size.height / 100 * 2.5),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color.fromRGBO(174, 0, 17, 1),
                          child: MaterialButton(
                            minWidth: MediaQuery.of(context).size.width,
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
                            child: Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeigth / 100 * 5,
                              horizontal: screenWidth / 100),
                          child: Text('Non sei registrato?')),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Color.fromRGBO(174, 0, 17, 1),
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: Registrazione(),
                                    type: PageTransitionType.fade));
                          },
                          child: Text('REGISTRATI'))
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
