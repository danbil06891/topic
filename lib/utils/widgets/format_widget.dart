import 'package:flutter/material.dart';

textDesigner(double fSize, Color clr, {FontWeight fontWeight = FontWeight.normal, double lineSpacing = 0.0,
  String fontFamily = 'BagossStandardTRIAL'}){
  return TextStyle(
    fontSize: fSize,
    color: clr,
    fontWeight: fontWeight,
    height: (lineSpacing != 0.0) ? lineSpacing : null,
    decoration: TextDecoration.none,
    fontFamily: fontFamily,
  );
}

arabicTextDesigner(double fSize, Color clr, String fnt, {fontWeight = 'r'}){
  return TextStyle(
    fontSize: fSize,
    color: clr,
    fontFamily: "Adobe Naskh Medium",
    height: 1.5, // the height between text, default is null
    letterSpacing: 0.0,
    fontWeight: (fontWeight == 'b') ? FontWeight.bold : FontWeight.normal,
  );
}