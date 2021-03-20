import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../screens/device/component.dart';
import '../../providers/devices.dart';
import '../../screens/room/create.dart';

import '../../containts.dart';
import '../../widgets/action_button_card.dart';
import '../../widgets/device_item_card.dart';
import '../../providers/rooms.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ListType { Single, Mutiple }

ListType listType;
Socket socket;

class ComponentListScreen extends StatelessWidget {
  static const routeName = '/rooms/component/list';

  Future<void> _refreshRooms(BuildContext context, _id) async {
    final roomsData = Provider.of<Rooms>(context, listen: false);
    await roomsData.fetchAndSetComponents(_id);
    final devicesData = Provider.of<Devices>(context, listen: false);
    final devices = devicesData.devices;
    final deviceIDs = devices.map((device) => device.id).toList();
    final String queryParam = json.encode({
      "deviceUID": [_id],
      "isDevice": false
    });
    socket = io(
      'https://smarthome-socket.herokuapp.com',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {"queryParam": queryParam}).build(),
    );
    socket.connect();
    socket.onDisconnect((_) => print('disconnect'));
    deviceIDs.forEach((deviceUID) {
      final dataObj = {"deviceUID": deviceUID, "gpio": 0};
      socket.emit("deviceStatusRequest", dataObj);
    });
    socket.on("deviceStatusResponse", (dataArr) {
      roomsData.liveDeviceStatus(dataArr);
    });
  }

  Future<void> _refreshDevices(BuildContext context, _id) async {
    final devicesData = Provider.of<Devices>(context, listen: false);
    final String queryParam = json.encode({
      "deviceUID": [_id],
      "isDevice": false
    });
    await devicesData.fetchAndSetComponents(_id);
    socket = io(
      'https://smarthome-socket.herokuapp.com',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {"queryParam": queryParam}).build(),
    );
    socket.connect();
    socket.onDisconnect((_) => print('disconnect'));
    final dataObj = {"deviceUID": _id, "gpio": 0};
    socket.emit("deviceStatusRequest", dataObj);
    socket.on("deviceStatusResponse", (dataArr) {
      devicesData.liveDeviceStatus(dataArr);
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    listType = args["type"] == "room" ? ListType.Mutiple : ListType.Single;
    Room roomData;
    Device deviceData;
    if (listType == ListType.Mutiple) {
      roomData =
          Provider.of<Rooms>(context, listen: false).findById(args["id"]);
    } else {
      deviceData =
          Provider.of<Devices>(context, listen: false).findById(args["id"]);
    }

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(listType == ListType.Mutiple
            ? "${roomData.name}"
            : "${deviceData.name}"),
      ),
      body: SafeArea(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: queryData.size.width - 20,
                child: FutureBuilder(
                  future: listType == ListType.Mutiple
                      ? _refreshRooms(context, roomData.id)
                      : _refreshDevices(context, deviceData.id),
                  builder: (ctx, snapshot) => snapshot.connectionState ==
                          ConnectionState.waiting
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: Colors.white,
                          onRefresh: () => listType == ListType.Mutiple
                              ? _refreshRooms(context, roomData.id)
                              : _refreshDevices(context, deviceData.id),
                          child: listType == ListType.Mutiple
                              ? Consumer<Rooms>(
                                  builder: (ctx, devicesData, _) {
                                    return GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
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
                                )
                              : Consumer<Devices>(
                                  builder: (ctx, devicesData, _) {
                                    return GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3),
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
            ],
          ),
        ),
      ),
    );
  }
}
