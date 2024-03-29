import 'package:fides_calendar/models/celebration.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class User {
  String email;
  String password;
  String firstName;
  String lastName;
  String id;
  List<Celebration> celebrations;
  String profilePicKey;
  bool hasNameDayUpdated;

  String profilePicUrl;

  User(this.email, this.password, this.firstName, this.lastName, this.id,
      this.celebrations, this.profilePicKey, this.profilePicUrl,this.hasNameDayUpdated);

  User.fromJson(Map json)
      : email = json['email'],
        password = json['password'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        id = json['id'],
        celebrations =  (json['celebrations'] as Iterable)
                .map((celebrations) => Celebration.fromJson(celebrations))
                .toList(),
        profilePicKey = json['profilePicKey'],
        profilePicUrl = json['profilePicUrl'],
        hasNameDayUpdated = json['hasNameDayUpdated'];
        

  Map toJson() {
    return {
      'profilePicUrl': profilePicUrl,
      'profilePicKey': profilePicKey,
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'celebrations': celebrations,
      'hasNameDayUpdated' : hasNameDayUpdated,
    };
  }
}
