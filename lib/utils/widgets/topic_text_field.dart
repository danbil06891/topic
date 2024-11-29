import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiv/constact/color_constant.dart';


// ignore: must_be_immutable
class TopicTextField extends StatefulWidget {
  final bool? readOnly;
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final IconData? suffixIcon2;
  late bool isVisible;
  final String? imagePath;
  final String? Function(String?)? validator;
  final Colors? color;

  final TextInputType? inputType;
  final Color? prefixIconColor;
  final void Function()? onTap;
  final int? maxLine;
  final Color? fillerColor;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChange;

  TopicTextField({
    Key? key,
    this.onTap,
    this.imagePath,
    this.readOnly,
    this.isVisible = false,
    this.hintText = '',
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.color,
    this.fillerColor,
    this.maxLine,
    this.controller,
    this.prefixIconColor,
    this.inputType,
    this.suffixIcon2,
    this.inputFormatters,
    this.onChange,
  }) : super(key: key);

  @override
  State<TopicTextField> createState() => _TopicTextFieldState();
}

class _TopicTextFieldState extends State<TopicTextField> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(color: Colors.white),
      maxLines: widget.maxLine,
      readOnly: widget.readOnly ?? false,
      onTap: widget.onTap,
      controller: widget.controller,
      keyboardType: widget.inputType,
      validator: widget.validator,
      obscureText: widget.isVisible,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChange,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(color: TopicColor.textField),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide(color: TopicColor.textField),
        ),
        isDense: true,
        hintText: widget.hintText,
        
        hintStyle: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(color: TopicColor.lightGrey, fontSize: 14),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: widget.prefixIconColor ?? TopicColor.lightGrey,
              )
            : null,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              widget.isVisible = !widget.isVisible;
            });
          },
          child: Icon(
            widget.isVisible ? widget.suffixIcon2 : widget.suffixIcon,
            color: TopicColor.lightGrey,
            size: 18,
          ),
        ),
        fillColor: widget.fillerColor ?? Colors.transparent,
        filled: true,
      ),
    );
  }
}
