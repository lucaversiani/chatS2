import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/use_cases/chat/add_user_uc.dart';
import '../../../external/models/user_model.dart';
import '../../core/user_controller.dart';
import '../../core/authorization_controller.dart';

class AccountCreateController extends GetxController {
  var nameController = TextEditingController().obs;
  var mailController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;

  var regexPassword = RegExp(r'^(?=.*[A-Z])');

  var isLoading = false.obs;

  final AddUserUseCase addUserUseCase;

  AccountCreateController({required this.addUserUseCase});

  Future<void> createUserAndLogin() async {
    isLoading.value = true;
    try {
      final credential = await Get.find<AuthorizationController>()
          .createAccount(
              email: mailController.value.text,
              password: passwordController.value.text);

      if (credential.user != null && credential.user!.emailVerified) {
        await credential.user!.sendEmailVerification();
      }

      await addUserUseCase
          .call(UserModel(
              name: nameController.value.text.trim(),
              mail: mailController.value.text.trim(),
              userUid: credential.user!.uid,
              emailVerified: false))
          .then((_) async {
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
          messageText: const Text("Your account was created with success!",
              style: TextStyle(fontSize: 12)),
          duration: const Duration(seconds: 5),
        ));

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
        messageText: const Text(
            "We had a problem creating your account! Check your data.",
            style: TextStyle(fontSize: 12)),
        duration: const Duration(seconds: 5),
      ));
    } finally {
      isLoading.value = false;
    }
  }
}
