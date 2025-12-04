import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {

  static void fieldFocusChange(BuildContext context, FocusNode currentNode, FocusNode nextFocus){
    currentNode.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  static toastMessage(String msg,Color bgColor, Color txtColor){
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: bgColor,
      textColor: txtColor,
      webPosition: "center",
      webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
    );
  }

  static void flushbarMessage(BuildContext context, String? message, Color color, Color txtColor){
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          message: message,
          backgroundColor: Colors.red,
          titleColor: Colors.blue,
        )..show(context),
    );
  }
  
  static snackBar(String message, BuildContext context){
     return ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(message),
           backgroundColor: Colors.red,
           showCloseIcon: true,
           closeIconColor: Colors.white,
         ),
     );
  }
}