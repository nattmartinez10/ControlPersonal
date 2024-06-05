import 'dart:convert';
import 'package:http/http.dart' as http;
import '/modelos/reporte2.dart';

class ReporteApi {
  static const String baseUrl = 'https://retoolapi.dev/8ET0Ef/reports';

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
}

