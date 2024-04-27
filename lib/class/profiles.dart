class Profile {
  final String username;
  final String displayName;
    final String email;
  final String phone;
  final String password;


  Profile(
      {
      required this.username,
      required this.displayName,
      required this.email,
      required this.phone,
      required this.password,
});
}

class ProfileData {
  List<Profile> profiles = [
    Profile(username: "@eagat", displayName: "are",email:"ea@gmail.com", phone:"12345",  password: "a"),
    Profile(username: "1", displayName: "1e",email:"1@g", phone:"2",  password: "1"),
  ];

  /* void addProfile(String username, String displayName, String email, String phone,  String password) {
    profiles.add(Profile(username: username, displayName: displayName, email:email, phone:phone,  password: password));
  } */

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
}