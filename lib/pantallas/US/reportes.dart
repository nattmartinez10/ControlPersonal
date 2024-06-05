import 'package:flutter/material.dart';
import '/servicios/api_servicios_reporte.dart';
import '/modelos/reporte2.dart';
import '/modelos/usuario.dart';

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
    print(widget.user.id.toString());
    futureReportes = ReporteApi.getReportesByUserId(widget.user.id.toString());
  }

  void _navigateToCreateReport() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReportScreen(user: widget.user),
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
                        subtitle: Text(reporte.description ?? 'No description'),
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

class CreateReportScreen extends StatefulWidget {
  final User user;

  CreateReportScreen({required this.user});

  @override
  _CreateReportScreenState createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      Reporte reporte = Reporte(
        id: 0, // El ID se generará automáticamente
        idUser: widget.user.id.toString(),
        issue: _issueController.text,
        rating: _ratingController.text,
        duration: _durationController.text,
        idClient: _clientController.text,
        idReport: _reportController.text,
        startTime: _startTimeController.text,
        description: _descriptionController.text,
        creationDate: DateTime.now().toString(),
      );

      final response = await ReporteApi.createReporte(reporte);
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Report created successfully'),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create report'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _issueController,
                decoration: InputDecoration(labelText: 'Issue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an issue';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ratingController,
                decoration: InputDecoration(labelText: 'Rating'),
              ),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: 'Duration'),
              ),
              TextFormField(
                controller: _clientController,
                decoration: InputDecoration(labelText: 'Client ID'),
              ),
              TextFormField(
                controller: _reportController,
                decoration: InputDecoration(labelText: 'Report ID'),
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(labelText: 'Start Time'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReport,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
