import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/controller/auth_controller.dart';
import 'package:hiv/controller/message_controller.dart';

class TestScreen extends StatelessWidget {
  TestScreen({super.key});

  final AuthController authController = Get.put(AuthController());
  final MessageController messageController = Get.put(MessageController());

  // Function to add test users
  Future<void> _addTestUsers() async {
    try {
      await authController.addUsersBatch();
      print('Test users added successfully!');
    } catch (e) {
      print('Error adding test users: $e');
    }
  }

  // Function to send messages to the test user
  void onButtonPressed() {
    const testUserId =
        "JXRtFzrZdYdftl5yn9ecLlgJbAo2"; // Replace with test user's UID
    const messageContent = "Hello from all users!";
    messageController.sendMessagesFromAllUsersToTestUser(
      testUserId,
      messageContent,
      'Test User',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test User Message Sender'),
      ),
      body: Center(
        child: Obx(() => authController.isLoading.value
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _addTestUsers,
                    child: const Text('Add Test Users'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: onButtonPressed,
                    child: const Text(
                      'Send Messages to Test User',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              )),
      ),
    );
  }
}
