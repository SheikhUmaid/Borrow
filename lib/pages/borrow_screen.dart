import 'package:borrow/components/app_bar.dart';
import 'package:borrow/components/borrow_button.dart';
import 'package:borrow/components/borrow_separator.dart';
import 'package:flutter/material.dart';

class BorrowScreen extends StatelessWidget {
  BorrowScreen({super.key});

  final List<String> others = [
    "Autopay",
    "Repayment schedule",
    "Past repayments",
    "Closed borrowings",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Borrow", context: context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Text(
                  "₹100K",
                  style: TextStyle(
                    // color: Colors.black,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80),
                child: Text(
                  "Purchase power ⓘ",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              ),
            ),
            BorrowButton(),
            BorrowSeparator(title: "repayment"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Total Outstanding",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 2, 0, 0),
                        child: Text(
                          "₹12,000",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Repay",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BorrowSeparator(title: "active borrowing"),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  "₹12,000",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Padding(
                padding: const EdgeInsets.all(7.0),
                child: Text(
                  "₹12,000",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "View All",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
            ),
            BorrowSeparator(title: "Other"),
            SizedBox(
              height: 300,
              child: ListView.separated(
                itemCount: others.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Text(others[index]),
                    ),
                  );
                },
                separatorBuilder:
                    (context, index) => Divider(), // Adds a line between items
              ),
            ),
          ],
        ),
      ),
    );
  }
}
