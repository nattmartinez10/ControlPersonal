import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:personal/modelos/reporte.dart';

class SendReportScreen extends StatefulWidget {
  @override
  _SendReportScreenState createState() => _SendReportScreenState();
}

class _SendReportScreenState extends State<SendReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  void _saveReport() async {
    String description = _descriptionController.text;
    String client = _clientController.text;
    int duration = int.parse(_durationController.text);
    DateTime startTime = DateTime.now();

    Report newReport = Report(
      description: description,
      client: client,
      startTime: startTime,
      duration: duration,
    );

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      var box = await Hive.openBox<Report>('reports');
      box.add(newReport);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Report saved locally. Will sync when online.'),
      ));
    } else {
      // Aquí deberías agregar la lógica para enviar el reporte al backend y marcarlo como sincronizado
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Report sent successfully.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _clientController,
              decoration: InputDecoration(labelText: 'Client'),
            ),
            TextField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveReport,
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
