import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/screens/organizes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Celebration _celebration;
  bool _isLoading = false;

  Future<void> _getCelebration() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
          "https://immense-anchorage-57010.herokuapp.com/api/celebration/5da6cc9ee1a7600004cab79f",
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        _celebration = Celebration.fromJson(jsonDecode(response.body));

        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _getCelebration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(174, 0, 17, 70),
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: Organizes(), type: PageTransitionType.rightToLeft));
        },
      ),
      appBar: AppBar(
        title: Text('INFO EVENTO'),
        backgroundColor: Color.fromRGBO(174, 0, 17, 70),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                   margin: EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  width: 370,
                                  height: 400,
                                  color: Color.fromRGBO(229, 231, 234, 30),
                                  child: Text(
                                    _celebration == null ? "Loading..." : _celebration.celebrated.firstName,
                                    style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 35,
                                          color: Color.fromRGBO(174, 0, 17, 70)),
                                  ),
                )
                    
              ],
            ),
          ],
        ),
      ),
    );
  }
}
