import 'package:borrow/providers/auth_provider.dart';
import 'package:borrow/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  List<Map<String, String>> settings = [
    {"Action Center": ""},
    {"Borrow Settings": ""},
    {"Pricing": ""},
    {"App Settings": ""},
    {"Help & Support": ""},
    {"About": ""},
  ];
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    // userProvider.fetchUserDetails();
    final userData = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.purpleAccent),
              borderRadius: BorderRadius.all(Radius.circular(140)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: Image.network(
                "https://i0.wp.com/icrtcst24.rvscollege.ac.in/wp-content/uploads/2014/10/speaker-2-v2.jpg?fit=768%2C768&ssl=1",
              ),
            ),
          ),
          Column(
            children: [
              Text(
                userData != null ? "${userData['name']}" : "",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "+91 7006-786-167",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Flexible(
            child: FilledButton(
              style: ButtonStyle(),
              onPressed: () async {
                await storage.deleteAll();
              },
              child: Text("Invite and Earn Upto Rs600"),
            ),
          ),
          Flexible(
            child: FilledButton(
              style: ButtonStyle(),
              onPressed: () async {
                await authProvider.refreshAccessToken();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Refreshed')));
              },
              child: Text("Refresh accesstoken"),
            ),
          ),

          SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: settings.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListTile(
                    leading: Icon(Icons.upcoming),
                    title: Text(settings[index].keys.first),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
