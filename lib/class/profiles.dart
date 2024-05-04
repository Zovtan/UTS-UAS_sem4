class Profile {
  final int id;
  final String username;
  final String displayName;
  final String email;
  final String phone;
  final String password;

  Profile({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class ProfileData {
  List<Profile> profiles = [
    Profile(
        id: 1,
        username: "@test",
        displayName: "tester",
        email: "test@gmail.com",
        phone: "12345",
        password: "test"),
    Profile(
        id: 2,
        username: "@gorlockthebambino",
        displayName: "Bambino",
        email: "",
        phone: "99999",
        password: "99999"),
  ];

  void addProfile(Profile profile) {
    profiles.add(profile);
  }
}
