import 'package:flutter/material.dart';
import '/servicios/api_servicio_usuario.dart';
import '/modelos/usuario.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<User> _users = [];
  bool _isLoading = true;
  //el objeto que se encarga de hacer las peticiones a la API
  final UserService _service = UserService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final usersf = await _service.fetchUsers();
      setState(() {
        _users = usersf;
        _users.sort((a, b) =>
            a.id!.compareTo(b.id!)); // Ordenar por ID de menor a mayor
        _isLoading = false;
      });
    } catch (e) {
      // Manejar el error
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _service.deleteUser(id);
      fetchUsers();
    } catch (e) {
      // Manejar el error
    }
  }

  Future<void> confirmDelete(BuildContext context, User user) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content:
              Text('¿Está seguro que desea eliminar al usuario ${user.name}?'),
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
                deleteUser(user.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showClientDialog({User? user}) async {
    final isNewUser = user == null;
    final User userToEdit = user ?? User();

    TextEditingController idController =
        TextEditingController(text: userToEdit.id?.toString() ?? '');
    TextEditingController nameController =
        TextEditingController(text: userToEdit.name ?? '');
    TextEditingController emailController =
        TextEditingController(text: userToEdit.email ?? '');
    TextEditingController passwordController =
        TextEditingController(text: userToEdit.password ?? '');

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isNewUser ? 'Crear Cliente' : 'Actualizar Cliente'),
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
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un pasword';
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
                userToEdit.createdTime ??=
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                final updateUser = User(
                  id: int.tryParse(idController.text),
                  name: nameController.text,
                  type: "US",
                  email: emailController.text,
                  password: passwordController.text,
                  createdTime: userToEdit.createdTime,
                );

                final users = await _service.fetchUsers();
                if (updateUser.id != userToEdit.id &&
                    users.any((c) => c.id == updateUser.id)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('El ID ya existe, por favor ingrese otro ID')),
                  );
                  return;
                }

                if (isNewUser) {
                  await _service.createUser(updateUser);
                } else {
                  if (updateUser.id != userToEdit.id) {
                    await _service.createUser(updateUser);
                    await _service.deleteUser(updateUser.id!);
                  } else {
                    await _service.updateUser(updateUser);
                  }
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'User ${isNewUser ? 'creado' : 'actualizado'} correctamente')),
                );
                Navigator.of(context).pop();
                fetchUsers();
              },
              child: Text(isNewUser ? 'Crear' : 'Actualizar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manejo de Usuario'),
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
                        label: Text('Agregar Usuario'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFF1A237E), // Color azul oscuro
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
                        'Manejo de Usuarios',
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
                            DataColumn(
                                label: Text('ID',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E)))),
                            DataColumn(
                                label: Text('Nombre',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E)))),
                            DataColumn(
                                label: Text('Email',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E)))),
                            DataColumn(
                                label: Text('Password',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E)))),
                            DataColumn(
                                label: Text('Acción',
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1A237E)))),
                          ],
                          rows: _users
                              .where((user) => user.type == 'US')
                              .map((user) {
                            return DataRow(cells: [
                              DataCell(Text(user.id.toString(),
                                  style: GoogleFonts.ubuntu())),
                              DataCell(Text(user.name ?? '',
                                  style: GoogleFonts.ubuntu())),
                              DataCell(Text(user.email ?? '',
                                  style: GoogleFonts.ubuntu())),
                              DataCell(Text(user.password ?? '',
                                  style: GoogleFonts.ubuntu())),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Color.fromARGB(255, 112, 115, 152),
                                      onPressed: () {
                                        showClientDialog(user: user);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Color(0xFF1A237E),
                                      onPressed: () {
                                        confirmDelete(context, user);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                          }).toList(),
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
