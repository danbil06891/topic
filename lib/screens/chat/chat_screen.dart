import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/controller/message_controller.dart';
import 'package:hiv/screens/home/main_screen.dart';
import 'package:hiv/utils/widgets/format_widget.dart';
import 'package:hiv/utils/widgets/topic_text_field.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.senderNumber,
  });

  final String senderId;
  final String receiverId;
  final String receiverName;
  final String senderNumber;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final MessageController messageController = Get.find();
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      messageController.listenForMessages();
    });
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('Disposing ScrollController...');
    }
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TopicColor.black,
      appBar: AppBar(
        title: Text(
          widget.receiverName,
          style:
              textDesigner(20, TopicColor.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () {
            Get.to(() => MainScreen());
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: TopicColor.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.video_call),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final filteredMessages = messageController.messages.where((msg) {
                return (msg.senderId.trim().toLowerCase() ==
                            widget.senderId.trim().toLowerCase() &&
                        msg.receiverId.trim().toLowerCase() ==
                            widget.receiverId.trim().toLowerCase()) ||
                    (msg.receiverId.trim().toLowerCase() ==
                            widget.senderId.trim().toLowerCase() &&
                        msg.senderId.trim().toLowerCase() ==
                            widget.receiverId.trim().toLowerCase());
              }).toList();

              // Auto-scroll to bottom when new messages are added
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (scrollController.hasClients) {
                  scrollController.jumpTo(
                    scrollController.position.maxScrollExtent,
                  );
                }
              });

              return filteredMessages.isEmpty
                  ? Center(
                      child: Text(
                      'No messages',
                      style: TextStyle(color: TopicColor.white),
                    ))
                  : ListView.builder(
                      controller: scrollController,
                      reverse: false,
                      itemCount: filteredMessages.length,
                      itemBuilder: (context, index) {
                        final message = filteredMessages[index];

                        var timestamp = message.timestamp;
                        DateTime dateTime =
                            DateTime.fromMillisecondsSinceEpoch(timestamp);
                        String time = DateFormat.jm().format(dateTime);
                        String date = DateFormat.yMMMMd().format(dateTime);
                        bool isSentByMe = message.senderId == widget.senderId;

                        return Align(
                          alignment: isSentByMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              gradient: isSentByMe
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF2C4957),
                                        Color(0xFF16252C)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFF454545),
                                        Color(0xFF222222)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                // Message Text
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 70,
                                      bottom: 5), // Avoid overlap with time
                                  child: Text(
                                    message.message,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                                // Time Text
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Text(
                                    time,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            }),
          ),
          _buildMessageInput(messageController),
        ],
      ),
    );
  }

  Widget _buildMessageInput(MessageController messageController) {
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TopicTextField(
              controller: controller,
              hintText: 'Type a message...',
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: TopicColor.white,
            ),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                messageController.sendMessage(
                  widget.senderId,
                  widget.receiverId,
                  controller.text,
                  widget.receiverName,
                  widget.senderNumber,
                );
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
