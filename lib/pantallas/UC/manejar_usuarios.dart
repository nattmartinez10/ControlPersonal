import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final List<Map<String, String>> _users = [
    {'id': '1', 'name': 'John Doe', 'email': 'john@example.com', 'password': 'password123'},
    {'id': '2', 'name': 'Jane Smith', 'email': 'jane@example.com', 'password': 'password123'},
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _editingUserId;

  void _showForm({Map<String, String>? user}) {
    if (user != null) {
      _editingUserId = user['id'];
      _nameController.text = user['name']!;
      _emailController.text = user['email']!;
      _passwordController.text = user['password']!;
    } else {
      _editingUserId = null;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(user == null ? 'Add User' : 'Edit User'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10), // Separación entre inputs
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10), // Separación entre inputs
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    if (_editingUserId == null) {
                      _users.add({
                        'id': DateTime.now().millisecondsSinceEpoch.toString(),
                        'name': _nameController.text,
                        'email': _emailController.text,
                        'password': _passwordController.text,
                      });
                    } else {
                      final index = _users.indexWhere((user) => user['id'] == _editingUserId);
                      if (index != -1) {
                        _users[index] = {
                          'id': _editingUserId!,
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'password': _passwordController.text,
                        };
                      }
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: Text(user == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(String id) {
    setState(() {
      _users.removeWhere((user) => user['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Users', style: GoogleFonts.ubuntu(fontSize: size.height * 0.030)),
        backgroundColor: Color(0xFF1A237E), // Azul oscuro
      ),
      body: Center( // Centrar la tabla
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _users.map((user) {
                      return DataRow(cells: [
                        DataCell(Text(user['id']!)),
                        DataCell(Text(user['name']!)),
                        DataCell(Text(user['email']!)),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Color(0xFF1A237E)),
                              onPressed: () => _showForm(user: user),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user['id']!),
                            ),
                          ],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon( // Botón con ícono moderno
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF1A237E)), // Color azul oscuro
                ),
                onPressed: () => _showForm(),
                icon: Icon(Icons.add, color: Colors.white), // Ícono
                label: Text('Add User', style: TextStyle(color: Colors.white)), // Texto
              ),
            ],
          ),
        ),
      ),
    );
  }
}


