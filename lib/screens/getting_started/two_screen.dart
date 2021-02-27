import 'package:flutter/material.dart';
import '../../widgets/device_card.dart';
import '../../widgets/device_item_card.dart';
import '../../widgets/heading_lable_card.dart';

class ScreenTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadingLableCard(
          heading: "Control Everything",
          lable: "You can control all your Smart Home and enjoy Smart life",
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DeviceCard(
                  children: [
                    DeviceItemCard(
                      icon: Icons.star,
                      roomName: "Living Room Lamp",
                      status: true,
                    ),
                    DeviceItemCard(
                      icon: Icons.storage,
                      roomName: "Living Room Lamp",
                      status: true,
                      isActive: true,
                    ),
                    DeviceItemCard(
                      icon: Icons.notifications,
                      roomName: "Living Room Lamp",
                      status: true,
                    ),
                  ],
                ),
                DeviceCard(
                  children: [
                    DeviceItemCard(
                      icon: Icons.scatter_plot,
                      roomName: "Living Room Lamp",
                      status: true,
                    ),
                    DeviceItemCard(
                      icon: Icons.home,
                      roomName: "Living Room Lamp",
                      status: true,
                    ),
                    DeviceItemCard(
                      icon: Icons.lightbulb_outline,
                      roomName: "Living Room Lamp",
                      status: true,
                    ),
                  ],
                ),
                DeviceCard(
                  children: [
                    DeviceItemCard(
                      icon: Icons.offline_bolt,
                      roomName: "Living Room Lamp",
                      status: true,
                    ),
                    DeviceItemCard(
                      icon: Icons.stairs,
                      roomName: "Stair Light",
                      status: true,
                    ),
                    DeviceItemCard(
                      icon: Icons.kitchen,
                      roomName: "Kitchen",
                      status: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
