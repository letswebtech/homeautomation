import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/room/create.dart';

import '../containts.dart';
import '../widgets/action_button_card.dart';
import '../widgets/device_item_card.dart';
import '../providers/rooms.dart';

class RoomScreen extends StatelessWidget {
  static const routeName = '/rooms';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ActionButtonCard(
              title: "ROOM",
              onPressAdd: () {
                Navigator.of(context).pushNamed(CreateRoomScreen.routeName);
              },
            ),
            Container(
              height: queryData.size.width - 20,
              child: Expanded(
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
                                        crossAxisCount: 3),
                                scrollDirection: Axis.horizontal,
                                itemCount: roomsData.rooms.length,
                                itemBuilder: (_, int index) {
                                  return DeviceItemCard(
                                    imageIcon: roomsData.rooms[index].imageIcon,
                                    icon: roomsData.rooms[index].icon,
                                    roomName:
                                        roomsData.rooms[index].name.toString(),
                                    statusMessage: "off",
                                    isActive: roomsData.rooms[index].isActive,
                                    onTap: () async {
                                      await roomsData.toggleActiveStatus(
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
            ),
          ],
        ),
      ),
    );
  }
}
