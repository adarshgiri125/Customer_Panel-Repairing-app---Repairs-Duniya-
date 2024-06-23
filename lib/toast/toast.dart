import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class ToastService {
  static Future<void> sendAlert({
    required BuildContext context,
    required String message,
    required String toastStatus,
  }) async {
    Color bgColor;
    switch (toastStatus) {
      case 'SUCCESS':
        bgColor = Colors.green;
        break;
      case 'ERROR':
        bgColor = Colors.red;
        break;
      default:
        bgColor = Colors.black;
    }

    await Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
