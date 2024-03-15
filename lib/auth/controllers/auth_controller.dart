//import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:actionable_tweets/auth/screens/signup.dart';
import 'package:actionable_tweets/auth/utils/constants.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> firebaseUser;
  final RxBool isRegistrationSuccessful = RxBool(false);

  @override
  void onInit() {
    super.onInit();

    firebaseUser = Rx<User?>(firebaseAuth.currentUser);

    firebaseUser.bindStream(firebaseAuth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const SignUp());
    }
    //  else {
    //   Get.offAll(() => const HomeView());
    // }
  }

  // void register(String email, password) async {
  //   try {
  //     await firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   // ignore: empty_catches
  //   } catch (firebaseAuthException) {}
  // }
  Future<void> register(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = firebaseAuth.currentUser;
      if (user != null) {
        await user.updateDisplayName(email);
        isRegistrationSuccessful.value = true;
      }
    } catch (firebaseAuthException) {
      isRegistrationSuccessful.value = false;
      // Print the exception for troubleshooting
      if (kDebugMode) {
        print('Registration failed: $firebaseAuthException');
      }
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return true; // Return true if login is successful
    } catch (firebaseAuthException) {
      if (kDebugMode) {
        print('Login failed: $firebaseAuthException');
      }
      return false; // Return false if login fails
    }
  }
}
