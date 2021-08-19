import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaticFunctions {
  static showError(message) {
    return Get.snackbar('HATA!', message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.error),
        snackStyle: SnackStyle.GROUNDED,
        backgroundColor: Colors.red[700],
        colorText: Colors.white,
        margin: EdgeInsets.all(30));
  }

  static showInformation(message) {
    return Get.snackbar('BİLGİ!', message.toString(),
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.info),
        snackStyle: SnackStyle.GROUNDED,
        backgroundColor: Colors.green[700],
        colorText: Colors.white,
        margin: EdgeInsets.all(30));
  }
}
