import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/controller/auth_controller.dart';
import 'package:hiv/controller/contact_controller.dart';
import 'package:hiv/screens/auth/sign_in_screen.dart';
import 'package:hiv/screens/home/main_screen.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ContactController contactController = Get.put(ContactController());
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();

    var box = Hive.box('userBox');
    String? email = box.get('email');
    contactController.initializeContacts();
    Future.delayed(const Duration(seconds: 2), () {
      if (email == null || email.isEmpty) {
        Get.offAll(() => const SignInScreen());
      } else {
        Get.offAll(() => MainScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset(height: 130, width: 130, 'assets/images/logo.png'));
  }
}
