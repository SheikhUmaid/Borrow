import 'package:borrow/components/app_bar.dart';
import 'package:borrow/components/numpad.dart';
import 'package:borrow/pages/qr_screen.dart';
import 'package:borrow/pages/send_money_screen.dart';
import 'package:borrow/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _rs = "0";
  // _rshandler() {}
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // userProvider.fetchUserDetails();
    final userData = userProvider.user;
    return Scaffold(
      appBar: myAppBar(title: "Payment", context: context),
      backgroundColor: const Color(0xFFE040FB),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "₹$_rs",
                  style: TextStyle(
                    fontSize: 84,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QrScreen()),
                  );
                },
                child: Container(
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
                      Icon(Icons.qr_code, color: Colors.white),
                      Text(
                        "BID: ${userData!['username']}@Brr",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(">", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(),
          SizedBox(),
          // SizedBox(),
          Numpad(
            handler: (value) {
              debugPrint(value);
              setState(() {
                if (value == "<") {
                  if (_rs.isNotEmpty) {
                    _rs = _rs.substring(0, _rs.length - 1);
                  }
                  if (_rs.isEmpty || _rs == ".") {
                    _rs = "0";
                  }
                } else if (value == ".") {
                  if (!_rs.contains(".")) {
                    _rs += value;
                  }
                } else {
                  if (_rs.contains(".")) {
                    // Limit to 2 digits after decimal
                    List<String> parts = _rs.split(".");
                    if (parts.length > 1 && parts[1].length >= 2) {
                      return;
                    }
                  }

                  double newValue = double.tryParse(_rs + value) ?? 0;
                  if (newValue <= 500000) {
                    _rs = (_rs == "0") ? value : _rs + value;
                  }
                }
              });
            },
          ),

          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(onPressed: () {}, child: Text("Request")),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (!(double.parse(_rs) == 0.0)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    SendMoneyScreen(capital: double.parse(_rs)),
                          ),
                        );
                      }
                    },
                    child: Text("Pay"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(),
        ],
      ),
    );
  }
}
