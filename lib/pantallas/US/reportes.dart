import 'package:flutter/material.dart';
import '/servicios/api_servicio_reporte.dart'; // Importa las funciones de la API de reportes
import '/modelos/reporte2.dart'; // Importa el modelo de Reporte
import '/modelos/usuario.dart'; // Importa el modelo de Usuario
import 'ver_reporte.dart'; // Importa el modelo de Usuario

class SendReportScreen extends StatefulWidget {
  final User user;

  SendReportScreen({required this.user});

  @override
  _SendReportScreenState createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  late Future<List<Reporte>> futureReportes;

  @override
  void initState() {
    super.initState();
    _fetchReportes();
  }

  void _fetchReportes() {
    setState(() {
      futureReportes = ReporteApi.getReportesByUserId(widget.user.id.toString());
    });
  }

  void _navigateToCreateReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReportScreen(
          user: widget.user,
          onReportCreated: _fetchReportes,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Reports'),
      ),
      body: FutureBuilder<List<Reporte>>(
        future: futureReportes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Failed to load reports'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No reports found'));
          } else {
            print('Reports loaded: ${snapshot.data!.length}');
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final reporte = snapshot.data![index];
                      print('Report: ${reporte.issue}, ${reporte.description}, ${reporte.creationDate}');
                      return ListTile(
                        title: Text(reporte.issue ?? 'No issue'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reporte.description ?? 'No description'),
                            Text('Rating: ${reporte.rating ?? 'Not rated yet'}'),
                          ],
                        ),
                        trailing: Text(reporte.creationDate ?? 'No creation date'),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: _navigateToCreateReport,
                    child: Text('Create New Report'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

