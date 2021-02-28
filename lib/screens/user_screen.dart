import 'package:flutter/material.dart';

import '../containts.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(kCardColor, BlendMode.darken),
            image: AssetImage('assets/images/commingsoon.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
