import 'package:flutter/material.dart';
import 'package:hiv/constact/color_constant.dart';


horizontalGap(double size) {
  return SizedBox(
    width: size,
  );
}

verticalGap(double size) {
  return SizedBox(
    height: size,
  );
}

dividerVertical(double width,
    {double topPadding = 8.0, Color color = const Color(0xFF000000)}) {
  return Padding(
    padding: EdgeInsets.only(top: topPadding, bottom: 8.0),
    child: Divider(
      thickness: width,
      color: color,
    ),
  );
}

dividerHorizontal(double size) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    child: Divider(
      thickness: size,
      color: TopicColor.black,
    ),
  );
}



