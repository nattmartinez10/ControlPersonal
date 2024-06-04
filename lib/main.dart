import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:personal/servicios/api_servicio.dart';
import 'pantallas/comun/login.dart';
import 'pantallas/comun/registro.dart';
import 'pantallas/UC/manejar_usuarios.dart';
import 'pantallas/UC/manejar_clientes.dart';
import 'pantallas/UC/evaluar_reporte.dart';
import 'pantallas/US/enviar_reporte.dart';
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

  Hive.registerAdapter(ReportAdapter());
  await Hive.openBox<Report>('reports');

  // Intentar sincronizar los reportes al inicio de la aplicación
  await ApiService.syncReports();

  runApp(RemotePersonnelControlApp());
}

class RemotePersonnelControlApp extends StatefulWidget {
  @override
  _RemotePersonnelControlAppState createState() => _RemotePersonnelControlAppState();
}

class _RemotePersonnelControlAppState extends State<RemotePersonnelControlApp> {
 // @override
 // void initState() {
  //  super.initState();

   // Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
     // if (result != ConnectivityResult.none) {
     //   ApiService.syncReports();
    //  }
  //  });
 // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Personnel Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/manageUsers': (context) => ManageUsersScreen(),
        '/manageClients': (context) => ManageClientsScreen(),
        '/evaluateReports': (context) => EvaluateReportsScreen(),
        '/sendReport': (context) => SendReportScreen(),
        '/viewReports': (context) => ViewReportsScreen(),
      },
    );
  }
}
