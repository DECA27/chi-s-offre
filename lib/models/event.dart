import 'dart:convert';
import 'dart:ffi';

import 'package:fides_calendar/models/celebration.dart';
import 'package:fides_calendar/models/menu.dart';
import 'package:fides_calendar/models/poll.dart';
import 'package:fides_calendar/models/review.dart';
import 'package:fides_calendar/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class Event {
  String description;
  num average;
  String id;
  String status;
  String celebrationDate;
  Celebration celebration;
  Menu menu;
  Poll poll;
  List<Review> reviews;
  List<String> eventImagesKeys;
  List<String> eventImagesUrls;

  Event(this.id, this.average, this.celebrationDate, this.status,
      this.celebration, this.menu, this.poll, this.reviews,this.description,this.eventImagesKeys,this.eventImagesUrls);

  Event.fromJson(Map json)
      : id = json['id'],
        average =  json['average'],
        celebrationDate = json['celebrationDate'],
        status = json['status'],
        celebration = json['celebration'] == null ? null : Celebration.fromJson(json['celebration']),
        menu = json['menu'] == null ? null : Menu.fromJson(json['menu']),
        poll = json['poll'] == null ? null : Poll.fromJson(json['poll']),
        reviews = json['reviews'] == null ? null : List<Review>.from(json['reviews'].map((review)=> Review.fromJson(review)).toList()),
        description= json ['description'],
        eventImagesKeys=(json['eventImagesKeys'] as Iterable).map((key) => key.toString()).toList(),
        eventImagesUrls=(json['eventImagesUrl'] as Iterable).map((key) => key.toString()).toList();
        
  Map toJson() {
    return {
      'id': id,
      'celebrationDate': celebrationDate,
      'status': status,
      'average': average,
      'celebration': celebration.toJson(),
      'menu': menu.toJson(),
      'poll': poll.toJson(),
      'reviews': reviews,
      'description' : description,
      'eventImagesKeys' : eventImagesKeys,
      'eventImagesUrls': eventImagesUrls
    };
  }
}
