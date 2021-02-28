import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartHome/widgets/form_submit_button.dart';
import '../../providers/auth.dart';

import '../../widgets/pageview_idicator.dart';

import './one_screen.dart';
import './two_screen.dart';
import './three_screen.dart';
import './four_screen.dart';

class GettingStarted extends StatefulWidget {
  @override
  _GettingStartedState createState() => _GettingStartedState();
}

class _GettingStartedState extends State<GettingStarted> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 4) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if(_pageController.hasClients) {
        _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 550),
        curve: Curves.easeInOut,
      );
      }
    });
  }

  _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            children: [
              Container(
                height: queryData.size.height - 200,
                width: double.infinity,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  children: [
                    ScreenOne(),
                    ScreenTwo(),
                    ScreenThree(),
                    ScreenFour(),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormSubmitButton(
                      lable: "Let's get started!",
                      onPress: () async {
                        await Provider.of<Auth>(context, listen: false)
                            .introducedDone;
                      },
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var i = 0; i < 4; i++)
                            PageviewIndicator(_currentPage == i)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
