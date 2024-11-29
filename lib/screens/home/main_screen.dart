import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/controller/auth_controller.dart';
import 'package:hiv/controller/contact_controller.dart';
import 'package:hiv/controller/message_controller.dart';
import 'package:hiv/models/contact_model.dart';
import 'package:hiv/screens/auth/sign_in_screen.dart';
import 'package:hiv/screens/chat/chat_screen.dart';
import 'package:hiv/screens/contact/contact_screen.dart';
import 'package:hiv/screens/contact/widgets/custom_list_tile_widget.dart';
import 'package:hiv/utils/widgets/format_widget.dart';
import 'package:hive/hive.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final MessageController messageController = Get.find();
  final ContactController contactController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    messageController.listenForMessages();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chats',
          style:
              textDesigner(24, TopicColor.white, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                await Hive.deleteBoxFromDisk('userBox');
                await Hive.deleteBoxFromDisk('messages');

                messageController.messages.clear();

                messageController.update();

                messageController.openBox();

                Get.offAll(() => const SignInScreen());
              },
              icon: Icon(
                Icons.logout,
                color: TopicColor.white,
              ))
        ],
      ),
      body: Obx(() {
        final seenConversations = <String>{};
        final filteredContacts = <dynamic>[];
       
        for (var data in messageController.messages) {
          final senderId = data.senderId.trim().toLowerCase();
          final receiverId = data.receiverId.trim().toLowerCase();
          final senderNumber = data.senderPhone.trim().toLowerCase();



          final conversationKey =
              data.senderId == authController.auth.currentUser!.uid
                  ? '$receiverId-$senderId' 
                  : '$senderId-$receiverId'; 

          if (!seenConversations.contains(conversationKey) &&
              data.message.isNotEmpty) {
            seenConversations.add(conversationKey);

            final matchingContact =
                contactController.savePhoneBookContactDetailLocal.firstWhere(
              (contact) => contact.phone?.trim().toLowerCase() == senderNumber,
              orElse: () => ContactDetail(
                uid: '',
                phone: '',
                displayName: '',
                email: null,
              ),
            );

            String displayName = '';
            if (data.senderId == authController.auth.currentUser!.uid) {
              displayName = data.receiverName;
            } else if (matchingContact.phone?.isNotEmpty ?? false) {
              displayName = matchingContact.displayName!;
            } else {
              displayName = data.senderPhone;
            }



            filteredContacts.add({
              'message': data.message,
              'receiverId':
                  data.senderId == authController.auth.currentUser!.uid
                      ? receiverId
                      : senderId,
              'displayName': displayName,
            });
          }
        }

        if (filteredContacts.isEmpty) {
          return const Center(child: Text("No chats available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(15),
          itemCount: filteredContacts.length,
          itemBuilder: (context, index) {
            final contact = filteredContacts[index];

            final displayName = contact['displayName'];
            final message = contact['message'];
            final receiverUid = contact['receiverId'];

            var box = Hive.box('userBox');
            String? senderNumber = box.get('phone');

            return InkWell(
              onTap: () {
                Get.to(() => ChatScreen(
                      senderId: authController.auth.currentUser!.uid,
                      receiverId: receiverUid,
                      receiverName: displayName,
                      senderNumber: senderNumber!,
                    ));
              },
              child: CustomListTileWidget(
                avatar: displayName[0].toUpperCase(),
                displayName: displayName,
                phoneNumber: message,
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          contactController.initializeContacts();
          Get.to(() => const ContactScreen());
        },
        backgroundColor: TopicColor.primary,
        child: Icon(
          Icons.add,
          color: TopicColor.white,
        ),
      ),
    );
  }
}

