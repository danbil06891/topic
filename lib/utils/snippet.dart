import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// email validation
bool isValidEmail(String email) {
  final emailRegExp = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegExp.hasMatch(email);
}

final RegExp nameRegex = RegExp(r'^[a-zA-Z]+$');

Future<XFile?> imagePicker({src = ImageSource.camera}) async {
  final ImagePicker picker = ImagePicker();
  return picker.pickImage(source: src, imageQuality: 10);
}

String? Function(String?) get mandatoryValidator =>
    (String? val) => val?.isEmpty ?? true ? "This field is mandatory" : null;

String? Function(String?) get passwordValidator => (String? password) =>
    (password?.length ?? 0) < 8 ? "Password too short" : null;

String? Function(String?) get emailValidator => (String? email) => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(email ?? "")
        ? null
        : "Enter a valid email";

String? Function(String?) get numberValidator =>
    (String? number) => number?.isEmpty ?? true
        ? "This field is mandatory"
        : RegExp(r"^[0-9]*$").hasMatch(number ?? "")
            ? null
            : "Enter a valid number";

String? validatePhoneNumber(String? phoneNumber) {
  // Remove any whitespace or special characters from the phone number
  phoneNumber = phoneNumber?.replaceAll(RegExp(r'\D'), '');

  // Define the regular expression pattern for a valid Pakistani phone number
  RegExp regex = RegExp(r'^(?:\+92|0)?3[0-9]{9}$');

  // Check if the phone number matches the pattern
  if (!regex.hasMatch(phoneNumber ?? '')) {
    return 'Invalid phone number format';
  }

  return null;
}

Widget getLoader() => const Center(child: CircularProgressIndicator());
