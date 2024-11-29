import 'package:get/get.dart';
import 'package:hiv/controller/auth_controller.dart';
import 'package:hiv/controller/contact_controller.dart';
import 'package:hiv/controller/message_controller.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MessageController());
    Get.put(AuthController());
    Get.put(ContactController());
  }
}
