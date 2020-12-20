import 'package:flutter/material.dart';

import '../containts.dart';

class HeadingLableCard extends StatelessWidget {
  final String heading;
  final String lable;

  HeadingLableCard({this.heading, this.lable});

  //Sign In
  //Sign in by your ID to user our services and other features

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (heading != null)
          Text(
            heading.toString(),
            style: kHeadingTextStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5,
          ),
        if (lable != null)
          Text(
            lable.toString(),
            style: kHeadingLableTextStyle,
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
