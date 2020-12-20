import 'dart:convert';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  final _auth = FirebaseAuth.instance;

  String _userId;
  User _user;
  GoogleAuthCredential credential;

  bool get isAuth {
    if (_auth.currentUser == null) {
      return false;
    }

    _user = _auth.currentUser;
    _userId = _user.uid;

    return true;
  }

  Future<void> get introducedDone async {
    final prefs = await SharedPreferences.getInstance();
    final userAppSetting = json.encode({
      'isIntroduced': true,
    });
    prefs.setString('userAppSetting', userAppSetting);
    notifyListeners();
  }

  Future<bool> get isIntroduced async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userAppSetting')) {
      return false;
    }

    final userAppSetting =
        json.decode(prefs.getString('userAppSetting')) as Map<String, Object>;
    
    return userAppSetting['isIntroduced'];
  }

  String get userId {
    return _userId;
  }

  User get userProfile {
    return _user;
  }

  Future<void> _authenticate(
      String email, String password, String condition) async {
    try {
      var response;
      if (condition == "signUp") {
        response = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } else if (condition == "signIn") {
        response = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else if (condition == "googleLogin") {
        response = await _auth.signInWithCredential(credential);
      }

      if (response == null) {
        throw HttpException('Request Failed!');
      }

      _user = _auth.currentUser;
      _userId = _user.uid;

      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'userId': _userId,
      });
      prefs.setString('userData', userData);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signIn');
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _userId = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
    //prefs.clear();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _userId = extractedUserData['userId'];

    //TODO : Attemp Auth using token

    _autoLogout();
    notifyListeners();
    return true;
  }

  void _autoLogout() {
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        //logout();
      }
    });
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    this.credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _authenticate(null, null, "googleLogin");
  }
}
