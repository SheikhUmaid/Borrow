import 'package:flutter/material.dart';

class ExploreTile extends StatelessWidget {
  const ExploreTile({
    super.key,
    required this.subTitle,
    required this.title,
    required this.height,
    required this.width,
    this.imagePath = " ",
    this.color = Colors.amber,
  });
  final String subTitle;
  final String title;
  final double height;
  final double width;
  final String imagePath;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
        borderRadius: BorderRadius.all(Radius.circular(22)),
        color: color,
      ),
      child: Wrap(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              subTitle,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 0, 0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
