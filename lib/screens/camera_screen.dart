import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/lista_eventi.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:fides_calendar/registrazione.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' show join;
import 'package:path/path.dart' as prefix0;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';

class CameraScreen extends StatefulWidget {
  // final List<CameraDescription> cameras;
  final String requestUrl;
  final String requestMethod;
  final String requestField;
  final bool updateToken;

  const CameraScreen(
      {Key key,
      @required this.requestUrl,
      @required this.requestMethod,
      @required this.requestField,
      @required this.updateToken})
      : super(key: key);
  @override
  CameraScreenState createState() {
    return new CameraScreenState();
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      body: Image.file(
        File(imagePath),
      ),
    );
  }
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  List<CameraDescription> _cameras;
  bool _isCameraReady = false;
  Future<void> _initializeControllerFuture;
  File _image;
  bool _isLoading = false;

  @override
  void initState() {
    _setupCamera();
    super.initState();
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();

      _controller = new CameraController(_cameras[0], ResolutionPreset.medium);

      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
      });
      setState(() {
        _isCameraReady = true;
      });
    } on CameraException catch (_) {
      setState(() {
        _isCameraReady = false;
      });
    }
  }

  Future getImageFromCam() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
      AppBar appBar = AppBar(
        title: Text('SCEGLI IMMAGINE'),
        backgroundColor: Color.fromRGBO(174, 0, 17, 1),
      );
      var screenHeigth =
          MediaQuery.of(context).size.height - appBar.preferredSize.height;
      var screenWidth = MediaQuery.of(context).size.width;
      return _isCameraReady == false
          ? Container(
              color: Colors.blueGrey,
            )
          : Scaffold(
              appBar: appBar,
              body: Container(
                height: screenHeigth / 100 * 90,
                child: Column(children: <Widget>[
                  Container(
                      margin: EdgeInsets.symmetric(
                          vertical: screenHeigth / 100 * 10),
                      height: screenHeigth / 100 * 50,
                      child: Center(
                          child: _image == null
                              ? Text(
                                  'SELEZIONA LA TUA IMMAGINE DI PROFILO USANDO LA CAMERA O LA TUA GALLERIA',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: screenHeigth / 100 * 3.5,
                                  ),
                                )
                              : Image.file(_image))),
                  _image == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth / 100 * 10),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Color.fromRGBO(174, 0, 17, 1),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  var request = new http.MultipartRequest(
                                      "PUT", Uri.parse(this.widget.requestUrl));
                                  request.files.add(
                                      await http.MultipartFile.fromPath(
                                          this.widget.requestField,
                                          _image.path));
                                  request.headers.addAll({
                                    HttpHeaders.authorizationHeader:
                                        Authorization.token
                                  });
                                  request.send().then((responseStream) async {
                                    if (responseStream.statusCode == 200) {
                                      if (this.widget.updateToken) {
                                        var response = await responseStream
                                            .stream
                                            .bytesToString();
                                        Authorization.saveToken(response);
                                      }
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: ListaEventi(),
                                              type: PageTransitionType.fade));
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  });
                                } catch (e) {
                                  print('Token not valid');
                                }
                              },
                              child: Text(
                                'AGGIUNGI QUESTA FOTO',
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FloatingActionButton(
                            heroTag: "btn1",
                            backgroundColor: Color.fromRGBO(174, 0, 17, 1),
                            onPressed: getImageFromGallery,
                            tooltip: 'Pick Image',
                            child: Icon(Icons.wallpaper),
                          ),
                          FloatingActionButton(
                              heroTag: "btr2",
                              backgroundColor: Color.fromRGBO(174, 0, 17, 1),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              onPressed: getImageFromCam),
                        ],
                      ),
                    ),
                  ),
                ]),
              ));
    }
  }
}
