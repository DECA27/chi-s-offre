import 'dart:convert';
import 'package:fides_calendar/environment/environment.dart';
import 'package:fides_calendar/models/user.dart';
import 'package:http/http.dart' as http;

class Authorization {
  static String token;

  static void logout() {
    token = null;
  }

  static Future<bool> login(String email, String password) async {
    http.Response response = await http.post(
        "${Environment.siteUrl}/login",
        body: {'email': email, 'password': password});

    if (response.statusCode == 200) {
      saveToken(response.body);
      return true;
    } else {
      return false;
    }
  }

  static void saveToken(String responseToken) {
    token = "Bearer " + responseToken;
  }

  static Map<String, dynamic> _parseJwt() {
    try {
      final pieces = token.split(' ');
      final parts = pieces[1].split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);
      if (payloadMap is! Map<String, dynamic>) {
        throw Exception('invalid payload');
      }

      return payloadMap;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static User getLoggedUser() {
    try {
      return User.fromJson(_parseJwt()['user']);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
