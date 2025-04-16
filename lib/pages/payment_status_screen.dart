import 'package:borrow/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PaymentStatusScreen extends StatefulWidget {
  int rId;
  double capital;
  String appPin;
  PaymentStatusScreen({
    super.key,
    required this.rId,
    required this.capital,
    required this.appPin,
  });

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {
  bool loading = false;

  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );
      transactionProvider.sendMoney(
        receiverId: widget.rId,
        amount: widget.capital,
        appPin: int.parse(widget.appPin),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Build called");
    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (
          BuildContext context,
          TransactionProvider provider,
          Widget? child,
        ) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                animate: true,
                provider.isSendTransactionLoading
                    ? "assets/animations/payment_loading.json"
                    : provider.sendMoneyResponse?["message"]?.toString() ==
                        "Transaction successful"
                    ? "assets/animations/payment_done.json"
                    : "assets/animations/payment_failed.json",
              ),
              Text(
                provider.sendMoneyResponse?['message']?.toString() ??
                    provider.sendMoneyResponse?['error']?.toString() ??
                    'Failed...',
              ),
            ],
          );
        },
      ),
      floatingActionButton: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Done"),
      ),
    );
  }
}
