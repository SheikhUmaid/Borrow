import 'package:flutter/material.dart';

class BorrowButton extends StatelessWidget {
  const BorrowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Center(child: Text("Borrow", style: TextStyle(fontSize: 24))),
        ),
      ),
    );
  }
}
