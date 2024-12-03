class User {
  int id;
  String username;
  String email;
  String password;
  String phoneNumber;
  String profileImagePath;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.profileImagePath,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phone_number'],
      profileImagePath: map['profile_image_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'profile_image_path': profileImagePath,
    };
  }
}
