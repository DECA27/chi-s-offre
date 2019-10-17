import 'dart:ffi';

import 'package:fides_calendar/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class Dish {
  int quatity;
  String name;


  Dish(this.quatity, this.name, );

  Dish.fromJson(Map json)
      : quatity = json['quatity'],
        name = json['name'];
       
  Map toJson() {
    return {
      'quatity': quatity,
      'name': name,
      
    };
  }
}