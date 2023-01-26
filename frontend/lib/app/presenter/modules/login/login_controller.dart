import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/user_controller.dart';
import '../../core/authorization_controller.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  var isLoading = false.obs;

  Future<void> loginWithMail() async {
    isLoading.value = true;
    try {
      await Get.find<AuthorizationController>()
          .loginWithEmailAndPassword(
              email: emailController.value.text,
              password: passwordController.value.text)
          .then((_) async {
        await Get.find<UserController>()
            .getUser(userUid: Get.find<FirebaseAuth>().currentUser!.uid);
        await Get.find<UserController>().waitForUser();
        Get.offAllNamed('/chat/home');
      });
    } catch (e) {
      Get.showSnackbar(GetSnackBar(
        borderRadius: 7.5,
        margin: const EdgeInsets.only(
          top: 15,
        ),
        backgroundColor: Colors.red.withOpacity(0.6),
        snackPosition: SnackPosition.TOP,
        maxWidth: 350,
        titleText: const Text("Oh oh...",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        messageText: const Text("Invalid credentials. Please try again!",
            style: TextStyle(fontSize: 12)),
        duration: const Duration(seconds: 5),
      ));
    } finally {
      isLoading.value = false;
    }
  }
}
