import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UC Menu'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageUsers');
              },
              child: Text('Manage Users',
                  style: TextStyle(
                      color:
                          Colors.white)), // Cambiar el color del texto a blanco
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 55, vertical: 20),
                backgroundColor: Colors.indigo,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageClients');
              },
              child: Text('Manage Clients',
                  style: TextStyle(
                      color:
                          Colors.white)), // Cambiar el color del texto a blanco
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                backgroundColor: Colors.indigo,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/evaluateReports');
              },
              child: Text('Evaluate Reports',
                  // Cambiar el color del texto a blanco
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 45, vertical: 20),
                backgroundColor: Colors.indigo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}