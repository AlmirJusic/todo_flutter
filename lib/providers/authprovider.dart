import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/http_exception.dart';

class AuthProvider with ChangeNotifier {
  /* 
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │   Properties                                                                │
  └─────────────────────────────────────────────────────────────────────────────┘
 */
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  /* 
  ┌─────────────────────────────────────────────────────────────────────────────┐
  │   Getters                                                                   │
  └─────────────────────────────────────────────────────────────────────────────┘
 */

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  /* 
  ┌─────────────────────────────────────────────────────────────────────────┐
  │ Authenticate                                                            │
  └─────────────────────────────────────────────────────────────────────────┘
 */

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBoLElsbY87i55FCcOM2IWRCQI2ZrhPsh4');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final extractedData = json.decode(response.body);

      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']['message']);
      }

      _token = extractedData['idToken'];
      _userId = extractedData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            extractedData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      print(json.decode(response.body));

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  /* 
  ┌─────────────────────────────────────────────────────────────────────────┐
  │ Try Auto Login                                                          │
  └─────────────────────────────────────────────────────────────────────────┘
 */

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  /* 
  ┌─────────────────────────────────────────────────────────────────────────┐
  │ Logout                                                                  │
  └─────────────────────────────────────────────────────────────────────────┘
 */

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
