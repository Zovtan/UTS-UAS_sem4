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
        username: "@eagat",
        displayName: "are",
        email: "ea@gmail.com",
        phone: "12345",
        password: "a"),
    Profile(
        id: 2,
        username: "1",
        displayName: "1e",
        email: "1@g",
        phone: "2",
        password: "1"),
  ];

    void addProfile(Profile profile) {
    profiles.add(profile);
  }
}



  /* void deleteBook(int index) {
    if (index >= 0 && index < books.length) {
      books.removeAt(index);
    }
  }

  void updateBook(int index, String title, String author) {
    if (index >= 0 && index < books.length) {
      books[index] = Profile(title: title, author: author);
    }
  } */