import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Clientes {
  int? id;
  String? clientName;
  String? createdIn;

  Clientes({this.id, this.clientName, this.createdIn});

  factory Clientes.fromJson(Map<String, dynamic> json) {
    return Clientes(
      id: json['id'],
      clientName: json['name'],
      createdIn: json['createdIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': clientName,
      'createdIn': createdIn,
    };
  }
}

class ManageClientsScreen extends StatefulWidget {
  @override
  _ManageClientsScreenState createState() => _ManageClientsScreenState();
}

class _ManageClientsScreenState extends State<ManageClientsScreen> {
  List<Clientes> _clientes = [];
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchClientes();
  }

  Future<void> fetchClientes() async {
    final response = await http
        .get(Uri.parse('https://api-generator.retool.com/D85qYo/clients'));

    if (response.statusCode == 200) {
      final List<dynamic> clientList = json.decode(response.body);
      setState(() {
        _clientes = clientList.map((json) => Clientes.fromJson(json)).toList();
        _clientes.sort((a, b) =>
            a.id!.compareTo(b.id!)); // Ordenar por ID de menor a mayor
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load clients');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Clients'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Nombre')),
                          DataColumn(label: Text('Acción')),
                        ],
                        rows: _clientes
                            .map(
                              (cliente) => DataRow(cells: [
                                DataCell(Text(cliente.id.toString())),
                                DataCell(Text(cliente.clientName ?? '')),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ClientDetailScreen(
                                                  cliente: cliente),
                                        ),
                                      ).then((_) =>
                                          fetchClientes()); // Actualizar la lista al regresar
                                    },
                                    child: Text('Ver detalles'),
                                  ),
                                ),
                              ]),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class ClientDetailScreen extends StatefulWidget {
  final Clientes cliente;

  ClientDetailScreen({required this.cliente});

  @override
  _ClientDetailScreenState createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _idController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.cliente.id.toString());
    _nameController = TextEditingController(text: widget.cliente.clientName);
  }

  Future<void> updateCliente() async {
    final updatedCliente = Clientes(
      id: int.tryParse(_idController.text),
      clientName: _nameController.text,
      createdIn: widget.cliente.createdIn, // Asegurarse de mantener createdIn
    );

    // Si el ID ha cambiado, crea un nuevo registro y elimina el antiguo
    if (updatedCliente.id != widget.cliente.id) {
      final createResponse = await http.post(
        Uri.parse('https://api-generator.retool.com/D85qYo/clients'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedCliente.toJson()),
      );

      if (createResponse.statusCode == 201) {
        final deleteResponse = await http.delete(
          Uri.parse(
              'https://api-generator.retool.com/D85qYo/clients/${widget.cliente.id}'),
        );

        if (deleteResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cliente actualizado correctamente')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error al eliminar el cliente antiguo')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al crear el nuevo cliente')));
      }
    } else {
      final response = await http.put(
        Uri.parse(
            'https://api-generator.retool.com/D85qYo/clients/${widget.cliente.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedCliente.toJson()),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cliente actualizado correctamente')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar el cliente')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Cliente'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un ID';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor ingresa un ID válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateCliente();
                  }
                },
                child: Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}