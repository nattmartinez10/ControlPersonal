import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  
  if (!Platform.isAndroid && !Platform.isIOS) {
    await Hive.initFlutter();
  } else {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
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
  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        ApiService.syncReports();
      }
    } as void Function(List<ConnectivityResult> event)?);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remote Personnel Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
