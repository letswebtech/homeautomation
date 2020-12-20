import 'package:flutter/material.dart';

class PageviewIndicator extends StatelessWidget {
  bool isActive;
  PageviewIndicator(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 15 : 8,
      width: isActive ? 15 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}