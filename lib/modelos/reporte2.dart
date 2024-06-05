class Reporte {
  final int id;
  final String? idUser;
  final String? issue;
  final String? rating;
  final String? duration;
  final String? idClient;
  final String? idReport;
  final String? startTime;
  final String? description;
  final String? creationDate;

  Reporte({
    required this.id,
    this.idUser,
    this.issue,
    this.rating,
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
      idUser: json['idUser'] as String?,
      issue: json['Issue'] as String?,
      rating: json['Rating'] as String?,
      duration: json['Duration'] as String?,
      idClient: json['idClient'] as String?,
      idReport: json['idReport'] as String?,
      startTime: json['Start Time'] as String?,
      description: json['Description'] as String?,
      creationDate: json['Creation Date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUser': idUser,
      'Issue': issue,
      'Rating': rating,
      'Duration': duration,
      'idClient': idClient,
      'idReport': idReport,
      'Start Time': startTime,
      'Description': description,
      'Creation Date': creationDate,
    };
  }
}


