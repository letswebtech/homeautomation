import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../widgets/heading_lable_card.dart';

class ScreenThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadingLableCard(
          heading: "User Interface",
          lable: "You can control all your Smart Home and enjoy Smart life",
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: CircularSliderCard(),
          ),
        ),
      ],
    );
  }
}

class CircularSliderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Stack(
        children: [
          Center(
            child: SleekCircularSlider(
              initialValue: 20,
              max: 45,
              appearance: CircularSliderAppearance(
                  infoProperties: InfoProperties(
                    modifier: (_value) {
                      return _value.ceil().toInt().toString();
                    },
                    topLabelText: "\u2103",
                    topLabelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    bottomLabelText: "Cooling",
                    bottomLabelStyle: TextStyle(
                      color: Color.fromRGBO(189, 189, 189, .8),
                      fontSize: 14,
                    ),
                    mainLabelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  angleRange: 360,
                  startAngle: 90,
                  counterClockwise: true,
                  size: MediaQuery.of(context).size.width * 0.70,
                  customColors: CustomSliderColors(
                    hideShadow: true,
                    progressBarColors: [
                      Colors.yellowAccent,
                      Colors.deepOrangeAccent,
                    ],
                    dotColor: Color.fromRGBO(61, 61, 61, 1),
                    trackColor: Color.fromRGBO(61, 61, 61, .5),
                  ),
                  customWidths: CustomSliderWidths(
                      handlerSize: MediaQuery.of(context).size.width * 0.03,
                      trackWidth: MediaQuery.of(context).size.width * 0.07,
                      progressBarWidth:
                          MediaQuery.of(context).size.width * 0.07)),
              onChange: (v) {
                print(v);
              },
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/slider_marking.png',
              width: 190,
            ),
          ),
        ],
      ),
    );
  }
}
