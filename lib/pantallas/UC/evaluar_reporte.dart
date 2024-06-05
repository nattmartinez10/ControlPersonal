import 'dart:math';

import 'package:flutter/material.dart';
import '/servicios/api_servicio_reporte.dart'; // Importa las funciones de la API de reportes
import '/modelos/reporte2.dart'; // Importa el modelo de Reporte
import '/servicios/api_servicio_usuario.dart'; // Importa las funciones de la API de usuarios
import '/servicios/api_servicios_cliente.dart'; // Importa las funciones de la API de clientes
import '/modelos/usuario.dart'; // Importa el modelo de Usuario
import '/modelos/cliente.dart'; // Importa el modelo de Cliente

class EvaluateReportsScreen extends StatefulWidget {
  @override
  _EvaluateReportsScreenState createState() => _EvaluateReportsScreenState();
}

class _EvaluateReportsScreenState extends State<EvaluateReportsScreen> {
  late Future<List<Reporte>> futureReportes;
  List<Reporte> reportes = [];
  String selectedClient = '';
  String selectedUser = '';

  List<User> users = [];
  List<Clientes> clients = [];

  String? selectedClientId;
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await _fetchReportes();
    await _fetchUsers();
    await _fetchClients();
    setState(() {});
  }

  Future<void> _fetchReportes() async {
    futureReportes = ReporteApi.getAllReportes();
    reportes = await futureReportes;
  }

  Future<void> _fetchUsers() async {
    final userService = UserService();
    users = await userService.fetchUsers();
  }

  Future<void> _fetchClients() async {
    final clientService = ClientesService();
    clients = await clientService.fetchClientes();
  }

  Future<void> _updateRating(Reporte reporte, String rating) async {
    reporte.rating = rating;

    // Verificar si el reporte es nuevo (id es nulo o 0)
    if (reporte.id == null || reporte.id == 0) {
      // Crear un nuevo reporte
      final response = await ReporteApi.createReporte(reporte);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report created successfully')),
        );
        _fetchReportes(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create report')),
        );
      }
    } else {
      // Actualizar un reporte existente
      final response = await ReporteApi.updateReporte(reporte);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rating updated successfully')),
        );
        _fetchReportes(); // Refresh the list
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update rating')),
        );
      }
    }
  }

  void _generateClientReports() {
    List<Reporte> filteredReportes = reportes.where((reporte) {
      bool matchClient = selectedClientId == null ||
          selectedClientId!.isEmpty ||
          reporte.idClient == selectedClientId;
      bool matchUser = selectedUserId == null ||
          selectedUserId!.isEmpty ||
          reporte.idUser == selectedUserId;
      return matchClient && matchUser;
    }).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Client Reports"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: filteredReportes.map((reporte) {
                final user = users.firstWhere(
                    (user) => user.id.toString() == reporte.idUser,
                    orElse: () => User(id: 0, name: 'Unknown'));
                final client = clients.firstWhere(
                    (client) => client.id.toString() == reporte.idClient,
                    orElse: () => Clientes(id: 0, clientName: 'Unknown'));
                return ListTile(
                  title: Text("Fecha: ${reporte.creationDate}"),
                  subtitle:
                      Text("US: ${user.name}, Evaluación: ${reporte.rating}"),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _generateUserReports() {
    Map<String, List<Reporte>> userReportMap = {};
    for (var reporte in reportes) {
      if (!userReportMap.containsKey(reporte.idUser)) {
        userReportMap[reporte.idUser!] = [];
      }
      userReportMap[reporte.idUser!]!.add(reporte);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("User Reports"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: userReportMap.entries.map((entry) {
                String userId = entry.key;
                List<Reporte> reportList = entry.value;
                final user = users.firstWhere(
                    (user) => user.id.toString() == userId,
                    orElse: () => User(id: 0, name: 'Unknown'));
                double avgRating = reportList
                        .map((r) => double.tryParse(r.rating ?? "0") ?? 0)
                        .reduce((a, b) => a + b) /
                    reportList.length;
                return ListTile(
                  title: Text("US: ${user.name}"),
                  subtitle: Text(
                      "Número de Reportes: ${reportList.length}, Calificación Promedio: $avgRating"),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Evaluate Reports'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              _generateClientReports();
            },
            tooltip: "Generate Client Reports",
          ),
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () {
              _generateUserReports();
            },
            tooltip: "Generate User Reports",
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                _buildFilters(),
                Expanded(
                  child: FutureBuilder<List<Reporte>>(
                    future: futureReportes,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Failed to load reports'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No reports found'));
                      } else {
                        reportes = snapshot.data!;
                        return ListView.builder(
                          itemCount: reportes.length,
                          itemBuilder: (context, index) {
                            final reporte = reportes[index];
                            final user = users.firstWhere(
                                (user) => user.id.toString() == reporte.idUser,
                                orElse: () => User(id: 0, name: 'Unknown'));
                            final client = clients.firstWhere(
                                (client) =>
                                    client.id.toString() == reporte.idClient,
                                orElse: () =>
                                    Clientes(id: 0, clientName: 'Unknown'));
                            if (reporte.rating == "N/A") {
                              reporte.rating = null;
                            }
                            return ListTile(
                              title: Text(reporte.issue ?? 'No issue'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Descripción: ${reporte.description ?? 'No description'}'),
                                  Text('Usuario: ${user.name}'),
                                  Text('Cliente: ${client.clientName}'),
                                  Text(
                                      'Evaluación Actual: ${reporte.rating ?? 'Not rated yet'}'),
                                  Text(
                                      'Fecha: ${reporte.creationDate ?? 'No creation date'}'),
                                  DropdownButton<String>(
                                    hint: Text('Calificar este reporte'),
                                    value: reporte.rating,
                                    items: ['1', '2', '3', '4', '5']
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newRating) {
                                      if (newRating != null) {
                                        _updateRating(reporte, newRating);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Client'),
              value: selectedClientId,
              items: clients.map((Clientes client) {
                return DropdownMenuItem<String>(
                  value: client.id.toString(),
                  child: Text(client.clientName ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClientId = value;
                });
              },
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'User'),
              value: selectedUserId,
              items: users.map((User user) {
                return DropdownMenuItem<String>(
                  value: user.id.toString(),
                  child: Text(user.name ?? ''),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUserId = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
