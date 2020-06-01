import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:onlineshop/exceptions/http_exception.dart';

class Auth with ChangeNotifier {
  String _token; // expires after 1hr
  DateTime _expiryDate;
  String _userId;

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
    final url = "https://identitytoolkit.googleapis"
        ".com/v1/accounts:$urlSegment?key=AIzaSyB_rZZ5Buh24xw775GSVyoWsFe9xmvuHIw";
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
      print(
        json.decode(response.body),
      );
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
      notifyListeners();
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
  /*
  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB_rZZ5Buh24xw775GSVyoWsFe9xmvuHIw";
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
      print(
        json.decode(response.body),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signIn(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB_rZZ5Buh24xw775GSVyoWsFe9xmvuHIw";
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
      print(
        json.decode(response.body),
      );
    } catch (error) {
      print(error);
      throw error;
    }
  }
  */
}
