import 'dart:convert';
import 'package:borrow/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String _token = '';

  String get token => _token;
  final storage = FlutterSecureStorage();

  Future<bool> register(String username, String email, String password) async {
    final url = Uri.parse('$apiurl/api/register/');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
        'name': "AppUser",
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      debugPrint(responseData.toString());
      // _token = responseData['access'];
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$apiurl/api/login/');
    debugPrint("XXXXXXXXXXXXXXXXXXXXXXXXXXX final");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );
    debugPrint("XXXXXXXXXXXXXXXXXXXXXXXXXXX done");

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      debugPrint("XXXXXXXXXXXXXXX $responseData");
      // debugPrint(responseData);
      storage.write(key: "access", value: responseData["access"]);
      storage.write(key: "refresh", value: responseData["refresh"]);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> refreshAccessToken() async {
    final refreshToken = await storage.read(key: "refresh");
    if (refreshToken == null) {
      return false;
    }

    final url = Uri.parse('$apiurl/api/refresh/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _token = responseData['access'];
      storage.write(key: "access", value: _token);
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }
}
