import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshop/exceptions/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token; // expires after 1hr
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  //to check whether user had login or not
  //if it returns null value then users need to sign in otherwise not
  bool get isAuth {
    return _token != null; //it means user had login
  }

  //to return token value first of it will check the user login expiry time,
  // if user login expiry time is not ended with current time then it will
  // return token value otherwise it will return null
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyB_rZZ5Buh24xw775GSVyoWsFe9xmvuHIw";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "email": email.trim(),
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      /* print(
        json.decode(response.body),
      );   */
      //to check error
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(
          responseData['error']['message'],
        );
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      //use of share preference
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  //to logout the session of current users which clears login expiry date, token
  // and users id
  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    //clear login data   #use of share preference
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  //auto logout
  //it checks its login expiry date and time with current date and time
  //if it matches or expires then it will auto logout
  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    //if share preference have data then
    final extractedData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _expiryDate = expiryDate;
    _userId = extractedData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }
}
