import 'package:borrow/components/activity_tile.dart';
import 'package:borrow/components/app_bar.dart';
import 'package:borrow/providers/transaction_provider.dart';
import 'package:borrow/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<TransactionProvider>(context, listen: false).getTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.user;
    debugPrint(userData!['username']);
    return Scaffold(
      appBar: myAppBar(title: "Activity", context: context),

      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions == null) {
            return Center(child: Text("No transactions found."));
          }
          if (transactionProvider.transactions.isEmpty) {
            return Center(child: Text("No transactions found."));
          }
          return ListView.builder(
            itemCount: transactionProvider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.transactions[index];
              return ActivityTile(
                name:
                    transaction.sender.toString().toLowerCase() ==
                            userData["username"].toString().toLowerCase()
                        ? transaction.receiver
                        : transaction.sender,
                timestamp: transaction.date.toString(),
                amount: transaction.amount,
                direction: transaction.senderId != userData['id'],
              );
            },
          );
        },
      ),
      // body: ListView.builder(
      //   itemCount: 20,
      //   itemBuilder: (BuildContext context, int index) {
      //     return ActivityTile();
      //   },
      // ),
    );
  }
}
