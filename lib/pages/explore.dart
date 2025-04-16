import 'package:borrow/components/app_bar.dart';
import 'package:borrow/components/explore_tile.dart';
import 'package:flutter/material.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: "Explore", context: context),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExploreTile(
                  height: 180,
                  width: 180,
                  subTitle: "Play & Win",
                  title: "Fires",
                  imagePath: "assets/images/fire.png",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExploreTile(
                  imagePath: "assets/images/gain.png",
                  height: 180,
                  width: 180,
                  subTitle: "Total Winnings",
                  title: "₹12,000",
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExploreTile(
                  subTitle:
                      "Electricity, gas, Mobile & Many More".toUpperCase(),
                  title: "Pay Bills Instantly",
                  height: 180,
                  width: 378,
                  color: Colors.deepPurpleAccent,
                  imagePath: "assets/images/instant.png",
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExploreTile(
                  height: 180,
                  width: 180,
                  subTitle: "Auto Pay",
                  title: "0 Active",
                  color: Colors.blueAccent,
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExploreTile(
                      height: 180 / 2.2,
                      width: 180,
                      subTitle: "Total Winnings",
                      title: "1200",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ExploreTile(
                      height: 180 / 2.2,
                      width: 180,
                      subTitle: "Total Winnings",
                      title: "1200",
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
