import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:personal/modelos/reporte.dart';

class ApiService {
  static Future<void> syncReports() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      var box = await Hive.openBox<Report>('reports');
      List<Report> reports = box.values.where((report) => !report.isSynced).toList();

      for (var report in reports) {     
        report.isSynced = true;
        await report.save();
      }
    }
  }
}
