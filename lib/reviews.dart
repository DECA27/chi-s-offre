import 'dart:io';

import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/util/loader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Reviews extends StatefulWidget {
  final String id;
  final Function updateDescriptionCallback;
  const Reviews(
      {Key key, @required this.id, @required this.updateDescriptionCallback})
      : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);
  final _formKey = GlobalKey<FormState>();
  String _comment;
  int _rating = 5;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Loader.getLoader(context);
    } else {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'INSERISCI UNA RECENSIONE',
            style: TextStyle(color: pinkColor, fontWeight: FontWeight.w900),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                margin:
                    EdgeInsets.only(top: 20, bottom: 50, left: 30, right: 30),
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 3,
                child: TextFormField(
                  autofocus: false,
                  initialValue: "",
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Scrivi qui la tua recensione",
                  ),
                  onSaved: (val) => setState(() {
                    this._comment = val;
                  }),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 50),
              alignment: Alignment.center,
              child: FlutterRatingBar(
                initialRating: 1,
                fillColor: pinkColor,
                borderColor: pinkColor,
                allowHalfRating: true,
                onRatingUpdate: (rating) {
                  setState(() {
                    this._rating = rating.toInt();
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 50, left: 50, top: 40),
              child: RaisedButton(
                  child: Text(
                    'INVIA RECENSIONE',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: pinkColor,
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    _formKey.currentState.save();
                    http.Response response = await http.post(
                      '${Environment.siteUrl}/event/${this.widget.id}/reviews',
                      body: {
                        "reviewer": Authorization.getLoggedUser().id,
                        "rating": _rating.toString(),
                        "comment": _comment
                      },
                      headers: {
                        HttpHeaders.authorizationHeader: Authorization.token
                      },
                    );

                    if (response.statusCode == 200) {
                      this.widget.updateDescriptionCallback();
                      Navigator.pop(context, true);
                    }
                  }),
            ),
          ],
        ),
      );
    }
  }
}
