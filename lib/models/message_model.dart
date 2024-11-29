import 'package:hive/hive.dart';

part 'message_model.g.dart'; // Generated file when using hive_generator

@HiveType(typeId: 0)
class Message {
  @HiveField(0)
  final String senderId;

  @HiveField(1)
  final String receiverId;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final int timestamp;

  @HiveField(4)
  final String receiverName;

  @HiveField(5)
  final String senderPhone;

  Message({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.receiverName,
    required this.senderPhone,
  });
}
