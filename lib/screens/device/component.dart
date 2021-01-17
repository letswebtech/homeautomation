import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartHome/containts.dart';
import 'dart:convert';
import '../../providers/devices.dart';
import 'package:socket_io_client/socket_io_client.dart';

final String queryParam = json.encode({
  "deviceUID": ["deviceSno1", "deviceSno2"],
  "isDevice": false
});

class CreateDeviceComponentScreen extends StatefulWidget {
  static const routeName = 'device/component/create';

  @override
  _CreateDeviceComponentScreenState createState() =>
      _CreateDeviceComponentScreenState();
}

class _CreateDeviceComponentScreenState
    extends State<CreateDeviceComponentScreen> {
  Socket socket;
  bool switchStatus = false;
  final String queryParam = json.encode({
    "deviceUID": ["deviceSno1", "deviceSno2"],
    "isDevice": false
  });

  @override
  void initState() {
    print("innnn");
    super.initState();
    socket = io(
      'https://smarthome-socket.herokuapp.com',
      OptionBuilder().setTransports(['websocket']).setQuery(
          {"queryParam": queryParam}).build(),
    );
    socket.connect();
    socket.onDisconnect((_) => print('disconnect'));
    socket.on("updateDevice", (ad){

    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void updateDevice(String deviceUID, int gpio, String action) {
    final dataObj = {"deviceUID": deviceUID, "gpio": gpio, "action": action};
    socket.emit("updateDevice", dataObj);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    final DeviceComponent deviceComponent =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('${deviceComponent.name}'),
      ),
      body: Container(
        width: double.infinity,
        height: queryData.size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.powerOff),
              iconSize: 60,
              onPressed: () {
                setState(() {
                  updateDevice(
                      deviceComponent.deviceID, deviceComponent.gpio, "toggle");
                });
              },
              splashRadius: 60,
              splashColor: kActiveIconColor,
              color: switchStatus == true ? kActiveIconColor : Colors.white
            ),
          ],
        ),
      ),
    );
  }
}
