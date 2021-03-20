import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../screens/device/component.dart';
import '../providers/rooms.dart';
import '../screens/room/create.dart';
import '../providers/auth.dart';
import '../screens/device/create.dart';

import '../containts.dart';
import '../widgets/action_button_card.dart';
import '../widgets/device_item_card.dart';
import '../providers/devices.dart';
import 'room/componentList.dart';
import 'package:socket_io_client/socket_io_client.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/home';

  final _controller = TextEditingController();
  Socket socket;

  Future<void> _refreshDevices(BuildContext context) async {
    final userProfile = Provider.of<Auth>(context, listen: false).userProfile;
    await Provider.of<Rooms>(context, listen: false).fetchAndSetRooms();
    final devicesData = Provider.of<Devices>(context, listen: false);
    await devicesData.fetchAndSetDevices();
    await devicesData.fetchAndSetComponents();
    
    final devices = devicesData.devices;
    final deviceIDs = devices.map((device) => device.id).toList();
    final String queryParam =
        json.encode({"deviceUID": deviceIDs, "isDevice": false});
    socket = io(
      'https://smarthome-socket.herokuapp.com',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {"queryParam": queryParam}).build(),
    );
    socket.connect();
    socket.onDisconnect((_) => print('disconnect'));

    // request all device status
    deviceIDs.forEach((deviceUID) {
      final dataObj = {"deviceUID": deviceUID, "gpio": 0};
      socket.emit("deviceStatusRequest", dataObj);
    });

    socket.on("deviceStatusResponse", (dataArr) {
      devicesData.liveDeviceStatus(dataArr);
    });
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
                  Text("Appliances", style: kHeadingTextStyle2),
                  Expanded(
                    flex: 2,
                    child: FutureBuilder(
                      future: _refreshDevices(context),
                      builder: (ctx, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
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
                                                crossAxisCount: 2),
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            devicesData.deviceComponents.length,
                                        itemBuilder: (_, int index) {
                                          return DeviceItemCard(
                                            icon: kApplianceList[devicesData
                                                .deviceComponents[index].type
                                                .toString()]["icon"],
                                            roomName: devicesData
                                                .deviceComponents[index].name
                                                .toString(),
                                            status: devicesData
                                                .deviceComponents[index].status,
                                            isActive: false,
                                            onTap: () async {
                                              Navigator.of(context).pushNamed(
                                                  CreateDeviceComponentScreen
                                                      .routeName,
                                                  arguments: devicesData
                                                      .deviceComponents[index]);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                    ),
                  ),
                  Text("Rooms", style: kHeadingTextStyle2),
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
                                        isActive: false,
                                        onTap: () async {
                                          Navigator.of(context).pushNamed(
                                              ComponentListScreen.routeName,
                                              arguments: {
                                                "id": roomsData.rooms[index].id,
                                                "type": "room"
                                              });
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
                  Text("Devices", style: kHeadingTextStyle2),
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
                                        status:
                                            devicesData.devices[index].status,
                                        isActive: false,
                                        onTap: () async {
                                          Navigator.of(context).pushNamed(
                                            ComponentListScreen.routeName,
                                            arguments: {
                                              "id":
                                                  devicesData.devices[index].id,
                                              "type": "device"
                                            },
                                          );
                                        },
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
