import 'dart:convert';
import 'package:http/http.dart' as http;
import '/modelos/reporte2.dart';

class ReporteApi {
  static const String baseUrl = 'https://retoolapi.dev/8ET0Ef/reports';

  // Obtener todos los reportes
  static Future<List<Reporte>> getAllReportes() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Reporte.fromJson(item)).toList();
    } else {
      print('Failed to load reports with status: ${response.statusCode}');
      throw Exception('Failed to load reports');
    }
  }

  // Obtener reportes por ID de usuario
  static Future<List<Reporte>> getReportesByUserId(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl?idUser=$userId'));
    print('API call: $baseUrl?idUser=$userId');
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Reporte.fromJson(item)).toList();
    } else {
      print('Failed to load reports with status: ${response.statusCode}');
      throw Exception('Failed to load reports');
    }
  }

  // Crear un nuevo reporte
  static Future<http.Response> createReporte(Reporte reporte) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reporte.toJson()),
    );
    print('Creating report with data: ${jsonEncode(reporte.toJson())}');
    print('Response status: ${response.statusCode}');
    return response;
  }

  // Actualizar un reporte
  static Future<http.Response> updateReporte(Reporte reporte) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${reporte.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(reporte.toJson()),
    );
    print('Updating report with data: ${jsonEncode(reporte.toJson())}');
    print('Response status: ${response.statusCode}');
    return response;
  }
}



