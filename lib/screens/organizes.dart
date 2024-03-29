import 'dart:io';

import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/util/loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';

class Organizes extends StatefulWidget {
  final id;
  final bool creating;
  final Function updateDescriptionCallback;
  

  const Organizes(
      {Key key,
      @required this.id,
      @required this.creating,
      @required this.updateDescriptionCallback})
      : super(key: key);
  @override
  _OrganizesState createState() => _OrganizesState();
}

class _OrganizesState extends State<Organizes> {
  final _formKey = GlobalKey<FormState>();
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  String _description;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
     if (_isLoading) {
      return Loader.getLoader(context);
    } else {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: 100, left: 20, right: 20, bottom: 50),
                  width: 320,
                  height: 400,
                  child: TextFormField(
                    initialValue: "",
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Scrivi qui",
                    ),
                    onSaved: (val) => setState(() {
                      _description = val;
                    }),
                  ),
                ),
              ),
      
              RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: pinkColor,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    _formKey.currentState.save();
                    http.Response response;

                    response = await http.put(
                        "${Environment.siteUrl}/event/${this.widget.id}/description",
                        headers: {
                          HttpHeaders.authorizationHeader: Authorization.token
                        },
                        body: {
                          'description': _description
                        });

                    if (response.statusCode == 200) {
                      this.widget.updateDescriptionCallback();
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text(
                    'INVIA DESCRIZIONE',
                    style: TextStyle(color: Colors.white),
                  ))
            ]),
      ),
    );
  }
}
}