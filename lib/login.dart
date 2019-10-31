import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/second_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as prefix0;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  get style => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 200,
                                child: Image.asset(
                                  "assets/images/Asset 2.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 60, left: 20, right: 20),
                                child: TextFormField(
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
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    hintText: "Email",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                  ),
                                  onSaved: (val) => setState(() {
                                    _email = val;
                                  }),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 40, left: 20, right: 20),
                                child: TextFormField(
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
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            20.0, 15.0, 20.0, 15.0),
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0))),
                                    onSaved: (val) => setState(() {
                                          _password = val;
                                        })),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 40, left: 20, right: 20),
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: Color.fromRGBO(174, 0, 17, 1),
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(
                                        20.0, 15.0, 20.0, 15.0),
                                    onPressed: () {
                                      _formKey.currentState.save();
                                      if (_formKey.currentState.validate()) {
                                        Authorization.login(_email, _password)
                                            .then((validated) => {
                                                  if (validated)
                                                    {
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              '/events',
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false)
                                                    }
                                                  else
                                                    {
                                                      print(
                                                          'Incorrect email or password')
                                                    }
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
                                  margin: EdgeInsets.only(top: 20, bottom: 20),
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
                            ])
                      ]))))
        ],
      ),
    );
  }
}
