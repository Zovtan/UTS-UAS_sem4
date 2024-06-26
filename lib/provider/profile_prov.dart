import 'package:flutter/material.dart';
import 'package:twitter/class/profiles.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileData _profileData = ProfileData();

  ProfileData get profileData => _profileData;

  void addProfile(Profile profile) {
    _profileData.addProfile(profile);
    notifyListeners();
  }

  Profile? getProfile(String identifier, String password) {
    for (var profile in _profileData.profiles) {
      if ((profile.email == identifier ||
          profile.username == "@$identifier" ||
          profile.phone == identifier) &&
          profile.password == password) {
        return profile;
      }
    }
    return null;
  }

  bool validateAndRegisterProfile({
    required String username,
    required String displayName,
    required String email,
    required String phone,
    required String password,
    required String repeatPassword,
  }) {
    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    if (username.isEmpty || displayName.isEmpty) {
      throw Exception('Please provide a username and a display name.');
    }

    if (email.isEmpty && phone.isEmpty) {
      throw Exception('Please provide either email or phone.');
    }

    if (email.isNotEmpty && !isEmailValid) {
      throw Exception('Please provide a valid email.');
    }

    if (password.isEmpty || repeatPassword.isEmpty) {
      throw Exception('Please provide a password and repeat it.');
    }

    if (password != repeatPassword) {
      throw Exception('Passwords do not match.');
    }

    for (var profile in _profileData.profiles) {
      if ((profile.email == email && email.isNotEmpty) ||
          (profile.phone == phone && phone.isNotEmpty) ||
          profile.username == username) {
        throw Exception('Email, username, or phone number is taken.');
      }
    }

    addProfile(Profile(
      id: _profileData.profiles.length + 1,
      username: "@$username",
      displayName: displayName,
      email: email,
      phone: phone,
      password: password,
    ));

    return true;
  }
}
