import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/models/event.dart';
import 'package:fides_calendar/screens/info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

class ListaEventi extends StatefulWidget {
  @override
  _ListaEventiState createState() => _ListaEventiState();
}

class _ListaEventiState extends State<ListaEventi> {
  List<Celebration> _celebrations = [];
  bool _isLoading = false;

  Future<void> _getEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
          "https://immense-anchorage-57010.herokuapp.com/api/celebrations",
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body);

        _celebrations =
            list.map((model) => Celebration.fromJson(model)).toList();
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
    _getEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EVENTI'),
        backgroundColor: Color.fromRGBO(174, 0, 17, 70),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Container(
                color: Color.fromRGBO(174, 0, 17, 70),
                padding: EdgeInsets.all(5),
                child: Image.asset(
                  "assets/images/Untitled-1.png",
                ),
              ),
            ),
            ListTile(
              title: Text('USER'),
            ),
            ListTile(
              title: Text('LOGOUT'),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: 
            <Widget>[
          Container(
              color: Colors.white70,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Container(
                width: 100,
                height: 100,
                child: ListView.builder(
                    itemCount: _celebrations.length,
                    itemBuilder: (context, i) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        child: InfoPage(),
                                        type: PageTransitionType.rightToLeft));
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 20, right: 20),
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Text(
                                      _celebrations[i].celebrated.firstName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25,
                                          color: Colors.white),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(229, 231, 234, 30),
                                  )),
                            ),
                          )
                        ],
                      );
                    }),
              )),
        ]),
      ),
    );
  }
}

class _showSnackBar {
  _showSnackBar(String s);
}
