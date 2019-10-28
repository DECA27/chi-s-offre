import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fides_calendar/login.dart';
import 'package:fides_calendar/models/user.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class InfoUser extends StatefulWidget {
  final userId;

  const InfoUser({Key key, @required this.userId}) : super(key: key);
  @override
  _InfoUserState createState() => _InfoUserState();
}

class _InfoUserState extends State<InfoUser> {
  bool _isLoading = false;
  User _user;

  Future<void> _getCelebration() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
          "https://immense-anchorage-57010.herokuapp.com/api/user/${this.widget.userId}",
          headers: {'Accept': 'application/json'});
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
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(174, 0, 17, 1),
          title: Center(child: Text('PROFILO', textAlign: TextAlign.start)),
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Container(
                    child: Icon(
                      Icons.person,
                      size: 40,
                    ),
                    margin: EdgeInsets.only(top: 80, bottom: 30),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 250,
                    height: 50,
                    color: Colors.black,
                    
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 250,
                    height: 50,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 250,
                    height: 50,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 250,
                    height: 50,
                    color: Colors.black,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 60, right: 50, left: 50),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color.fromRGBO(174, 0, 17, 1),
                      child: MaterialButton(
                        minWidth: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: Login(),
                                  type: PageTransitionType.rightToLeft));
                        },
                        child: Text(
                          "LOGOUT",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://static.iphoneitalia.com/wp-content/uploads/2014/03/iPhone-3G3GS-22.jpg"))),
            ),
          ],
        ));
  }
}
