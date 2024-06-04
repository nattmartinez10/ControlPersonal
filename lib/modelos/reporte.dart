import 'package:hive/hive.dart';

part 'reporte.g.dart';

@HiveType(typeId: 0)
class Report extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  String client;

  @HiveField(2)
  DateTime startTime;

  @HiveField(3)
  int duration;

  @HiveField(4)
  bool isSynced;

  Report({required this.description, required this.client, required this.startTime, required this.duration, this.isSynced = false});
}
