import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hiv/constact/color_constant.dart';
import 'package:hiv/models/user_model.dart';
import 'package:hiv/screens/home/main_screen.dart';
import 'package:hive/hive.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  updateLoadingStatus(value) {
    isLoading.value = value;
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    openBox();
  }

  Future openBox() async {
    await Hive.openBox('userBox');
  }

  
  Future<void> signUp(
    UserModel userModel,
    String password,
  ) async {
    try {
      updateLoadingStatus(true);
      await auth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);
      await firebaseFirestore.collection('users').doc().set(userModel.toJson());
      updateLoadingStatus(false);
    } catch (e) {
      updateLoadingStatus(false);
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addUsersBatch() async {
    updateLoadingStatus(false);
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    for (int i = 100; i < 500; i++) {
      final email = 'testuser$i@example.com';
      const password = 'Test@12345'; 
      final name = 'Test User $i';
      final phone = '0324400689$i';

      try {
        
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

       
        final uid = userCredential.user!.uid;

        // Create the UserModel
        final userModel = UserModel(
          uid: uid, 
          email: email,
          name: name,
          phone: phone,
        );

        // Add user to Firestore
        await firestore
            .collection('users')
            .doc(uid) 
            .set(userModel.toJson());

        updateLoadingStatus(false);
        if (kDebugMode) {
          print('User ${userModel.email} created successfully!');
        }
      } catch (e) {
        updateLoadingStatus(false);
        if (kDebugMode) {
          print('Error creating user $email: $e');
        }
      }
    }
  }

  Future<bool> initConnectivity() async {
    try {
      final result = await Connectivity().checkConnectivity();
      return result != ConnectivityResult.none;
    } catch (e) {
      return false;
    }
  }

  
  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;

      bool isConnected = await initConnectivity();
      if (!isConnected) {
        throw Exception('No internet connection. Please check your network.');
      }

      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'The sign-in request timed out. Please try again.');
      });

      var userDetail = await firebaseFirestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();

      String? phone = userDetail['phone'];

     
      final userBox = await Hive.openBox('userBox');
      userBox.put('email', email);
      userBox.put('phone', phone);

      Get.offAll(() => MainScreen());
      isLoading.value = false;
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.message ?? 'An unexpected error occurred.',
          snackPosition: SnackPosition.BOTTOM, colorText: TopicColor.white);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM, colorText: TopicColor.white);
    }
  }

  Future<User?> checkLogin() async {
    return auth.currentUser;
  }

  Future logout() async {
    await auth.signOut();
  }

  bool get isLoggedIn => auth.currentUser != null;

}

