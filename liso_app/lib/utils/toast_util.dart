import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToast {
  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      // webBgColor: "#e74c3c",
      textColor: Colors.black,
      // timeInSecForIosWeb: 5,
    );
  }
}
