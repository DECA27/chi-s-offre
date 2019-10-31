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
    return _isCameraReady == false
        ? Container(
            color: Colors.blueGrey,
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('SCEGLI IMMAGINE'),
            ),
            body: ListView(children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(
                      child: _image == null
                          ? Text('SELEZIONA LA TUA IMMAGINE')
                          : Image.file(_image))),
              RaisedButton(
                  color: Color.fromRGBO(174, 0, 17, 1),
                  onPressed: () async {
                    try {
                      var request = new http.MultipartRequest(
                          "PUT", Uri.parse(this.widget.requestUrl));
                      request.files.add(await http.MultipartFile.fromPath(
                          this.widget.requestField, _image.path));
                      request.send().then((responseStream) async {
                        if (responseStream.statusCode == 200) {
                          if (this.widget.updateToken) {
                            var response =
                                await responseStream.stream.bytesToString();
                            Authorization.saveToken(response);
                          }
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: ListaEventi(),
                                  type: PageTransitionType.fade));
                        }
                      });
                    } catch (e) {
                      print('Token not valid');
                    }
                  },
                  child: Text('AGGIUNGI QUESTA FOTO')),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FloatingActionButton(
                    heroTag: "btn1",
                    onPressed: getImageFromGallery,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.wallpaper),
                  ),
                  FloatingActionButton(
                      heroTag: "btr2",
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      onPressed: getImageFromCam),
                ],
              )
            ]));
  }
}
