import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'color_constant.dart';

class CommonFunction{
  //Set Loader SignUp & Sign In
  static onLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(width : 20),
                new Text("Please Wait"),
              ],
            ),
          ),
        );
      },
    );
  }

  static toastMessage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIosWeb: 1,
        backgroundColor: blackOpacity,
        textColor: colorWhite,
        fontSize: 16.0);
  }

  static hideDialog(BuildContext context){
    Navigator.pop(context);
  }

  //Check Internet Connection Data
  static Future<bool> checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    else {
      Fluttertoast.showToast(
        msg: "No Internet Connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }
}