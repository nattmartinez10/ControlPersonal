class Clientes {
  int? id;
  String? clientName;
  String? createdIn;

  Clientes({this.id, this.clientName, this.createdIn});

  factory Clientes.fromJson(Map<String, dynamic> json) {
    return Clientes(
      id: json['id'],
      clientName: json['name'],
      createdIn: json['createdIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': clientName,
      'createdIn': createdIn,
    };
  }
}
