import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/controller/contact_controller.dart';
import 'package:hiv/screens/chat/chat_screen.dart';
import 'package:hiv/screens/contact/widgets/custom_list_tile_widget.dart';
import 'package:hiv/utils/widgets/format_widget.dart';
import 'package:hive/hive.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactController contactController = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Contact',
            style:
                textDesigner(24, TopicColor.white, fontWeight: FontWeight.w400),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: TopicColor.white,
              )),
        ),
        body: contactController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: TopicColor.primary,
                ),
              )
            : Obx(
                () => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Contacts on topic'),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: contactController.filterContactList.length,
                        itemBuilder: (context, index) {
                          var contact = contactController.filterContactList[index];
                          var contactDetails = contact['contact'];
                          var receiverId = contact['uid'];
                          var displayName =
                              contactDetails.structuredName?.displayName ??
                                  'Unknown';
                          var phoneNumber = contactDetails.phones.isNotEmpty
                              ? contactDetails.phones.first.number
                              : 'No number';

                          var box = Hive.box('userBox');
                          String? senderNumber = box.get('phone');

                          return InkWell(
                              onTap: () {
                                Get.to(() => ChatScreen(
                                      senderId: auth.currentUser!.uid,
                                      receiverId: receiverId,
                                      receiverName: displayName,
                                      senderNumber: senderNumber!,
                                    ));
                              },
                              child: CustomListTileWidget(
                                avatar: displayName[0].toUpperCase(),
                                displayName: displayName,
                                phoneNumber: phoneNumber,
                              ));
                        },
                      ),
                      const Divider(),
                      // const Text('Invite to topic'),
                      // ...contactController.phoneContactList
                      //     .where((contact) => !contactController.filterContact
                      //         .any((filtered) => contact.phones.any((phone) =>
                      //             phone.number == filtered['phone'])))
                      //     .map((contact) => CustomListTileWidget(
                      //         avatar: contact.displayName[0].toUpperCase(),
                      //         displayName: contact.displayName,
                      //         phoneNumber: contact.phones.first.number)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
