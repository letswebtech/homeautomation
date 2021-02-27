import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import './automation_screen.dart';
import './room_screen.dart';
import '../containts.dart';
import '../widgets/app_drawer.dart';
import './user_screen.dart';
import './welcome_screen.dart';
import './device_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  final List<Widget> _pages = [
    RoomScreen(),
    DeviceScreen(),
    WelcomeScreen(),
    AutomationScreen(),
    UserScreen(),
  ];

  final List<String> _pageTitles = [
    'ROOMS',
    'DEVICE',
    'HOME',
    'AUTOMATION',
    'USER'
  ];

  int _selectedPageIndex = 2;
  int _buildCount = 1;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_buildCount == 1){
      _buildCount++;
      final modalData = ModalRoute.of(context).settings.arguments;
      if(modalData != null){
       _selectedPageIndex = modalData; 
      }
    }
    
    final userData = Provider.of<Auth>(context, listen: false);
    final user = userData.userProfile;
    return Scaffold(
      drawer: AppDrawer(),
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        unselectedItemColor: Colors.white,
        selectedItemColor: kActiveIconColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.laptopHouse), label: 'Rooms'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.microchip), label: 'Devices'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.robot), label: 'Automation'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user), label: 'User'),
        ],
      ),
    );
  }
}
