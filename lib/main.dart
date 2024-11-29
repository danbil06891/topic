import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/initial_binding.dart';
import 'package:hiv/models/contact_model.dart';
import 'package:hiv/models/message_model.dart';
import 'package:hiv/screens/splash/splash_screen.dart';
import 'package:hiv/test/test_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  //await Hive.deleteBoxFromDisk('userBox');
  //await Hive.deleteBoxFromDisk('messages');
  //await Hive.deleteBoxFromDisk('contacts');
  await Hive.openBox('userBox');
  Hive.registerAdapter(MessageAdapter());
  Hive.registerAdapter(ContactDetailAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitialBindings(),
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: TopicColor.black,
            ),
            color: TopicColor.black),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: TopicColor.white,
          selectionColor: Colors.blue,
          selectionHandleColor: Colors.blue,
        ),
        useMaterial3: false,
        colorScheme: ColorScheme(
          primary: TopicColor.primary,
          onPrimary: TopicColor.primary,
          secondary: TopicColor.black,
          onSecondary: TopicColor.black,
          surface: TopicColor.lightGrey,
          onSurface: TopicColor.black,
          error: TopicColor.lightOrange,
          onError: TopicColor.lightOrange,
          brightness: Brightness.light,
        ),
      ),
      home: TestScreen(),
    );
  }
}
