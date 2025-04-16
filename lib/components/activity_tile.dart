import 'package:flutter/material.dart';

class ActivityTile extends StatelessWidget {
  final String name;
  final String timestamp;
  final double amount;
  final bool direction;
  const ActivityTile({
    super.key,
    required this.name,
    required this.timestamp,
    required this.amount,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      height: 84,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                child: Image.network(
                  "https://i0.wp.com/icrtcst24.rvscollege.ac.in/wp-content/uploads/2014/10/speaker-2-v2.jpg?fit=768%2C768&ssl=1",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(timestamp),
                  ],
                ),
              ),
              // SizedBox(width: 200),
            ],
          ),
          Row(
            children: [
              Icon(
                direction ? Icons.arrow_downward : Icons.arrow_upward,
                color: direction ? Colors.green : Colors.redAccent,
              ),
              Text(
                amount.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
