import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/util/days_month.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'authorization/authorization.dart';

class NameDay extends StatefulWidget {
  @override
  _NameDayState createState() => _NameDayState();
}

class _NameDayState extends State<NameDay> {
  int _day = 1;
  int _month = 1;
  bool showDay = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 60),
            child: SizedBox(
              width: 100,
              child: Image.network(
                  'https://i.pinimg.com/originals/a0/29/93/a029936b63331ee16b0c4e360961cd09.jpg'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Text(
              'OPS IL TUO ONOMASTICO NON È STATO GENERATO',
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 60, bottom: 20),
            color: Colors.transparent,
            child: Text('Mese Onomastico'),
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

                showDay = true;
              });
            },
          ),
          Container(
            margin: EdgeInsets.only(top: 30, bottom: 20),
            color: Colors.transparent,
            child: Text('Giorno Onomastico'),
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
            margin: EdgeInsets.only(top: 65, left: 40, right: 40),
            child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(30.0),
              color: Color.fromRGBO(174, 0, 17, 1),
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
                        });
                    if (response.statusCode == 200) {
                      Authorization.saveToken(response.body);
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/events', (Route<dynamic> route) => false);
                    }
                  }
                },
                child: Text(
                  "AGGIUNGI ONOMASTICO",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
