// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:frontend/app/domain/use_cases/chat/get_user_uc.dart';
import 'package:frontend/app/external/models/user_model.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  @override
  void onInit() async {
    if (Get.find<FirebaseAuth>().currentUser != null) {
      await getUser(userUid: Get.find<FirebaseAuth>().currentUser!.uid);
      await waitForUser();
    }

    super.onInit();
  }

  final GetUserUseCase getUserUseCase;

  UserController({required this.getUserUseCase});

  var user = UserModel().obs;

  var subscription;

  Future<void> getUser({required String userUid}) async {
    subscription =
        getUserUseCase.call(UserModel(userUid: userUid)).listen((user) {
      this.user.value = user[0];
    });
  }

  Future<void> waitForUser() async {
    final completer = Completer();
    if (user.value.id == '' || user.value.id == null) {
      await 1000.milliseconds.delay();
      return waitForUser();
    } else {
      completer.complete();
    }
    return completer.future;
  }

  void clearUser() {
    if (subscription != null) subscription.cancel();
    Future.delayed(
        const Duration(seconds: 1), () => user.value = UserModel.empty());
  }
}
