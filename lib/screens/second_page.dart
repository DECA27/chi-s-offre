import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/main.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);
}

class _SecondPageState extends State<SecondPage> {
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/events', (Route<dynamic> route) => false);
        },
        backgroundColor: Colors.transparent,
        child: Text('SALTA',style: TextStyle(color: pinkColor,fontWeight: FontWeight.w900),),
        elevation: 0,
      ),
      body: Container(
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                    flex: 1,
                    child: GestureDetector(
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
                        margin: EdgeInsets.only(top: 250, bottom: 80),
                        child: Icon(
                          Icons.camera_alt,
                          size: 140,
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ))
              ]),
              Text(
                'Aggiungi qui la tua foto',
                style: TextStyle(color: pinkColor, fontSize: 20,fontWeight: FontWeight.w700),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: backgroundColor,
      ),
    );
  }
}
