import 'package:flutter/material.dart';

class DeviceScreen extends StatelessWidget {
  static const routeName = '/devices';
  @override
  Widget build(BuildContext context) {
    //final userData = Provider.of<Auth>(context, listen: false);
    //final user = userData.userProfile;
    return SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              Text('DEVICES SCREEN'),
              Text('HELLO WORLD'),
              Text('HELLO WORLD'),
              Text('HELLO WORLD'),
            ],
          ),
        ),
      );
  }
}
