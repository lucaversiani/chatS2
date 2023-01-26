import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/user_controller.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () async {
      if (Get.find<FirebaseAuth>().currentUser != null) {
        await Get.find<UserController>()
            .waitForUser()
            .then((_) => Get.offAllNamed('/chat/home'));
      } else {
        Get.offAllNamed('/login');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
