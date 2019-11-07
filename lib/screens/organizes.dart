import 'package:fides_calendar/lista_eventi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:flutter/cupertino.dart';

class Organizes extends StatefulWidget {
  final id;
  final bool creating;
  final Function updateDescriptionCallback;

  const Organizes(
      {Key key,
      @required this.id,
      @required this.creating,
      @required this.updateDescriptionCallback})
      : super(key: key);
  @override
  _OrganizesState createState() => _OrganizesState();
}

class _OrganizesState extends State<Organizes> {
  final _formKey = GlobalKey<FormState>();

  String _description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(
                      top: 100, left: 20, right: 20, bottom: 50),
                  width: 320,
                  height: 400,
                  child: TextFormField(
                      initialValue: "",
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    maxLines: 20,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "Scrivi qui",
                    ),
                    onSaved: (val) => setState(() {
                      _description = val;
                    }),
                  ),
                ),
              ),
              RaisedButton(
                  color: Color.fromRGBO(174, 0, 17, 1),
                  onPressed: () async {
                    _formKey.currentState.save();
                    http.Response response;
                    if (this.widget.creating) {
                      response = await http.post(
                          "https://immense-anchorage-57010.herokuapp.com/api/celebration/${this.widget.id}",
                          body: {'description': _description});
                    } else {
                      response = await http.put(
                          "https://immense-anchorage-57010.herokuapp.com/api/event/${this.widget.id}/description",
                          body: {'description': _description});
                    }

                    if (response.statusCode == 200) {
                      this.widget.updateDescriptionCallback();
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('INVIA DESCRIZIONE'))
            ]),
      ),
    );
  }
}
