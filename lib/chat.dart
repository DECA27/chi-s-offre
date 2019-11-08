import 'dart:convert';
import 'dart:math';

import 'package:fides_calendar/authorization/authorization.dart';
import 'package:fides_calendar/environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  @override
  State createState() => ChatWindow();
}

class ChatWindow extends State<Chat> with TickerProviderStateMixin {
  List<Msg> _messages;
  final TextEditingController _textController = TextEditingController();
  bool _isWriting = false;
  IO.Socket socket;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    setState(() {
      getChat();
    });
    handleSocket();
  }

  @override
  Widget build(BuildContext ctx) {
    if (_isLoading) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 100 * 90,
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(174, 0, 30, 1),
          title: Text("Chat "),
          elevation: Theme.of(ctx).platform == TargetPlatform.iOS ? 0.0 : 6.0,
        ),
        body: Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
            reverse: true,
            padding: EdgeInsets.all(6.0),
          )),
          Divider(height: 1.0),
          Container(
            child: _buildComposer(),
            decoration: BoxDecoration(color: Theme.of(ctx).cardColor),
          ),
        ]),
      );
    }
  }

  Widget _buildComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String txt) {
                    setState(() {
                      _isWriting = txt.length > 0;
                    });
                  },
                  onSubmitted: _submitMsg,
                  decoration:
                      InputDecoration.collapsed(hintText: "Invia un messaggio"),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Theme.of(context).platform == TargetPlatform.iOS
                      ? CupertinoButton(
                          child: Text("Submit"),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null)
                      : IconButton(
                          icon: Icon(Icons.send),
                          onPressed: _isWriting
                              ? () => _submitMsg(_textController.text)
                              : null,
                        )),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black)))
              : null),
    );
  }

  Future<void> getChat() async {
    http.Response response = await http.get('${Environment.siteUrl}/chat');
    Iterable json = jsonDecode(response.body);
    _messages = json
        .map((message) => Msg(
              userId: message['userId'],
              txt: message['txt'],
              username: message['username'],
              animationController: AnimationController(
                  vsync: this, duration: Duration(milliseconds: 800)),
            ))
        .toList();
    _messages.forEach((message) => message.animationController.forward());
  }

  void _submitMsg(String txt) {
    _textController.clear();
    setState(() {
      _isWriting = false;
    });

    socket.emit('send-message', {'message': txt});
  }

  @override
  void deactivate() {
    socket.disconnect();
    super.deactivate();
  }

  @override
  void dispose() {
    for (Msg msg in _messages) {
      msg.animationController.dispose();
    }

    super.dispose();
  }

  Future<void> handleSocket() async {
    socket = await IO.io('${Environment.chatRoom}', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.emit('data', {'userId': Authorization.getLoggedUser().id});

    socket.on('logged', (values) {
      setState(() {
        _isLoading = false;
      });
      if (!values['logged']) {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('ATTENZIONE!!!!', textAlign: TextAlign.center),
                content: Text("Connessione alla chat fallita!"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "Sarà per un'altra volta!",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    });

    socket.on('get-message', (values) {
      Msg msg = Msg(
        userId: values['userId'].toString(),
        username: values['username'].toString(),
        txt: values['message'].toString(),
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 800)),
      );

      setState(() {
        _messages.insert(0, msg);
      });

      msg.animationController.forward();
    });

    socket.on('logout', (values) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('ATTENZIONE!!!!', textAlign: TextAlign.center),
              content: Text("Connessione alla chat scaduta!"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Riprova",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }
}

class Msg extends StatelessWidget {
  Msg({this.username, this.txt, this.animationController, this.userId});
  final String userId;
  final String username;
  final String txt;
  final AnimationController animationController;

  @override
  Widget build(BuildContext ctx) {
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(children: <Widget>[
          Expanded(
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: userId == Authorization.getLoggedUser().id
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: getMessageWidgets(ctx))),
        ]),
      ),
    );
  }

  List<Widget> getMessageWidgets(BuildContext ctx) {
    List<Widget> widgets = [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: CircleAvatar(child: Text(username[0]),backgroundColor: Color.fromRGBO(Random().nextInt(255),
                              Random().nextInt(255), Random().nextInt(255),1),),
      ),
      Column(
          crossAxisAlignment: userId == Authorization.getLoggedUser().id
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            Text(username,style: TextStyle(fontWeight: FontWeight.w800),),
            Container(
              alignment: Authorization.getLoggedUser().id == userId
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              width: MediaQuery.of(ctx).size.width / 100 * 50,
              margin: const EdgeInsets.only(top: 6.0),
              child: Text(
                txt,
                maxLines: 8,
              ),
            ),
          ])
    ];

    if (userId == Authorization.getLoggedUser().id) {
      widgets.sort((a, b) => 1);
    }

    return widgets;
  }
}
