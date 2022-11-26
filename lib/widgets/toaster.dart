import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toaster {
  static Future<void> info(
    String message, {
    int? time,
    ToastGravity? gravity,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: time ?? 1,
      backgroundColor: Colors.lightBlueAccent,
      textColor: Colors.white,
    );
  }

  static Future<void> success(
    String message, {
    int? time,
    ToastGravity? gravity,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: time ?? 1,
      backgroundColor: Colors.lightGreenAccent,
      textColor: Colors.white,
    );
  }

  static Future<void> error(
    String message, {
    int? time,
    ToastGravity? gravity,
  }) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: time ?? 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }
}
