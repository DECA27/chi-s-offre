import 'package:camera/camera.dart';
import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/organizes.dart';
import 'package:fides_calendar/util/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

class InfoPage extends StatefulWidget {
 
  
  final celebrationId;
  final List<CameraDescription> cameras;
  const InfoPage({Key key, @required this.celebrationId, @required this.cameras}) : super(key: key);

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
          "https://immense-anchorage-57010.herokuapp.com/api/celebration/${this.widget.celebrationId}",
          headers: {'Accept': 'application/json'});
      if (response.statusCode == 200) {
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
      floatingActionButton: SpeedDial(
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.transparent,
        overlayOpacity: 0.5,
        onOpen: () => print('OPEN'),
        onClose: () => print('CLOSE'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
              label: 'Aggiungi qui le tue foto',
              labelStyle: TextStyle(fontSize: 15.0),
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: CameraScreen(widget.cameras), type: PageTransitionType.fade));
              }),
          SpeedDialChild(
              child: Icon(Icons.create, color: Colors.black),
              backgroundColor: Colors.white,
              label: 'Aggiungi qui la tua descrizione',
              labelStyle: TextStyle(fontSize: 15.0, color: Colors.black),
              labelBackgroundColor: Colors.white,
              onTap: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: Organizes(), type: PageTransitionType.fade));
              }),
        ],
      ),
      body: SingleChildScrollView(

        
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Color.fromRGBO(174, 0, 17, 1),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://static.iphoneitalia.com/wp-content/uploads/2014/03/iPhone-3G3GS-22.jpg"))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          color: Colors.white),
                      margin: EdgeInsets.only(top: 90, left: 20, right: 20),
                      width: 320,
                      height: 120,
                      child: Text(
                        _celebration == null
                            ? "Loading..."
                            : "${_celebration.celebrated.firstName} ${_celebration.celebrated.lastName}\n" +
                                "${DateTime.parse(_celebration.date).day} " +
                                "${DateFormat.numberToString(DateTime.parse(_celebration.date).month)}\n" +
                                "${_celebration.celebrationType}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ))
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                width: 320,
                height: 320,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
