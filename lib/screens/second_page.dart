import 'package:fides_calendar/lista_eventi.dart';
import 'package:fides_calendar/main.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:camera/camera.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: ListaEventi(), type: PageTransitionType.fade));
        },
        backgroundColor: Colors.transparent,
        child: Text('SALTA'),
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
                                child: CameraScreen(cameras),
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
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Color.fromRGBO(174, 0, 17, 1),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://static.iphoneitalia.com/wp-content/uploads/2014/03/iPhone-3G3GS-22.jpg")))),
    );
  }
}
