import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (Platform.isAndroid || Platform.isIOS) {
      // Lógica para dispositivos móviles
      Navigator.pushReplacementNamed(context, '/sendReport');
    } else {
      // Lógica para la web
      if (_emailController.text == 'a@a.com' || _emailController.text == 'b@a.com') {
        Navigator.pushReplacementNamed(context, '/manageUsers');
      } else {
        // Manejo de error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Access Denied for non-UC users on web'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
