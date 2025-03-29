class User {
  final String email;
  final String password;
  final String name;
  final String userType; // 'student' or 'seller'

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.userType,
  });
}