import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/auth.dart';
import '../../widgets/device_item_card.dart';
import '../../providers/rooms.dart';
import '../../providers/devices.dart';
import '../../widgets/form_submit_button.dart';
import '../../containts.dart';

class CreateDeviceComponentScreen extends StatefulWidget {
  static const routeName = 'device/component/create';

  @override
  _CreateDeviceComponentScreenState createState() =>
      _CreateDeviceComponentScreenState();
}

class _CreateDeviceComponentScreenState
    extends State<CreateDeviceComponentScreen> {
  @override
  void initState() {
    super.initState();
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
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${deviceComponent.name}"),
            Text("${deviceComponent.description}"),
            Text("${deviceComponent.type}"),
            Text("${deviceComponent.isFavorite}"),
            Text("${deviceComponent.isInput}"),
            Text("${deviceComponent.isActive}"),
          ],
        ),),
    );
  }
}
