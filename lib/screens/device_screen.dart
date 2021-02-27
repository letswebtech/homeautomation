import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/device/create.dart';

import '../containts.dart';
import '../widgets/action_button_card.dart';
import '../widgets/device_item_card.dart';
import '../providers/devices.dart';
import '../screens/room/componentList.dart';

class DeviceScreen extends StatelessWidget {
  static const routeName = '/devices';

  final _controller = TextEditingController();

  Future<void> _refreshDevices(BuildContext context) async {
    await Provider.of<Devices>(context, listen: false).fetchAndSetDevices();
  }

  _showAddNoteDialog(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add New Device"),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Serial No.',
                          icon: Icon(FontAwesomeIcons.barcode)),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              FlatButton(
                child: Text("Yes"),
                onPressed: () async {
                  try {
                    await Provider.of<Devices>(context, listen: false)
                        .addAndVerifyDevice(_controller.text);
                    _controller.clear();
                    Navigator.of(context).pop();
                  } catch (error) {
                    //TODO : validate new device
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<Auth>(context, listen: false).userProfile;
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActionButtonCard(
              title: "DEVICE",
              onPressAdd: () {
                if (userProfile.uid == kAdminUID) {
                  Navigator.of(context).pushNamed(CreateDeviceScreen.routeName);
                } else {
                  _showAddNoteDialog(context);
                }
              },
            ),
            Container(
              height: queryData.size.width - 20,
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
                                          crossAxisCount: 3),
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
                                      status: true,
                                      isActive: false,
                                      onTap: () async {
                                        Navigator.of(context).pushNamed(ComponentListScreen.routeName, arguments: {
                                        "id": devicesData.devices[index].id,
                                        "type": "device"
                                      },);
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
    );
  }
}
