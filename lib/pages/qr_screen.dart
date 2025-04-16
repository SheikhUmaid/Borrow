import 'package:borrow/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // userProvider.fetchUserDetails();
    final userData = userProvider.user;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("My QR code", style: TextStyle(fontSize: 30)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close_rounded, weight: 2.5),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 25,
              width: 200,
              decoration: BoxDecoration(
                color: Color.fromARGB(20, 0, 0, 0),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code),
                  Text("BID: ${userData!["username"]}@Brr", style: TextStyle()),
                  Text(">", style: TextStyle()),
                ],
              ),
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: QrImageView(
                data: '${userData["username"]}@Brr',
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            OutlinedButton(
              onPressed: () {},
              child: Text(
                "Share QR",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Account Holder", style: TextStyle(color: Colors.grey)),
                  Row(children: [Text("${userData["name"]}")]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Borrow ID", style: TextStyle(color: Colors.grey)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${userData["username"]}@BRR"),
                      Icon(Icons.copy),
                    ],
                  ),
                ],
              ),
            ),
            Text("Powered By Children's Bank of India"),
          ],
        ),
      ),
    );
  }
}
