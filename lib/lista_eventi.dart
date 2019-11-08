import 'dart:io';

//import 'package:camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/chat.dart';
import 'package:fides_calendar/login.dart';
import 'package:fides_calendar/main.dart' as prefix0;
import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/models/event.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/info_page.dart';
import 'package:fides_calendar/screens/info_user.dart';
import 'package:fides_calendar/util/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';
// import 'package:camera/camera.dart';
import 'package:flutter/scheduler.dart';

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
          "https://immense-anchorage-57010.herokuapp.com/api/celebrations/coming/20",
          headers: {
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: Authorization.token
          });
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body);
        for (var i = 0; i < list.length; i++) {
          print(list.elementAt(i));
          print(Celebration.fromJson(list.elementAt(i)).id);
        }

        _celebrations =
            list.map((model) => Celebration.fromJson(model)).toList();
        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 401) {
        Navigator.push(context,
            PageTransition(child: Login(), type: PageTransitionType.fade));
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
    if (Authorization.getLoggedUser().celebrations.length < 2) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/nameDayError');
      });
    }
    ;
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
                valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(174, 0, 30, 1)),
                strokeWidth: 5),
          ),
        ),
      );
    } else {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message),
          backgroundColor: Color.fromRGBO(174, 0, 30, 1),
          onPressed: () {
            Navigator.push(context,
                PageTransition(child: Chat(), type: PageTransitionType.fade));
          },
        ),
        appBar: AppBar(
            actions: <Widget>[
              GestureDetector(
                child: Container(
                    margin: EdgeInsets.all(5),
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                          Authorization.getLoggedUser().profilePicUrl,
                        )))),
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: InfoUser(
                            userId: Authorization.getLoggedUser().id,
                          ),
                          type: PageTransitionType.fade));
                },
              ),
            ],
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'CALENDAR',
              style: TextStyle(color: Colors.white),
            ),
            elevation: 0,
            backgroundColor: Color.fromRGBO(174, 0, 30, 1)),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Timeline.builder(
              itemBuilder: (context, i) {
                return TimelineModel(
                    Container(
                        color: Colors.transparent,
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: InfoPage(
                                              celebrationId:
                                                  _celebrations[i].id,
                                              camera: <CameraDescription>[],
                                            ),
                                            type: PageTransitionType.fade));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 20, left: 20, right: 0),
                                      width: MediaQuery.of(context).size.width,
                                      height: 100,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "${_celebrations[i].celebrationType[0].toUpperCase()}${_celebrations[i].celebrationType.substring(1)} di:\n" +
                                              "${_celebrations[i].celebrated.firstName} ${_celebrations[i].celebrated.lastName}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              color: Colors.white),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(20.0),
                                            topRight: Radius.circular(20.0),
                                            topLeft: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                          color:
                                              Color.fromRGBO(174, 0, 30, 1))),
                                ),
                              )
                            ],
                          ),
                        )),
                    iconBackground: Colors.transparent,
                    dateString:
                        "${DateTime.parse(_celebrations[i].date).day.toString()}\n${DateFormat.numberToString(DateTime.parse(_celebrations[i].date).month)}");
              },
              position: TimelinePosition.Left,
              itemCount: _celebrations.length,
              physics: BouncingScrollPhysics(),
              lineColor: Color.fromRGBO(174, 0, 30, 1)),
        ),
      );
    }
  }
}

class _showSnackBar {
  _showSnackBar(String s);
}
