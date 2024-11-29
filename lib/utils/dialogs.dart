import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/constact/color_constant.dart';

Future<void> showMessage(title, message,
    {color = TopicColor.lightOrange, position = SnackPosition.BOTTOM, duration = 3}) async {
  Get.snackbar(title, message,
      duration: Duration(seconds: duration),
      colorText: TopicColor.white,
      backgroundColor: color,
      icon: Icon(Icons.info_outline, color: color),
      snackPosition: position,
      margin: const EdgeInsets.all(15));
}

