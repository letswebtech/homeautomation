import 'package:flutter/material.dart';
import '../../widgets/heading_lable_card.dart';

class ScreenOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadingLableCard(
          heading: "Smart Home",
          lable: "You can control all your Smart Home and enjoy Smart life",
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Image.asset("assets/images/s1.png",
                alignment: Alignment.topCenter,
                fit: BoxFit.fill,
                height: 250,
                color: Colors.white),
          ),
        ),
      ],
    );
  }
}
