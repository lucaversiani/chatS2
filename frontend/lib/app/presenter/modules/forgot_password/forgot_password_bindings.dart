import 'package:get/instance_manager.dart';

import 'forgot_password_controller.dart';

class ForgotPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController(),
        fenix: true);
  }
}
