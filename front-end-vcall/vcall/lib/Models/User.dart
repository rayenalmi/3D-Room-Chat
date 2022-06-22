class User {
  String? id;
  String? email;
  String? password;
  String? first_name;
  String? last_name;

  User({
    this.id,
    this.email,
    this.password,
    this.first_name,
    this.last_name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      email: json['email'],
      first_name: json['firstName'],
      last_name: json['lastName'],
    );
  }
}
