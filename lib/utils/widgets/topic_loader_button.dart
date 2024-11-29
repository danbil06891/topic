
import 'package:flutter/material.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/utils/snippet.dart';


class TopicLoaderButton extends StatefulWidget {
  final String btnText;
  final Color? textColor;
  final double? radius;
  final Color? borderSide;
  final Future<void> Function() onTap;
  final Color? color;
  final double? fontSize;
  final FontWeight? weight;

  const TopicLoaderButton({
    super.key,
    required this.btnText,
    required this.onTap,
    this.color,
    this.textColor,
    this.fontSize,
    this.weight,
    this.radius,
    this.borderSide,
  });

  @override
  State<TopicLoaderButton> createState() => _TopicLoaderButtonState();
}

class _TopicLoaderButtonState extends State<TopicLoaderButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? getLoader()
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.color ?? TopicColor.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.radius ?? 30),
                side:
                    BorderSide(color: widget.borderSide ?? Colors.transparent),
              ),
              minimumSize: Size(MediaQuery.of(context).size.width, 45),
            ),
            onPressed: () async {
              if (mounted) {
                setState(() => loading = true);
              }
              await widget.onTap();
              if (mounted) {
                setState(() => loading = false);
              }
            },
            child: Text(widget.btnText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: widget.textColor ?? Colors.white,
                      fontSize: widget.fontSize ?? 15,
                      letterSpacing: 0.9,
                      fontWeight: widget.weight ?? FontWeight.w500,
                    )),
          );
  }
}
