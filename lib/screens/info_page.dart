// import 'package:camera/camera.dart';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/models/event.dart';
import 'package:fides_calendar/models/review.dart';
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
  final eventId;
  final List<String> imageUrls;

  // final List<CameraDescription> cameras;
  const InfoPage(
      {Key key,
      @required this.eventId,
      List<CameraDescription> cameras,
      List<CameraDescription> camera,
      this.imageUrls})
      : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  Event _event;
  bool _isLoading = false;
  Color backgroundColor = Color.fromRGBO(235, 237, 241, 1);
  Color pinkColor = Color.fromRGBO(237, 18, 81, 1);
  var screenHeigth;
  var screenWidth;

  Future<void> _getCelebration() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http
          .get("${Environment.siteUrl}/event/${this.widget.eventId}", headers: {
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: Authorization.token
      });
      if (response.statusCode == 200) {
        _event = Event.fromJson(jsonDecode(response.body));

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
    screenHeigth = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
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
                        "${_event.celebration.celebrated.firstName.toUpperCase()} ${_event.celebration.celebrated.lastName.toUpperCase()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 25,
                          color: pinkColor,
                        ),
                      ),
                      Text(
                        "${DateTime.parse(_event.celebrationDate).day} ${DateFormat.numberToString(DateTime.parse(_event.celebrationDate).month)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w900,
                            fontSize: 18),
                      ),
                      Text(
                        '${_event.celebration.celebrationType.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  _event.celebration.celebrated.id !=
                          Authorization.getLoggedUser().id
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
                                  itemCount: _event.eventImagesUrls.length > 0
                                      ? _event.eventImagesUrls.length
                                      : 1,
                                  itemBuilder: (context, i) {
                                    if (_event.eventImagesUrls.length > 0) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(20),
                                                bottomRight:
                                                    Radius.circular(20),
                                                topRight: Radius.circular(20)),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                  _event.eventImagesUrls[i]),
                                            )),
                                        width: screenWidth / 100 * 70,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: screenWidth / 100 * 5),
                                      );
                                    } else {
                                      return Container(
                                        width: screenWidth,
                                        height: screenHeigth / 100 * 10,
                                        alignment: Alignment.center,
                                        child: Text(
                                          'NESSUNA IMMAGINE INSERITA',
                                          style: TextStyle(
                                              color: pinkColor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }
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
                              if (i >= _event.eventImagesUrls.length) {
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
                                                  '${Environment.siteUrl}/event/${_event.id}/image',
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
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            _event.eventImagesUrls[i]),
                                      )),
                                  width: screenWidth / 100 * 70,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth / 100 * 5),
                                );
                              }
                            },
                          ),
                        ),
                  _event.description == ""
                      ? Container(
                          margin:
                              EdgeInsets.only(bottom: screenHeigth / 100 * 8),
                          alignment: Alignment.center,
                          child: Text(
                            'NESSUNA DESCRIZIONE INSERITA',
                            style: TextStyle(
                                color: pinkColor, fontWeight: FontWeight.w500),
                          ),
                        )
                      : Container(
                          width: screenWidth / 100 * 70,
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth / 100 * 5),
                          height: screenHeigth / 100 * 12,
                          alignment: Alignment.center,
                          child: Text(_event.description),
                        ),
                  _event.celebration.celebrated.id !=
                          Authorization.getLoggedUser().id
                      ? Container()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              vertical: screenHeigth / 100 * 3,
                              horizontal: screenWidth / 100 * 15),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: _event.description == ""
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
                                        id: _event.id,
                                        creating: false,
                                        updateDescriptionCallback:
                                            _getCelebration,
                                      ),
                                      type: PageTransitionType.fade));
                            },
                          ),
                        ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeigth / 100 * 3),
                          height: screenHeigth / 100 * 25,
                          child: getReview(
                              _event.reviews,
                              _event.status == "closed" &&
                                  _event.celebration.celebrated.id !=
                                      Authorization.getLoggedUser().id &&
                                  !alreadyReviewed()),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget getReview(List<Review> reviews, bool reviewForm) {
    int count = reviewForm ? reviews.length + 1 : reviews.length;

    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (context, i) {
          int index = reviewForm ? i - 1 : i;
          if (index == -1) {
            return Container(
              height: screenHeigth / 100 * 6,
              child: FlatButton(
                child: Text(
                  'Inserisci una recensione',
                  style: TextStyle(color: pinkColor),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: Reviews(
                        id: _event.id,
                        updateDescriptionCallback: _getCelebration,
                      )));
                },
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              width: screenWidth / 100 * 70,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 100 * 5),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              width: screenWidth / 100 * 70,
              margin: EdgeInsets.symmetric(horizontal: screenWidth / 100 * 5),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(
                            top: screenHeigth / 100 * 3,
                            left: screenWidth / 100 * 2),
                        child: Text(
                          "${reviews[index].reviewer.firstName.toUpperCase()} ${reviews[index].reviewer.lastName.toUpperCase()}",
                          style: TextStyle(
                              color: pinkColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 19),
                        )),
                    Container(
                        margin: EdgeInsets.only(top: screenHeigth / 100 * 3),
                        child: Text(reviews[index].comment)),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: screenWidth / 100 * 35,
                                top: screenHeigth / 100 * 2),
                            width: screenWidth / 100 * 70,
                            height: screenHeigth / 100 * 5,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: reviews[index].rating,
                                itemBuilder: (context, i) {
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
              ),
            );
          }
        });
  }

  bool alreadyReviewed() {
    bool reviewed = false;
    _event.reviews.forEach((review) => {
          if (review.reviewer.id == Authorization.getLoggedUser().id)
            {reviewed = true}
        });
    return reviewed;
  }
}
