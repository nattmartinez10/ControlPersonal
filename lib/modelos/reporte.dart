import 'package:hive/hive.dart';

part 'reporte.g.dart';

@HiveType(typeId: 0)
class Reporte {
  @HiveField(0)
  int id;

  @HiveField(1)
  String idUser;

  @HiveField(2)
  String issue;

  @HiveField(3)
  String rating;

  @HiveField(4)
  String duration;

  @HiveField(5)
  String idClient;

  @HiveField(6)
  String idReport;

  @HiveField(7)
  String startTime;

  @HiveField(8)
  String description;

  @HiveField(9)
  String creationDate;

  @HiveField(10)
  String isSent;

  Reporte({
    required this.id,
    required this.idUser,
    required this.issue,
    required this.rating,
    required this.duration,
    required this.idClient,
    required this.idReport,
    required this.startTime,
    required this.description,
    required this.creationDate,
    required this.isSent,
  });
}
