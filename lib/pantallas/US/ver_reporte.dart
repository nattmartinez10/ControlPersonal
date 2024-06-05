import 'package:flutter/material.dart';
import '/servicios/api_servicio_reporte.dart'; // Importa las funciones de la API de reportes
import '/modelos/reporte2.dart'; // Importa el modelo de Reporte
import '/modelos/cliente.dart'; // Importa el modelo de Cliente
import '/modelos/usuario.dart'; // Importa el modelo de Usuario
import '/servicios/api_servicios_cliente.dart'; // Importa el servicio de Clientes

class CreateReportScreen extends StatefulWidget {
  final User user;
  final VoidCallback onReportCreated;

  CreateReportScreen({required this.user, required this.onReportCreated});

  @override
  _CreateReportScreenState createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  late Future<List<Clientes>> futureClientes;
  Clientes? _selectedClient;
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    futureClientes = ClientesService().fetchClientes(); // Llama a la función fetchClientes del servicio
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate() && _selectedClient != null) {
      Reporte reporte = Reporte(
        id: 0, // El ID se generará automáticamente
        idUser: widget.user.id.toString(),
        issue: _issueController.text,
        rating: 'N/A', // No hay campo de calificación en el formulario original
        duration: _durationController.text,
        idClient: _selectedClient!.id.toString(),
        idReport: 'N/A', // No hay campo de idReport en el formulario original
        startTime: _selectedTime.format(context),
        description: _descriptionController.text,
        creationDate: _formatDate(DateTime.now()), // Formato YYYY-MM-DD
      );

      final response = await ReporteApi.createReporte(reporte); // Llama a la función de crear reporte del archivo correspondiente
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Report created successfully'),
        ));
        widget.onReportCreated(); // Llama al callback para actualizar la lista de reportes
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
          child: FutureBuilder<List<Clientes>>(
            future: futureClientes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print('Error: ${snapshot.error}');
                return Center(child: Text('Failed to load clients'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No clients found'));
              } else {
                return ListView(
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
                      controller: _durationController,
                      decoration: InputDecoration(labelText: 'Duration'),
                    ),
                    DropdownButtonFormField<Clientes>(
                      items: snapshot.data!.map((Clientes client) {
                        return DropdownMenuItem<Clientes>(
                          value: client,
                          child: Text(client.clientName ?? 'Unknown Client'),
                        );
                      }).toList(),
                      onChanged: (Clientes? newValue) {
                        setState(() {
                          _selectedClient = newValue;
                        });
                      },
                      hint: Text('Select Client'),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a client';
                        }
                        return null;
                      },
                    ),
                    ListTile(
                      title: Text("Start Time: ${_selectedTime.format(context)}"),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitReport,
                      child: Text('Submit'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

