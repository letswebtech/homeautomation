import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final List<Widget> children;

  DeviceCard({this.children});

  @override
  Widget build(BuildContext context) {
     return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }
}
