// import 'package:camera/camera.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/reviews.dart';
import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/gallery.dart';
// import 'package:fides_calendar/screens/camera_screen.dart';
import 'package:fides_calendar/screens/organizes.dart';
import 'package:fides_calendar/util/date_format.dart';
import 'package:fides_calendar/util/loader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class InfoPage extends StatefulWidget {
  final celebrationId;
  final List<String> imageUrls;

  // final List<CameraDescription> cameras;
  const InfoPage(
      {Key key,
      @required this.celebrationId,
      List<CameraDescription> cameras,
      List<CameraDescription> camera,
      this.imageUrls})
      : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Celebration _celebration;
  bool _isLoading = false;
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);

  Future<void> _getCelebration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
          "https://immense-anchorage-57010.herokuapp.com/api/celebration/${this.widget.celebrationId}",
          headers: {
            'Accept': 'application/json',
            HttpHeaders.authorizationHeader: Authorization.token
          });
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
    String _description;
    var screenHeigth = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    if (_isLoading) {
      return Loader.getLoader(context);
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
          body: Center(
            child: Container(
              padding: EdgeInsets.only(top: screenHeigth / 100 * 5),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${_celebration.celebrated.firstName.toUpperCase()} ${_celebration.celebrated.lastName.toUpperCase()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          color: pinkColor,
                        ),
                      ),
                      Text(
                        "${DateTime.parse(_celebration.date).day} ${DateFormat.numberToString(DateTime.parse(_celebration.date).month)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                      Text(
                        '${_celebration.celebrationType.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  _celebration.celebrated.id != Authorization.getLoggedUser().id
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeigth / 100 * 3),
                                height: screenHeigth / 100 * 35,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _celebration
                                      .activeEvent.eventImagesUrls.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(_celebration
                                                .activeEvent
                                                .eventImagesUrls[i]),
                                          )),
                                      width: screenWidth / 100 * 70,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth / 100 * 5),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeigth / 100 * 3),
                          height: screenHeigth / 100 * 35,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, i) {
                              if (i >=
                                  _celebration
                                      .activeEvent.eventImagesUrls.length) {
                                return Container(
                                  child: IconButton(
                                      icon: Icon(Icons.add_a_photo),
                                      color: pinkColor,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: CameraScreen(
                                              requestMethod: 'PUT',
                                              requestUrl:
                                                  '${Environment.siteUrl}/event/${_celebration.activeEvent.id}/image',
                                              requestField: 'eventPic',
                                              updateToken: false,
                                            )));
                                      }),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  width: screenWidth / 100 * 70,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth / 100 * 5),
                                );
                              } else {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(_celebration
                                            .activeEvent.eventImagesUrls[i]),
                                      )),
                                  width: screenWidth / 100 * 70,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth / 100 * 5),
                                );
                              }
                            },
                          ),
                        ),
                  _celebration.activeEvent.description == ""
                      ? Container(
                          margin:
                              EdgeInsets.only(bottom: screenHeigth / 100 * 3),
                          alignment: Alignment.center,
                          child: Text('NESSUNA DESCRIZIONE INSERITA'),
                        )
                      : Container(
                          margin:
                              EdgeInsets.only(bottom: screenHeigth / 100 * 3),
                          alignment: Alignment.center,
                          child: Text(_celebration.activeEvent.description),
                        ),
                  _celebration.celebrated.id != Authorization.getLoggedUser().id
                      ? Container()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeigth / 100 * 3,
                              horizontal: screenWidth / 100 * 15),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: _celebration.activeEvent.description == ""
                                ? Text(
                                    'INSERISCI UNA DESCRIZIONE',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : Text(
                                    'MODIFICA LA TUA DESCRIZIONE',
                                    style: TextStyle(color: Colors.white),
                                  ),
                            color: pinkColor,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Organizes(
                                        id: _celebration.activeEvent.id,
                                        creating: false,
                                        updateDescriptionCallback:
                                            _getCelebration,
                                      ),
                                      type: PageTransitionType.fade));
                            },
                          ),
                        ),
                  _celebration.celebrated.id != Authorization.getLoggedUser().id
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeigth / 100 * 3),
                                height: screenHeigth / 100 * 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      _celebration.activeEvent.reviews.length,
                                  itemBuilder: (context, i) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              offset: Offset(0, 4),
                                              color: Colors.grey,
                                              blurRadius: 1)
                                        ],
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                      ),
                                      width: screenWidth / 100 * 70,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: screenWidth / 100 * 5),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(
                                                  top: screenHeigth / 100 * 3),
                                              child: Text(
                                                _celebration.activeEvent
                                                    .reviews[i].reviewer
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: pinkColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 20),
                                              )),
                                          Text(_celebration
                                              .activeEvent.reviews[i].comment
                                              .toUpperCase()),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                 margin: EdgeInsets.only(left: screenWidth/100*50,top: screenHeigth/100*1.5),
                                                  width: screenWidth / 100 * 70,
                                                  height:
                                                      screenHeigth / 100 * 5,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: _celebration
                                                          .activeEvent
                                                          .reviews[i]
                                                          .rating,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return Icon(
                                                          Icons.stars,
                                                          color: pinkColor,
                                                        );
                                                      }),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                    // return Container(
                                    //   child: FlatButton(
                                    //     child: Text(
                                    //       'Inserisci una recensione',
                                    //       style: TextStyle(color: pinkColor),
                                    //     ),
                                    //     onPressed: () {
                                    //       Navigator.push(
                                    //           context,
                                    //           PageTransition(
                                    //               child: Reviews(
                                    //             id: _celebration.activeEvent.id,
                                    //             updateDescriptionCallback: _getCelebration,
                                    //           )));
                                    //     },
                                    //   ),
                                    //   decoration: BoxDecoration(
                                    //     color: Colors.white,
                                    //     borderRadius: BorderRadius.only(
                                    //         bottomLeft: Radius.circular(20),
                                    //         bottomRight: Radius.circular(20),
                                    //         topRight: Radius.circular(20)),
                                    //   ),
                                    //   width: screenWidth / 100 * 70,
                                    //   margin: EdgeInsets.symmetric(
                                    //       horizontal: screenWidth / 100 * 5),
                                    // );
                                  },
                                ),
                              ),
                            )
                          ],
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
