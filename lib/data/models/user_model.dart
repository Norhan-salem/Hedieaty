class User {
  String id;
  String username;
  String email;
  String password;
  String phoneNumber;
  String profileImagePath;
  bool isDeleted;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.profileImagePath = 'https://i.ibb.co/WfJVvF6/profile-mock.png',
    this.isDeleted = false
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      phoneNumber: map['phone_number'],
      profileImagePath: map['profile_image_path'],
      isDeleted: map['isDeleted'] == false
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
      'isDeleted': isDeleted ? true : false
    };
  }
}
