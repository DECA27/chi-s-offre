import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraScreen(this.cameras, {List<CameraDescription> camera});

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

  @override
  void initState() {
    _setupCamera();
    super.initState();
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();

      _controller = new CameraController(_cameras[0], ResolutionPreset.medium);

      _initializeControllerFuture = _controller.initialize();
      await _initializeControllerFuture;

      print(_controller.value.aspectRatio);
      setState(() {
        _isCameraReady = true;
      });
    } on CameraException catch (_) {
      setState(() {
        _isCameraReady = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady) {
      return new Container(color: Colors.green);
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.camera_alt,
          color: Colors.black,
        ),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            await _controller.takePicture(path);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
      ),
      body: Transform.scale(
        scale: _controller.value.aspectRatio /
            (MediaQuery.of(context).size.width /
                MediaQuery.of(context).size.height),
        child: Center(
          child: new AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          ),
        ),
      ),
    );
  }
}
