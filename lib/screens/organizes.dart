import 'package:flutter/material.dart';

class Organizes extends StatefulWidget {
  @override
  _OrganizesState createState() => _OrganizesState();
}

class _OrganizesState extends State<Organizes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ORGANIZZA'),
        backgroundColor: Color.fromRGBO(174, 0, 17, 70),
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 50, left: 20, right: 20),
                color: Color.fromRGBO(229, 231, 234, 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
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
