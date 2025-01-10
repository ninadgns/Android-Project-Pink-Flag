import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  String? _userId;
  User? _user;
  String? get userId => _userId;
  User? get user => _user;

  Future<void> fetchCurrentUser() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _userId = currentUser.uid;
    } else {
      _userId = null;
    }

    notifyListeners();
  }
}
