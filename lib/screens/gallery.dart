import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Gallery extends StatefulWidget {
  final List<String> imageUrls;

  const Gallery({Key key, this.imageUrls}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  bool _isLoading = false;
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
      return Scaffold(
      appBar: AppBar(title: Text('GALLERIA'),),
      body:Container(
        color: Colors.white,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 100,bottom: 100),
          scrollDirection: Axis.horizontal,
          itemCount: this.widget.imageUrls.length,
          itemBuilder: (context, i) {
            return Image.network(this.widget.imageUrls[i]);
          },
        ),
      ));
    }
  }
}
