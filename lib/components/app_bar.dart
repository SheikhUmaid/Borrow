import 'package:borrow/pages/settings_screen.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar({
  String title = "AppBar",
  required BuildContext context,
}) {
  // BuildContext context;
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Text(title, style: TextStyle(fontSize: 30)),
    actions: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen()),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Image.network(
              "https://i0.wp.com/icrtcst24.rvscollege.ac.in/wp-content/uploads/2014/10/speaker-2-v2.jpg?fit=768%2C768&ssl=1",
            ),
          ),
        ),
      ),
    ],
  );
}
