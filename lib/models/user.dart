import 'package:fides_calendar/models/celebration.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class User {
  String email;
  String password;
  String firstName;
  String lastName;
  String _id;
  List<Celebration> celebrations;

  User(this.email, this.password, this.firstName, this.lastName, this._id,
      this.celebrations);

  User.fromJson(Map json)
      : email = json['email'],
        password = json['password'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        _id = json['_id'],
        celebrations = json['celebrations'] == null ? null : json['celebrations']
            .map((celebrations) => Celebration.fromJson(celebrations))
            .toList();

  Map toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'celebrations': celebrations
    };
  }
}
