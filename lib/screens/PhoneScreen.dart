import 'dart:ui';
import 'package:doctro/screens/video_Call.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PhoneScreen extends StatefulWidget {
  Map<String, dynamic>? additionalData;

  PhoneScreen(this.additionalData);

  @override
  _PhoneScreenState createState() => _PhoneScreenState(additionalData);
}

class _PhoneScreenState extends State<PhoneScreen> {
  Map<String, dynamic>? additionalData;

  _PhoneScreenState(this.additionalData);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.2),
            child: Text(
              "${additionalData!['name']}",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Container(
            color: Colors.transparent,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoCall(
                              callEnd: true,
                              userId: additionalData!["id"],
                            ),),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icons/Cut.svg',
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              VideoCall(
                                callEnd: false,
                                userId: additionalData!["id"],
                              )),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icons/Call.svg',
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
