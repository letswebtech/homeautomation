import 'package:flutter/material.dart';
import 'package:smartHome/widgets/device_item_card.dart';

class AutomationScreen extends StatelessWidget {
  static const routeName = '/automation';
  @override
  Widget build(BuildContext context) {
    //final userData = Provider.of<Auth>(context, listen: false);
    //final user = userData.userProfile;
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            DeviceItemCard(
              icon: Icons.ac_unit,
              roomName: "aswerd",
              statusMessage: "off",
              isActive: false,
              onTap: () async {
                
              },
            )
          ],
        ),
      ),
    );
  }
}
