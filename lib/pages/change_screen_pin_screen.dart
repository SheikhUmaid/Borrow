import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangeScreenPinScreen extends StatelessWidget {
  ChangeScreenPinScreen({super.key, required this.state});
  int state;
  String checkState() {
    if (state == 0) {
      return "Enter Current Pin";
    } else if (state == 1) {
      return "Enter New Pin";
    } else if (state == 3) {
      return "Confirm New Pin";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Call");
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20),
              child: Text(
                checkState(),
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                      MaterialPageRoute(
                        builder: (d) => ChangeScreenPinScreen(state: 1),
                      ),
                    );
                  } else {}
                },
                onChanged: (_) {},
              ),
            ),
            Visibility(
              visible: true,
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
