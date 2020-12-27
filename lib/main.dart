import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/device/create.dart';
import './providers/devices.dart';
import './screens/room/create.dart';
import './containts.dart';
import './providers/rooms.dart';
import './screens/home_screen.dart';
import './screens/splash_screen.dart';
import './screens/auth_screen.dart';
import './screens/getting_started/getting_started_screen.dart';
import './providers/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SmartHome());
}

class SmartHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Rooms>(
          create: null,
          update: (ctx, auth, roomProvider) => Rooms(
              auth.userId, roomProvider == null ? [] : roomProvider.rooms),
        ),
        ChangeNotifierProxyProvider<Auth, Devices>(
          create: null,
          update: (ctx, auth, deviceProvider) => Devices(
              auth.userId, deviceProvider == null ? [] : deviceProvider.devices),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
            accentColor: Colors.white,
            canvasColor: kCardColor,
          ),
          home: FutureBuilder<bool>(
              future: auth.isIntroduced,
              builder: (ctx, authResultSnapshot) {
                if (authResultSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return SplashScreen();
                } else {
                  if (authResultSnapshot.data) {
                    return auth.isAuth
                        ? HomeScreen()
                        : FutureBuilder<void>(
                            future: auth.tryAutoLogin(),
                            builder: (ctx, authResultSnapshot) =>
                                authResultSnapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? SplashScreen()
                                    : AuthScreen(),
                          );
                  }
                  return GettingStarted();
                }
              }),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            CreateRoomScreen.routeName: (ctx) => CreateRoomScreen(),
            CreateDeviceScreen.routeName: (ctx) => CreateDeviceScreen(),
          },
        ),
      ),
    );
  }
}
