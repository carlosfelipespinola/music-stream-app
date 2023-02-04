class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(name: "a", email: "b");
  }
}
