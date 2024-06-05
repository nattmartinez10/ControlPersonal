class User {
  int? id;
  String? name;
  String? type;
  String? email;
  String? password;
  String? createdTime;

  User({
    this.id,
    this.name,
    this.type,
    this.email,
    this.password,
    this.createdTime,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      email: json['email'],
      password: json['password'],
      createdTime: json['createdtime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'email': email,
      'password': password,
      'createdTime': createdTime,
    };
  }
}