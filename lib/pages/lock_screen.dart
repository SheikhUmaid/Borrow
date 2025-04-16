import 'package:borrow/main.dart';
import 'package:borrow/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class LockScreen extends StatefulWidget {
  LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  bool _wrongPin = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchUserDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // userProvider.fetchUserDetails();
    final userData = userProvider.user;
    debugPrint("XXXXXXXXXXXXXXXXXXXXXXXXXX $userData");
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20),
              child: Text(
                userData != null ? "Hi ${userData['name']}" : "Hi User",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Sh******@BRR",
                style: TextStyle(color: Colors.grey, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Not you!",
                  style: TextStyle(color: Colors.purple, fontSize: 20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: PinCodeTextField(
                obscureText: true,
                cursorColor: Colors.purple,
                keyboardType: TextInputType.number,

                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.circle,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  activeColor: Colors.purple,
                  selectedColor: Colors.purple,
                  inactiveColor: Colors.grey,
                ),
                appContext: context,
                length: 6,
                onCompleted: (value) {
                  if (value == "314159") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (d) => HomeScreen()),
                    );
                  } else {
                    setState(() {
                      _wrongPin = true;
                    });
                  }
                },
                onChanged: (_) {
                  setState(() {
                    _wrongPin = false;
                  });
                },
              ),
            ),
            Visibility(
              visible: _wrongPin,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Wrong pin!",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Forgotten your Borrow Pin?",
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
