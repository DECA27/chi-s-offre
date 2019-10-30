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
                  color: Colors.white,
                ),
                margin:
                    EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 50),
                width: 320,
                height: 400,
                child: TextField(
                  cursorColor: Colors.black,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 20,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Scrivi qui",
                  ),
                ),
              ),
              RaisedButton(
                  color: Color.fromRGBO(174, 0, 17, 1),
                  onPressed: () {},
                  child: Text('INVIA DESCRIZIONE'))
            ]),
      ),
    );
  }
}
