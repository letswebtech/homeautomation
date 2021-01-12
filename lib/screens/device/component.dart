import 'package:flutter/material.dart';
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
  final String queryParam = json.encode({
    "deviceUID": ["deviceSno1", "deviceSno2"],
    "isDevice": false
  });

  void socketFun() {
    socket = io(
      'https://smarthome-socket.herokuapp.com',
      OptionBuilder()
      .setTransports(['websocket'])
      .setQuery({"queryParam": queryParam})
      .build(),
    );
    socket.connect();

    // <String, dynamic>{
    //   'transports': ['polling'],
    //   'autoConnect': true
    // }
    // socket.onConnect((_) {
    //   print('connect');
    //   socket.emit('msg', 'test');
    // });

    socket.emit('connection', "Hello World");
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void toggleOne() {
    print("Toggle One");
    final dataObj = {"deviceUID": "deviceSno1", "gpio": 4};
    socket.emit("updateDevice", dataObj);
  }

  void toggleTwo() {
    print("Toggle Two");
    final dataObj = {"deviceUID": "deviceSno2", "gpio": 4};
    socket.emit("updateDevice", dataObj);
  }

  @override
  Widget build(BuildContext context) {
    socketFun();
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
            FlatButton(onPressed: toggleOne, child: Text("Toggel 1")),
            FlatButton(onPressed: toggleTwo, child: Text("Toggel 1")),
            Text("${deviceComponent.name}"),
            Text("${deviceComponent.description}"),
            Text("${deviceComponent.type}"),
            Text("${deviceComponent.isFavorite}"),
            Text("${deviceComponent.isInput}"),
            Text("${deviceComponent.isActive}"),
          ],
        ),
      ),
    );
  }
}
