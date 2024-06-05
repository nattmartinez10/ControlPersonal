class User {
  final int id;
  final String name;
  final String type;
  final String email;
  final String password;
  final String createdtime;

  User({
    required this.id,
    required this.name,
    required this.type,
    required this.email,
    required this.password,
    required this.createdtime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      email: json['email'],
      password: json['password'],
      createdtime: json['createdtime'],
    );
  }
}

