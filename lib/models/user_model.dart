import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String uid;
  String email;
  String name;
  String phone;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
    };
  }
}


