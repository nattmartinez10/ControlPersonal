// modelos/reporte2.dart
class Reporte {
  int id;
  String? issue;
  String? rating;
  String? idUser;
  String? duration;
  String? idClient;
  String? idReport;
  String? startTime;
  String? description;
  String? creationDate;

  Reporte({
    required this.id,
    this.issue,
    this.rating,
    this.idUser,
    this.duration,
    this.idClient,
    this.idReport,
    this.startTime,
    this.description,
    this.creationDate,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['id'],
      issue: json['Issue'],
      rating: json['Rating'],
      idUser: json['idUser'],
      duration: json['Duration'],
      idClient: json['idClient'],
      idReport: json['idReport'],
      startTime: json['Start Time'],
      description: json['Description'],
      creationDate: json['Creation Date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Issue': issue,
      'Rating': rating,
      'idUser': idUser,
      'Duration': duration,
      'idClient': idClient,
      'idReport': idReport,
      'Start Time': startTime,
      'Description': description,
      'Creation Date': creationDate,
    };
  }
}



