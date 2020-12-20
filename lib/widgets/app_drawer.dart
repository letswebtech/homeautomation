import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/home_screen.dart';

import '../containts.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context, listen: false);
    final user = userData.userProfile;
    return Drawer(
      child: Container(
        color: kCardColor,
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      user.photoURL.toString(),
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(user.displayName ?? "Smart Home", style: kHeadingTextStyle,),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.tachometerAlt),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pushNamed(context, HomeScreen.routeName);
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.user),
                    title: Text('Profile'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.laptopHouse),
                    title: Text('Rooms'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.hdd),
                    title: Text('Devices'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.robot),
                    title: Text('Automation'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.lightbulb),
                    title: Text('Components'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.cogs),
                    title: Text('Setting'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.bug),
                    title: Text('Report an Issue'),
                    onTap: () {},
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.signOutAlt),
                    title: Text('Logout'),
                    onTap: () {
                      userData.logout();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
