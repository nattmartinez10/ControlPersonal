class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final String clave;
  final String rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.clave,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      correo: json['correo'],
      clave: json['clave'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'clave': clave,
      'rol': rol,
    };
  }
}
