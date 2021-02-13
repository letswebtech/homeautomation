import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartHome/containts.dart';
import 'dart:convert';
import '../../providers/devices.dart';
import 'package:socket_io_client/socket_io_client.dart';

class CreateDeviceComponentScreen extends StatefulWidget {
  static const routeName = 'device/component/create';

  @override
  _CreateDeviceComponentScreenState createState() =>
      _CreateDeviceComponentScreenState();
}

class _CreateDeviceComponentScreenState
    extends State<CreateDeviceComponentScreen> {
  Socket socket;
  DeviceComponent deviceComponent;
  bool switchStatus = false;
  int countBuild = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void updateDevice(String deviceUID, int gpio, String action) {
    final dataObj = {"deviceUID": deviceUID, "gpio": gpio, "action": action};
    socket.emit("updateDeviceStatusRequest", dataObj);
    socket.on("deviceStatusResponse", (dataArr) {
      final  gpioStatus = jsonDecode(dataArr["gpioStatus"]);
      final gpioIndex = gpioStatus[0]["gpio"].indexOf(gpio);
      if (this.mounted) {
        setState(() {
          if(gpioIndex >= 0){
              switchStatus = gpioStatus[0]["status"][gpioIndex] == 0 ? false : true;
              print(switchStatus);
          }
        });
      }
    });
  }

  void getAndFechDevice(String deviceUID, [int gpio]) {
    final dataObj = {"deviceUID": deviceUID, "gpio": gpio};
    socket.emit("deviceStatusRequest", dataObj);
    socket.on("deviceStatusResponse", (dataArr) {
      final  gpioStatus = jsonDecode(dataArr["gpioStatus"]);
      final gpioIndex = gpioStatus[0]["gpio"].indexOf(gpio);
      if (this.mounted) {
        setState(() {
          if(gpioIndex >= 0){
              switchStatus = gpioStatus[0]["status"][gpioIndex] == 0 ? false : true;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (countBuild == 0) {
      countBuild++;
      deviceComponent = ModalRoute.of(context).settings.arguments;
      final String queryParam = json.encode({
        "deviceUID": [deviceComponent.deviceID],
        "isDevice": false
      });
      socket = io(
        'https://smarthome-socket.herokuapp.com',
        OptionBuilder().setTransports(['websocket']).setQuery(
            {"queryParam": queryParam}).build(),
      );
      socket.connect();
      socket.onDisconnect((_) => print('disconnect'));
      getAndFechDevice(deviceComponent.deviceID, deviceComponent.gpio);
    } else {
      countBuild++;
    }

    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
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
                  updateDevice(
                      deviceComponent.deviceID, deviceComponent.gpio, "toggle");
                },
                splashRadius: 60,
                splashColor: kActiveIconColor,
                color: switchStatus == true ? kActiveIconColor : Colors.white),
          ],
        ),
      ),
    );
  }
}
