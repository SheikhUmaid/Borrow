import 'dart:convert';
import 'package:borrow/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  final _storage = FlutterSecureStorage();
  Map<String, dynamic>? _user;
  String? _token;

  Map<String, dynamic>? get user => _user;

  Future<void> fetchUserDetails() async {
    debugPrint("XXXXXXXXXXXXXXX fetch Ran");
    _token = await _storage.read(key: "access");
    if (_token == null) return;

    final url = Uri.parse('$apiurl/api/profile/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _user = {
          "id": data['id'],
          "username": data['username'],
          "name": data['name'],
          "email": data['email'],
          "phone": data['phone'],
          "balance": data['balance'],
          "image": "$apiurl${data['image']}",
        };

        notifyListeners();
      } else if (response.statusCode == 401) {
        // Token expired or invalid, logout user
        // logout();
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      print('Error fetching user details: $error');
    }
  }
}
