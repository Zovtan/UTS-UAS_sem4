class Profile {
  final int? id; // id can be nullable for new profiles (karena ada auto increment di backend)
  final String username;
  final String displayName;
  final String email;
  final String password;

  Profile({
    this.id, // id is optional
    required this.username,
    required this.displayName,
    required this.email,
    required this.password,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      displayName: json['displayName'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
      'password': password,
    };
  }
}
