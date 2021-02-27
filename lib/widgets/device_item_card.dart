import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../containts.dart';

class DeviceItemCard extends StatelessWidget {
  final IconData icon;
  final ImageProvider<Object> imageIcon;
  final String roomName;
  bool status;
  bool isActive;
  Function onTap;
  Function onDoubleTap;
  Function onLongPress;
  Key key;

  DeviceItemCard({
    this.key,
    @required this.icon,
    @required this.roomName,
    this.status = null,
    this.isActive = false,
    this.imageIcon,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive ? Colors.white : kCardColor,
            boxShadow: [
              BoxShadow(
                offset: Offset(0.0, .5), //(x,y)
                blurRadius: 1,
              ),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageIcon != null)
              ImageIcon(
                imageIcon,
                color: isActive ? kActiveIconColor : Colors.blue,
                size: isActive ? 50 : 35,
              ),
            if (imageIcon == null)
              Icon(
                icon,
                color: isActive ? kActiveIconColor : Colors.blue,
                size: isActive ? 50 : 35,
              ),
            Text(
              "$roomName",
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontSize: 15,
              ),
            ),
            if(status != null)
              Icon(
                FontAwesomeIcons.solidCircle,
                size: 15,
                color: status ?  Colors.green : kActiveIconColor,
              ),
          ],
        ),
      ),
    );
  }
}
