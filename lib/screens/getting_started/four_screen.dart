import 'package:flutter/material.dart';
import '../../widgets/heading_lable_card.dart';

import '../../containts.dart';

class ScreenFour extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadingLableCard(
          heading: "Smart Control",
          lable: "You can control all your Smart Home and enjoy Smart life",
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: DemoWidget(),
          ),
        ),
      ],
    );
  }
}

class DemoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            height: 120,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kCardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.blue,
                        size: 35,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Living Room Lamp",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "60 %",
                            style: TextStyle(
                              color: Color.fromRGBO(189, 189, 189, .8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Switch.adaptive(
                        value: true,
                        activeColor: Colors.green,
                        onChanged: (bool isSwitched) {
                          print(isSwitched);
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Slider.adaptive(
                    value: 33,
                    onChanged: (sliderValue) {
                      print(sliderValue);
                    },
                    min: 0,
                    max: 100,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: kCardColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.blue,
                        size: 35,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Living Room Lamp",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "off",
                            style: TextStyle(
                              color: Color.fromRGBO(189, 189, 189, .8),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      Switch.adaptive(
                        value: false,
                        activeColor: Colors.green,
                        onChanged: (bool isSwitched) {
                          print(isSwitched);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
