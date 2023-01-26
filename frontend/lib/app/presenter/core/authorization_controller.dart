// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../modules/chat/chat_controller.dart';
import 'user_controller.dart';

class AuthorizationController extends GetxController {
  Future<UserCredential> createAccount(
      {required String email, required String password}) async {
    try {
      final credential =
          await Get.find<FirebaseAuth>().createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      throw UnimplementedError(e.toString());
    }
  }

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await Get.find<FirebaseAuth>()
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw UnimplementedError(e.toString());
    }
  }

  Future<void> sendEmailVerification(
      {required UserCredential credential}) async {
    try {
      await credential.user!.sendEmailVerification();
    } catch (e) {
      throw UnimplementedError(e.toString());
    }
  }

  Future<void> signOut() async {
    await Get.find<FirebaseAuth>().signOut().then((_) {
      Get.offAllNamed('/login');
      Get.find<UserController>().clearUser();
      Get.find<ChatController>().clearChats();
    });
  }
}
