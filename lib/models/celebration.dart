import 'dart:convert';

import 'package:fides_calendar/models/event.dart';
import 'package:fides_calendar/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class Celebration {
  String _id;
  String celebrationType;
  String date;
  User celebrated;
  List<Event> linkedEvents;
  Event activeEvent;

  Celebration(this._id, this.celebrationType, this.date, this.celebrated,
      this.linkedEvents, this.activeEvent);

  Celebration.fromJson(Map json)
      : _id = json['_id'],
        celebrated = json['celebrated'] == null ? null : User.fromJson(json['celebrated']),
        celebrationType = json['celebrationType'],
        date = json['date'];
//        activeEvent = json['activeEvent'] == null ? null : Event.fromJson(json['activeEvent']);
//        linkedEvents = json['linkedEvents'] == null ? null : json['linkedEvents'].map((event)=> Event.fromJson(event)).toList();
        
  Map toJson() {
    return {
      '_id': _id,
      'celebrationType': celebrationType,
      'date': date,
      'celebrated': celebrated.toJson(),
      'linkedEvents': linkedEvents,
      'activeEvents': activeEvent.toJson()
    };
  }
}