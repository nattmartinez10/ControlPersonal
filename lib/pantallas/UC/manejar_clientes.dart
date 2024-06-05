import 'package:flutter/material.dart';
import '/servicios/api_servicios_cliente.dart';
import '/modelos/cliente.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manage Clients',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ManageClientsScreen(),
    );
  }
}

class ManageClientsScreen extends StatefulWidget {
  @override
  _ManageClientsScreenState createState() => _ManageClientsScreenState();
}

class _ManageClientsScreenState extends State<ManageClientsScreen> {
  List<Clientes> _clientes = [];
  bool _isLoading = true;
  final ClientesService _service = ClientesService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchClientes();
  }

  Future<void> fetchClientes() async {
    try {
      final clients = await _service.fetchClientes();
      setState(() {
        _clientes = clients;
        _clientes.sort((a, b) => a.id!.compareTo(b.id!)); // Ordenar por ID de menor a mayor
        _isLoading = false;
      });
    } catch (e) {
      // Manejar el error
    }
  }

  Future<void> deleteCliente(int id) async {
    try {
      await _service.deleteCliente(id);
      fetchClientes();
    } catch (e) {
      // Manejar el error
    }
  }

  Future<void> confirmDelete(BuildContext context, Clientes cliente) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Está seguro que desea eliminar al cliente ${cliente.clientName}?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                deleteCliente(cliente.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showClientDialog({Clientes? cliente}) async {
    final isNewClient = cliente == null;
    final Clientes clientToEdit = cliente ?? Clientes();

    TextEditingController idController = TextEditingController(text: clientToEdit.id?.toString() ?? '');
    TextEditingController nameController = TextEditingController(text: clientToEdit.clientName ?? '');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isNewClient ? 'Crear Cliente' : 'Actualizar Cliente'),
          content: SingleChildScrollView(
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: idController,
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
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un nombre';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedCliente = Clientes(
                  id: int.tryParse(idController.text),
                  clientName: nameController.text,
                  createdIn: clientToEdit.createdIn,
                );

                final clients = await _service.fetchClientes();
                if (updatedCliente.id != clientToEdit.id && clients.any((c) => c.id == updatedCliente.id)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('El ID ya existe, por favor ingrese otro ID')),
                  );
                  return;
                }

                if (isNewClient) {
                  await _service.createCliente(updatedCliente);
                } else {
                  if (updatedCliente.id != clientToEdit.id) {
                    await _service.createCliente(updatedCliente);
                    await _service.deleteCliente(clientToEdit.id!);
                  } else {
                    await _service.updateCliente(updatedCliente);
                  }
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cliente ${isNewClient ? 'creado' : 'actualizado'} correctamente')),
                );
                Navigator.of(context).pop();
                fetchClientes();
              },
              child: Text(isNewClient ? 'Crear' : 'Actualizar'),
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
        title: Text('Manejo de Clientes'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.add),
                        label: Text('Agregar Cliente'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1A237E), // Color azul oscuro
                          foregroundColor: Colors.white, // Texto blanco
                        ),
                        onPressed: () {
                          showClientDialog();
                        },
                      ),
                      Spacer(),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 80,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Manejo de Clientes',
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A237E),
                        ),
                      ),
                      Spacer(flex: 2),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text('ID', style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
                            DataColumn(label: Text('Nombre', style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
                            DataColumn(label: Text('Acción', style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
                          ],
                          rows: _clientes.map((cliente) => DataRow(cells: [
                            DataCell(Text(cliente.id.toString(), style: GoogleFonts.ubuntu())),
                            DataCell(Text(cliente.clientName ?? '', style: GoogleFonts.ubuntu())),
                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Color(0xFF1A237E),
                                    onPressed: () {
                                      showClientDialog(cliente: cliente);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Color(0xFF1A237E),
                                    onPressed: () {
                                      confirmDelete(context, cliente);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ])).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
