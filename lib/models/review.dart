import 'dart:ffi';

import 'package:fides_calendar/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class Review {
  String comment;
  String reviewer;
  num rating;

  Review(this.comment, this.reviewer, this.rating);

  Review.fromJson(Map json)
      : comment = json['comment'],
        reviewer = json['reviewer'],
        rating = json['rating'];

  Map toJson() {
    return {'comment': comment, 'reviewer': reviewer, 'rating': rating};
  }
}
