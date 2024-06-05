import 'dart:convert';
import 'package:http/http.dart' as http;
import '/modelos/cliente.dart';

class ClientesService {
  final String apiUrl = 'https://api-generator.retool.com/D85qYo/clients';

  Future<List<Clientes>> fetchClientes() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> clientList = json.decode(response.body);
      return clientList.map((json) => Clientes.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }

  Future<void> updateCliente(Clientes cliente) async {
    final response = await http.put(
      Uri.parse('$apiUrl/${cliente.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update client');
    }
  }

  Future<void> createCliente(Clientes cliente) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create client');
    }
  }

  Future<void> deleteCliente(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete client');
    }
  }
}
