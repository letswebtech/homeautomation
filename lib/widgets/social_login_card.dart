import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import './heading_lable_card.dart';

class SocialLoginCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(FontAwesomeIcons.facebookSquare),
              iconSize: 30,
              onPressed: () async {
                await Provider.of<Auth>(context, listen: false)
                    .signInWithFacebook();
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.google),
              iconSize: 30,
              onPressed: () async {
                await Provider.of<Auth>(context, listen: false)
                    .signInWithGoogle();
                // Navigator.pushNamed(context, HomeScreen.routeName);
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.twitterSquare),
              iconSize: 30,
              onPressed: () {},
            )
          ],
        ),
        HeadingLableCard(
          lable:
              "Or you can sign in with this account. Connect to start with us.",
        ),
      ],
    );
  }
}
