import 'dart:convert';
import 'package:http/http.dart' as http;
import '/modelos/usuario.dart';

class UserApi {
  static const String baseUrl = 'https://retoolapi.dev/tpjLQ5/datausersfinaaal';

  static Future<User?> getUserByEmail(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?email=$email'));
      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        if (users.isNotEmpty) {
          return User.fromJson(users[0]);
        }
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }
}
