import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const kAdminUID = "r9Yswny1FGZ3jJXXQv7o5CodtGw1";

const kCardColor = Color.fromRGBO(61, 60, 62, .8);

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

const List<String> kAppliance = [
  'bulb',
  'fan',
  'ac',
  'socket',
  'Others'
];

const Map<String, Map<String, dynamic>> kApplianceList = {
  "bulb": {
    "name": "Light Buld",
    "icon": FontAwesomeIcons.lightbulb,
  },
  "fan": {
    "name": "Light Buld",
    "icon": FontAwesomeIcons.fan,
  },
  "socket": {
    "name": "Light Buld",
    "icon": FontAwesomeIcons.plug,
  },
  "ac": {
    "name": "Light Buld",
    "icon": Icons.ac_unit
  },
  "Others": {
    "name": "Others",
    "icon": FontAwesomeIcons.plug
  }
};


const Map<String, Map<String, dynamic>> kSensorList = {
  "motion": {
    "name": "Light Buld",
    "icon": FontAwesomeIcons.cat
  },
  "light": {
    "name": "Light Buld",
    "icon": FontAwesomeIcons.sun,
  },
  "heat": {
    "name": "Light Buld",
    "icon": FontAwesomeIcons.fireAlt,
  }
};