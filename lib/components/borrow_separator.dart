import 'package:flutter/material.dart';

class BorrowSeparator extends StatelessWidget {
  const BorrowSeparator({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: double.infinity,
      color: const Color.fromARGB(255, 233, 230, 230),
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(title.toUpperCase())],
        ),
      ),
    );
  }
}
