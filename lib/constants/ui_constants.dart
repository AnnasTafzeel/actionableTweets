//import 'package:actionable_tweets/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'assetsconstants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      //title: const Text('Centered Image'),
      // flexibleSpace: Center(
      //   child: Padding(
      //     padding: const EdgeInsets.all(8.0),
      //     child: Image.asset(
      //       'assets/round.png', // Replace with the actual image path
      //       width: 30.0,
      //       height: 30.0,
      //     ),
      //   ),
      // ),
      //centerTitle: true,
      title: SvgPicture.asset(
        AssetsConstants.dm,
        // ignore: deprecated_member_use
        //color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }
}
