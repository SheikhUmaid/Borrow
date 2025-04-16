import 'dart:developer';

import 'package:borrow/constants.dart';
import 'package:borrow/models/transactions_model.dart';
import 'package:borrow/networking/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionProvider with ChangeNotifier {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _sendMoneyResponse;
  Map<String, dynamic>? get user => _user;
  String? _token;
  final _storage = FlutterSecureStorage();
  List<TransactionModel>? _transactions;
  get transactions => _transactions;
  get sendMoneyResponse => _sendMoneyResponse;
  final apiService = ApiService();
  bool isSendTransactionLoading = false;

  Future<void> getTransactions() async {
    try {
      // Fetch token from secure storage
      _token = await _storage.read(key: "access");

      // Ensure token exists before making API call
      if (_token == null) {
        throw Exception("User not authenticated");
      }

      // Make API request with Authorization header
      final response = await apiService.getRequest(
        "/api/transactions/",
        headers: {"Authorization": "Bearer $_token"},
      );

      if (response.statusCode == 200) {
        // Dio already parses JSON, no need for jsonDecode
        final List<dynamic> jsonData = response.data;

        // Convert JSON response into a list of TransactionModel
        _transactions =
            jsonData.map((data) => TransactionModel.fromJson(data)).toList();

        // Notify listeners to update UI
        notifyListeners();
      } else {
        throw Exception("Failed to fetch transactions: ${response.statusCode}");
      }
    } catch (e) {
      isSendTransactionLoading = false;
      debugPrint("Error fetching transactions: $e");
    }
  }

  Future<void> sendMoney({
    required int receiverId,
    required double amount,
    required int appPin,
    String? note = "",
  }) async {
    isSendTransactionLoading = true;
    _sendMoneyResponse = null;
    notifyListeners();
    try {
      _token = await _storage.read(key: "access");
      if (_token == null) {
        throw Exception("User not authenticated");
      }

      final response = await apiService.postRequest(
        '/api/transactions/',
        headers: {'Authorization': "Bearer $_token"},
        data: json.encode({
          "receiver_id": receiverId,
          "amount": amount,
          "app_pin": appPin,
          "note": note,
        }),
      );

      if (response.statusCode == 201) {
        debugPrint("Transaction Successfull");
        _sendMoneyResponse = (response.data);

        debugPrint("Transaction Successfull $_sendMoneyResponse");
        isSendTransactionLoading = false;

        notifyListeners();
        // return true;
      } else {
        debugPrint("Elsed");
        _sendMoneyResponse = (response.data);
        debugPrint("Transaction Failed $_sendMoneyResponse");
        isSendTransactionLoading = false;
        notifyListeners();
        // return false;
      }
    } catch (e) {
      debugPrint("Cacthed");
      isSendTransactionLoading = false;
      // _sendMoneyResponse = {"error": "Transaction failed: ${e.toString()}"};
      notifyListeners();
      debugPrint("Error sending money: $e");
      // return false;
    }
  }

  Future<void> fetchUser(String userId) async {
    var url = Uri.parse("$apiurl/api/profile/username/$userId/");
    _token = await _storage.read(key: "access");

    try {
      debugPrint("Trieda");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      debugPrint("Trieda ${response.body}");
      if (response.statusCode == 200) {
        debugPrint("Got user");
        _user = json.decode(response.body);
      } else {
        _user = null; // Clear if not found
      }
      notifyListeners();
    } catch (error) {
      debugPrint("cathed user");

      print("Error fetching user: $error");
      _user = null;
      notifyListeners();
    }
  }
}
