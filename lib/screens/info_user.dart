import 'dart:convert';
import 'dart:io';
import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/name_day_update.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/util/date_format.dart';

import 'package:http/http.dart' as http;
import 'package:fides_calendar/login.dart';
import 'package:fides_calendar/models/user.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';

class InfoUser extends StatefulWidget {
  final userId;

  const InfoUser({Key key, @required this.userId}) : super(key: key);
  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  bool _isLoading = false;
  User _user;
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);

  Future<void> _getCelebration() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
          "${Environment.siteUrl}user/${this.widget.userId}",
          headers: {
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: Authorization.token
          });

      if (response.statusCode == 200) {
        _user = User.fromJson(jsonDecode(response.body));

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
    AppBar appBar = AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      title: Text(
        'PROFILO',
        textAlign: TextAlign.start,
        style: TextStyle(color: pinkColor, fontWeight: FontWeight.w900),
      ),
      elevation: 0,
    );
    var screenHeigth =
        MediaQuery.of(context).size.height - appBar.preferredSize.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
        appBar: appBar,
        body: _user == null
            ? null
            : ListView(
                children: <Widget>[
                  Container(
                    color: backgroundColor,
                    height: screenHeigth/100*95,
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: CameraScreen(
                                      requestMethod: 'PUT',
                                      requestUrl:
                                          '${Environment.siteUrl}/user/${Authorization.getLoggedUser().id}/image',
                                      requestField: 'updatePic',
                                      updateToken: true,
                                    ),
                                    type: PageTransitionType.fade));
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeigth / 100 * 10),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(_user.profilePicUrl)),
                                shape: BoxShape.circle),
                          ),
                        ),
                        Container(
                          height: screenHeigth / 100 * 7.5,
                          color: Colors.transparent,
                          child: Text(
                            "${_user.firstName} ${_user.lastName}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          height: screenHeigth / 100 * 7.5,
                          color: Colors.transparent,
                          child: Text("${_user.email}",
                              style: TextStyle(fontSize: 20)),
                        ),
                        Container(
                          height: screenHeigth / 100 * 7.5,
                          color: Colors.transparent,
                          child: Text(
                            '${_user.celebrations[0].celebrationType}: ${DateTime.parse(_user.celebrations[0].date).day} ${DateFormat.numberToString(DateTime.parse(_user.celebrations[0].date).month)}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          height: screenHeigth / 100 * 7.5,
                          color: Colors.transparent,
                          child: Text(
                            _user.celebrations.length > 1
                                ? '${_user.celebrations[1].celebrationType}: ${DateTime.parse(_user.celebrations[1].date).day} ${DateFormat.numberToString(DateTime.parse(_user.celebrations[1].date).month)}'
                                : 'Nessuno onomastico trovato',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        _user.hasNameDayUpdated
                            ? Container()
                            : Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth / 100 * 2,
                                    vertical: screenHeigth / 100 * 0.1),
                                child: RaisedButton(
                                    child: Text('Modifica il tuo onomastico'),
                                    elevation: 0,
                                    color: Colors.white10,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: NameDayUpdate(),
                                              type: PageTransitionType.fade));
                                    }),
                              ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: screenWidth / 100 * 20,
                                  left: screenWidth / 100 * 20,
                                  bottom: screenHeigth / 100 * 2),
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                color: pinkColor,
                                child: MaterialButton(
                                  minWidth: MediaQuery.of(context).size.width,
                                  onPressed: () {
                                    SharedPreferences.getInstance()
                                        .then((prefs) => {prefs.clear()});
                                    Authorization.logout();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil('/login',
                                            (Route<dynamic> route) => false);
                                  },
                                  child: Text(
                                    "LOGOUT",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ));
  }
}
