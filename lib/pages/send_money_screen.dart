import 'package:borrow/components/borrow_separator.dart';
import 'package:borrow/pages/payment_status_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

class SendMoneyScreen extends StatefulWidget {
  SendMoneyScreen({super.key, required this.capital});
  final double capital;

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fromController.text = "Sheikh umaid";
  }

  void _onToFieldChanged(String value) {
    if (value.isNotEmpty) {
      Provider.of<TransactionProvider>(context, listen: false).fetchUser(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<TransactionProvider>(context);
    final user = userProvider.user;
    _fromController.text = "user";
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pay ₹${widget.capital}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "From: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(controller: _fromController),
                    ),
                    Text("@BRR"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "To: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _toController,
                        onChanged: _onToFieldChanged, // Calls fetchUser()
                      ),
                    ),
                    Text("@BRR"),
                  ],
                ),
              ),
              BorrowSeparator(title: "Selected Payee"),
              if (user != null) ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: 80,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          child: Image.network(
                            "http://10.0.2.2:8000/${user['image']}",
                            // " ",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text("Balance: ₹${user['balance']}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SlideAction(
              enabled: user != null,
              text: "Swipe to pay",
              // animationDuration: Duration(seconds: 5),
              onSubmit: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Enter Transaction Pin"),
                      content: PinCodeTextField(
                        obscureText: true,
                        cursorColor: Colors.purple,
                        keyboardType: TextInputType.number,

                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.circle,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 20,
                          fieldWidth: 20,
                          activeFillColor: Colors.white,
                          activeColor: Colors.purple,
                          selectedColor: Colors.purple,
                          inactiveColor: Colors.grey,
                        ),
                        appContext: context,
                        length: 6,
                        onCompleted: (value) {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return PaymentStatusScreen(
                                  rId: user!["id"],
                                  capital: widget.capital,
                                  appPin: value,
                                );
                              },
                            ),
                          );
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
