import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/my_routes.dart';

class Guard extends GetMiddleware {
  final auth = Get.find<FirebaseAuth>();

  @override
  RouteSettings? redirect(String? route) =>
      auth.currentUser != null ? null : const RouteSettings(name: Routes.LOGIN);
}
