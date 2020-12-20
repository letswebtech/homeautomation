import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const kCardColor = Color.fromRGBO(61, 60, 62,.8);


const kHeadingTextStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w900,
);

const kActiveIconColor = Color.fromRGBO(255, 146, 41, 1);

const kHeadingLableTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

const kTextFieldStyle = InputDecoration(
  labelText: 'Field Name',
  labelStyle: TextStyle(color: Colors.white),
  focusedBorder: UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
  ),
);


const List<String> kRoomType = [
  'Bedroom',
  'DrawingRoom',
  'DinningRoom',
  'LivingRoom',
  'Kitchen',
  'Store',
  'Balcony',
  'Corridor',
  'Garage',
  'BathRoom',
  'WashRoom',
  'Others'
];