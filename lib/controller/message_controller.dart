import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hive/hive.dart';
import 'package:hiv/models/message_model.dart';

class MessageController extends GetxController {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late Box<Message> _messageBox;

  var messages = <Message>[].obs;
  var userChats = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  Future<void> openBox() async {
    _messageBox = await Hive.openBox<Message>('messages');
    _loadMessages();
  }

  void _loadMessages() {
    messages.value = _messageBox.values.toList();
  }

  Future<void> sendMessage(String senderId, String receiverId, String message,
      String name, String senderNumber) async {
    final newMessage = Message(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        receiverName: name,
        senderPhone: senderNumber);

    await _saveMessageLocally(newMessage);

    final firebaseMessage = {
      'sender': senderId,
      'receiver': receiverId,
      'message': message,
      'timestamp': newMessage.timestamp,
      'receiverName': newMessage.receiverName,
      'senderNumber': newMessage.senderPhone
    };

    final serverRef = _database.ref().child('serverMessages');
    final messageRef = serverRef.push();
    await messageRef.set(firebaseMessage);

    Future.delayed(const Duration(seconds: 5), () {
      messageRef.remove();
    });
  }

  StreamSubscription<DatabaseEvent>? _messageSubscription;

  void listenForMessages() {
    final serverRef = _database.ref().child('serverMessages');

    _messageSubscription?.cancel();

    _messageSubscription = serverRef.onChildAdded.listen((event) async {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        if (kDebugMode) {
          print('listenMessageObject: $data');
        }

        final newMessage = Message(
          senderId: data['sender'],
          receiverId: data['receiver'],
          message: data['message'],
          timestamp: data['timestamp'],
          receiverName: data['receiverName'] ?? '',
          senderPhone: data['senderNumber'] ?? '',
        );

        if (!messages.any((msg) =>
            msg.senderId == newMessage.senderId &&
            msg.receiverId == newMessage.receiverId &&
            msg.message == newMessage.message &&
            msg.timestamp == newMessage.timestamp)) {
          if (kDebugMode) {
            print('listenMessage: ${newMessage.message}');
          }
          await _saveMessageLocally(newMessage);
          update();
        }

        event.snapshot.ref.remove();
      }
    });
  }

  Future<void> sendMessagesFromAllUsersToTestUser(
      String testUserId, String message, String receiverName) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final usersSnapshot = await firestore.collection('users').get();
      final allUsers = usersSnapshot.docs;

      for (var userDoc in allUsers) {
        final senderId = userDoc.id;
        if (senderId == testUserId) continue;

        var senderNum = userDoc['phone'];

        final newMessage = Message(
            senderId: senderId,
            receiverId: testUserId,
            message: message,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            receiverName: receiverName,
            senderPhone: senderNum);

        // Save the message in Firebase Realtime Database (serverMessages)
        final firebaseMessage = {
          'sender': newMessage.senderId,
          'receiver': newMessage.receiverId,
          'message': newMessage.message,
          'timestamp': newMessage.timestamp,
          'receiverName': newMessage.receiverName,
          'senderNumber': newMessage.senderPhone
        };

        final serverRef = _database.ref().child('serverMessages');
        await serverRef.push().set(firebaseMessage);

        await _saveMessageLocally(newMessage);
        print('Messages sent to test user: $testUserId');
      }
    } catch (e) {
      print('Error sending messages: $e');
    }
  }

  Future<void> _saveMessageLocally(Message message) async {
    await _messageBox.add(message);
    messages.add(message);
  }

  List<Message> getChatHistory(String userId) {
    return messages
        .where((msg) => msg.senderId == userId || msg.receiverId == userId)
        .toList();
  }

  Future<void> clearMessages() async {
    await _messageBox.clear();
    messages.clear();
    userChats.clear();
  }
}
