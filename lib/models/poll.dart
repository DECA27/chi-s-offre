import 'dart:ffi';

import 'package:fides_calendar/models/dish.dart';
import 'package:fides_calendar/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class Poll {
  int sweet;
  int salty;

  Poll(
    this.sweet,
    this.salty,
  );

  Poll.fromJson(Map json)
      : sweet = json['sweet'],
        salty = json['salty'];

  Map toJson() {
    return {
      'sweet': sweet,
      'salty': salty,
    };
  }
}