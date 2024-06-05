import 'dart:convert';
import 'package:http/http.dart' as http;
import '/modelos/usuario.dart';

class UserService {
  static const String apiUrl =
      'https://api-generator.retool.com/tpjLQ5/datausersfinaaal';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> usersList = json.decode(response.body);
      return usersList.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> updateUser(User user) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> createUser(User user) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  static Future<User?> getUserByEmail(String email) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?email=$email'));
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

