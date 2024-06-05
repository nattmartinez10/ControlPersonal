import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal/servicios/api_servicio.dart';
import 'pantallas/comun/login.dart';
import 'pantallas/UC/menu.dart';
import 'pantallas/UC/manejar_usuarios.dart';
import 'pantallas/UC/manejar_clientes.dart';
import 'pantallas/UC/evaluar_reporte.dart';
import 'pantallas/US/reportes.dart';
import 'pantallas/US/ver_reporte.dart';
import 'modelos/reporte.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
  } else {
    await Hive.initFlutter();
  }


  runApp(RemotePersonnelControlApp());
}

class RemotePersonnelControlApp extends StatefulWidget {
  @override
  _RemotePersonnelControlAppState createState() => _RemotePersonnelControlAppState();
}

class _RemotePersonnelControlAppState extends State<RemotePersonnelControlApp> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Tracker Solutions',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.blueAccent),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            backgroundColor: Colors.blueAccent,
            textStyle: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/menu': (context) => MenuScreen(),
        '/manageUsers': (context) => ManageUsersScreen(),
        '/manageClients': (context) => ManageClientsScreen(),
        '/evaluateReports': (context) => EvaluateReportsScreen(),
      },
    );
  }
}
