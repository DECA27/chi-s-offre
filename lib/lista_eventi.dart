import 'dart:io';

//import 'package:camera/camera.dart';
import 'package:camera/camera.dart';
import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/chat.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/login.dart';
import 'package:fides_calendar/main.dart' as prefix0;
import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/models/event.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/info_page.dart';
import 'package:fides_calendar/screens/info_user.dart';
import 'package:fides_calendar/util/date_format.dart';
import 'package:fides_calendar/util/loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<Event> _events = [];
  bool _isLoading = false;

  Future<void> _getEvents(String url) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: Authorization.token
      });
      if (response.statusCode == 200) {
        Iterable list = jsonDecode(response.body);
        for (var i = 0; i < list.length; i++) {
          print(list.elementAt(i));
          print(Event.fromJson(list.elementAt(i)).id);
        }

        _events = list.map((model) => Event.fromJson(model)).toList();
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
    _getEvents("${Environment.siteUrl}/events/coming/20");
    super.initState();
    if (Authorization.getLoggedUser().celebrations.length < 2) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/nameDayError', (Route<dynamic> route) => false);
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    var screenHeigth = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
    Color pinkColor = Color.fromRGBO(237, 18, 81, 1);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    if (_isLoading) {
      return Loader.getLoader(context);
    } else {
      return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            elevation: 0,
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Image.asset('assets/images/Asset 15.png'),
                    decoration: BoxDecoration(color: backgroundColor),
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.home,
                        color: pinkColor,
                      ),
                      title: Text(
                        'HOME',
                        style: TextStyle(
                            color: pinkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context, PageTransition(child: ListaEventi()));
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.list,
                      color: pinkColor,
                    ),
                    title: Text(
                      'EVENTI PASSATI',
                      style: TextStyle(
                          color: pinkColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    onTap: () {
                      Future.delayed(
                          Duration.zero,
                          () => {
                                setState(() {
                                  _getEvents(
                                      "${Environment.siteUrl}/events/passed");
                                }),
                                Navigator.pop(context)
                              });
                    },
                  ),
                  ListTile(
                      leading: Icon(
                        Icons.chat,
                        color: pinkColor,
                      ),
                      title: Text(
                        'CHAT',
                        style: TextStyle(
                            color: pinkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, PageTransition(child: Chat()));
                      }),
                  ListTile(
                      leading: Icon(
                        Icons.exit_to_app,
                        color: pinkColor,
                      ),
                      title: Text(
                        'LOGOUT',
                        style: TextStyle(
                            color: pinkColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      onTap: () {
                        SharedPreferences.getInstance()
                            .then((prefs) => {prefs.clear()});
                        Authorization.logout();
                        Navigator.pop(context);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/login', (Route<dynamic> route) => false);
                      }),
                ],
              ),
            ),
          ),
          appBar: AppBar(
              leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: pinkColor,
                    size: 28,
                  ),
                  onPressed: () => _scaffoldKey.currentState.openDrawer()),
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
                'CHI (S)OFFRE?',
                style: TextStyle(
                    color: pinkColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 22),
              ),
              elevation: 0,
              backgroundColor: backgroundColor),
          body: Container(
              decoration: BoxDecoration(color: backgroundColor),
              child: ListView.builder(
                  itemCount: _events.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.grey,
                                blurRadius: 5)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeigth / 100 * 2,
                          horizontal: screenWidth / 100 * 10),
                      width: MediaQuery.of(context).size.width,
                      height: screenHeigth / 100 * 14,
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
                                            eventId: _events[i].id,
                                            camera: <CameraDescription>[],
                                          ),
                                          type: PageTransitionType.fade));
                                },
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        color: Colors.transparent,
                                        padding: EdgeInsets.only(
                                            right: screenWidth / 100 * 2,
                                            left: screenWidth / 100 * 2,
                                            top: screenHeigth / 100 * 3,
                                            bottom: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '${DateTime.parse(_events[i].celebrationDate).day} ${DateFormat.numberToString(DateTime.parse(_events[i].celebrationDate).month)} ${DateTime.parse(_events[i].celebrationDate).year}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Text(
                                                '${_events[i].celebration.celebrated.firstName.toUpperCase()} ${_events[i].celebration.celebrated.lastName.toUpperCase()}',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w900,
                                                    color: pinkColor)),
                                            Text(
                                              '${_events[i].celebration.celebrationType.toUpperCase()}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: screenHeigth,
                                      color: Colors.transparent,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth / 100 * 5,
                                      ),
                                      child: Icon(Icons.navigate_next,
                                          color: pinkColor),
                                    )
                                  ],
                                )),
                          )
                        ],
                      ),
                    );
                  })));
    }
  }
}

class _showSnackBar {
  _showSnackBar(String s);
}
