import 'dart:ffi';

import 'package:fides_calendar/models/dish.dart';
import 'package:fides_calendar/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class Menu {
  String shopName;
  List<Dish> dishes;

  Menu(
    this.shopName,
    this.dishes,
  );

  Menu.fromJson(Map json)
      : shopName = json['shopName'],
        dishes = json['dishes'] == null
            ? null
            : List<Dish>.from(json['dishes'].map((dish) => Dish.fromJson(dish)).toList());

  Map toJson() {
    return {
      'shopName': shopName,
      'dishes': dishes,
    };
  }
}
