import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../keys/firebase_token.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _DBtoken = fbToken;

  DateTime _userTokenExpiryDate = DateTime(1999, 1, 1);
  late String _userId;
  String _token = '';
  Timer _authTimer = Timer(Duration(seconds: 9999), () => {});

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_userTokenExpiryDate != null &&
        _userTokenExpiryDate.isAfter(DateTime.now()) &&
        _token != '') {
      return _token;
    } else
      return '';
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$_DBtoken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _userTokenExpiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _userTokenExpiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }
      final extractedUserData =
          json.decode(prefs.getString('userData').toString())
              as Map<String, dynamic>;
      final expiryDate =
          DateTime.parse(extractedUserData['expiryDate'] as String);
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      } else {
        _token = extractedUserData['token'] as String;
        _userId = extractedUserData['userId'] as String;
        _userTokenExpiryDate = expiryDate;
        notifyListeners();
        _autoLogout();
        return true;
      }
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _userTokenExpiryDate = DateTime(1999, 1, 1);
    _authTimer.cancel();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }

  void _autoLogout() {
    _authTimer.cancel();
    final timeToExpiry =
        _userTokenExpiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
