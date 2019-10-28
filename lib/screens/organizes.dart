import 'package:flutter/material.dart';

class Organizes extends StatefulWidget {
  @override
  _OrganizesState createState() => _OrganizesState();
}

class _OrganizesState extends State<Organizes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                            "https://static.iphoneitalia.com/wp-content/uploads/2014/03/iPhone-3G3GS-22.jpg"))),
                margin: EdgeInsets.only(
                  top: 100,
                  left: 20,
                  right: 20,
                ),
                width: 320,
                height: 400,
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Scrivi qui",
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
