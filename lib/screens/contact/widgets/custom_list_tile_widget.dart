import 'package:flutter/material.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/utils/widgets/format_widget.dart';
import 'package:hiv/utils/widgets/standart_widget.dart';

class CustomListTileWidget extends StatefulWidget {
  const CustomListTileWidget(
      {super.key, this.avatar, this.displayName, this.phoneNumber});
  final String? avatar;
  final String? displayName;
  final String? phoneNumber;
  @override
  State<CustomListTileWidget> createState() => _CustomListTileWidgetState();
}

class _CustomListTileWidgetState extends State<CustomListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: TopicColor.lightOrange,
            child: Text(
              widget.avatar!,
            ),
          ),
          horizontalGap(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.displayName!,
                style: textDesigner(16, TopicColor.black,
                    fontWeight: FontWeight.w500),
              ),
              verticalGap(4),
              Text(widget.phoneNumber!),
            ],
          ),
          const Spacer()
          // ListTile(
          //   leading: CircleAvatar(
          //     child: Text(displayName[0].toUpperCase()),
          //   ),
          //   title: Text(displayName),
          //   subtitle: Text(phoneNumber),
          // ),
        ],
      ),
    );
  }
}