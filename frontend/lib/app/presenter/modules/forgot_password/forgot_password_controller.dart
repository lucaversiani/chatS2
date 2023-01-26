import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  var emailController = TextEditingController().obs;
  var isLoading = false.obs;

  Future<void> sendForgottenPasswordEmail() async {
    isLoading.value = true;
    try {
      await Get.find<FirebaseAuth>()
          .sendPasswordResetEmail(email: emailController.value.text)
          .then((_) {
        Get.showSnackbar(GetSnackBar(
          borderRadius: 7.5,
          margin: const EdgeInsets.only(
            top: 15,
          ),
          backgroundColor: Colors.green.withOpacity(0.6),
          snackPosition: SnackPosition.TOP,
          maxWidth: 350,
          titleText: const Text("Success",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          messageText: const Text(
              "You will receive the password reset instructions in your inbox!",
              style: TextStyle(fontSize: 12)),
          duration: const Duration(seconds: 5),
        ));
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
        messageText: const Text(
            "We had a problem sending your password reset request! Try again.",
            style: TextStyle(fontSize: 12)),
        duration: const Duration(seconds: 5),
      ));
    } finally {
      isLoading.value = false;
    }
  }
}
