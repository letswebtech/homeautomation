import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/rooms.dart';
import '../screens/room/create.dart';
import '../providers/auth.dart';
import '../screens/device/create.dart';

import '../containts.dart';
import '../widgets/action_button_card.dart';
import '../widgets/device_item_card.dart';
import '../providers/devices.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/home';

  final _controller = TextEditingController();

  Future<void> _refreshDevices(BuildContext context) async {
    final userProfile = Provider.of<Auth>(context, listen: false).userProfile;
    await Provider.of<Devices>(context, listen: false).fetchAndSetDevices();
  }

  Future<void> _refreshDeviceComponents(BuildContext context) async {
    await Provider.of<Devices>(context, listen: false).fetchAndSetComponents();
  }

  Future<void> _refreshRooms(BuildContext context) async {
    await Provider.of<Rooms>(context, listen: false).fetchAndSetRooms();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(kCardColor, BlendMode.darken),
            image: AssetImage('assets/images/stairs.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ActionButtonCard(
              title: "HOME",
            ),
            Container(
              width: double.infinity,
              height: queryData.size.height - 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Appliances", style: kHeadingLableTextStyle),
                  Expanded(
                    flex: 2,
                    child: FutureBuilder(
                      future: _refreshDeviceComponents(context),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : RefreshIndicator(
                                  color: Colors.white,
                                  backgroundColor: Colors.white,
                                  onRefresh: () =>
                                      _refreshDeviceComponents(context),
                                  child: Consumer<Devices>(
                                    builder: (ctx, devicesData, _) {
                                      return GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            devicesData.deviceComponents.length,
                                        itemBuilder: (_, int index) {
                                          return DeviceItemCard(
                                            key: Key(devicesData
                                                .deviceComponents[index].name
                                                .toString()),
                                            icon: FontAwesomeIcons.hdd,
                                            roomName: devicesData
                                                .deviceComponents[index].name
                                                .toString(),
                                            statusMessage: "off",
                                            isActive: false,
                                            onTap: () async {},
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ),
                  Text("Rooms", style: kHeadingLableTextStyle),
                  Expanded(
                    child: FutureBuilder(
                      future: _refreshRooms(context),
                      builder: (ctx, snapshot) => snapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : RefreshIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.white,
                              onRefresh: () => _refreshRooms(context),
                              child: Consumer<Rooms>(
                                builder: (ctx, roomsData, _) {
                                  return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: roomsData.rooms.length,
                                    itemBuilder: (_, int index) {
                                      return DeviceItemCard(
                                        imageIcon:
                                            roomsData.rooms[index].imageIcon,
                                        icon: roomsData.rooms[index].icon,
                                        roomName: roomsData.rooms[index].name
                                            .toString(),
                                        statusMessage: "off",
                                        isActive: false,
                                        onTap: () async {
                                         },
                                        onLongPress: () async {
                                          Navigator.of(context).pushNamed(
                                              CreateRoomScreen.routeName,
                                              arguments:
                                                  roomsData.rooms[index].id);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                  Text("Devices", style: kHeadingLableTextStyle),
                  Expanded(
                    child: FutureBuilder(
                      future: _refreshDevices(context),
                      builder: (ctx, snapshot) => snapshot.connectionState ==
                              ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : RefreshIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.white,
                              onRefresh: () => _refreshDevices(context),
                              child: Consumer<Devices>(
                                builder: (ctx, devicesData, _) {
                                  return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: devicesData.devices.length,
                                    itemBuilder: (_, int index) {
                                      return DeviceItemCard(
                                        key: Key(devicesData.devices[index].id
                                            .toString()),
                                        icon: FontAwesomeIcons.hdd,
                                        roomName: devicesData
                                            .devices[index].name
                                            .toString(),
                                        statusMessage: "off",
                                        isActive: false,
                                        onTap: () async {},
                                        onLongPress: () async {
                                          Navigator.of(context).pushNamed(
                                            CreateDeviceScreen.routeName,
                                            arguments:
                                                devicesData.devices[index].id,
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
