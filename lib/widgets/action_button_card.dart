import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../containts.dart';

class ActionButtonCard extends StatelessWidget {
  final String title;
  final Function onPressEdit;
  final Function onPressAdd;
  final timestamp = new DateFormat.MMMEd().format(new DateTime.now());

  ActionButtonCard({@required this.title, this.onPressEdit, this.onPressAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          color: kActiveIconColor,
            icon: Icon(Icons.menu, size: 36),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            }),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$timestamp", style: kHeadingLableTextStyle),
              Text("$title", style: kHeadingTextStyle),
            ],
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              if(onPressEdit != null)
                RawMaterialButton(
                  onPressed: onPressEdit,
                  elevation: 2.0,
                  fillColor: kCardColor,
                  child: Text('Edit', style: kHeadingLableTextStyle),
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
              if(onPressAdd != null)  
                RawMaterialButton(
                  splashColor: kActiveIconColor,
                  constraints: BoxConstraints(maxWidth: 60),
                  onPressed: onPressAdd,
                  elevation: 2.0,
                  fillColor: kCardColor,
                  child: Text('+', style: kHeadingLableTextStyle),
                  padding: EdgeInsets.all(15.0),
                  shape: CircleBorder(),
                ),
            ],
          ),
        )
      ],
    );
  }
}
