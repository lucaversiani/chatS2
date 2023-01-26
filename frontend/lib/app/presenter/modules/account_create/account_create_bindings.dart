import 'package:get/instance_manager.dart';

import '../../../domain/use_cases/chat/add_user_uc.dart';
import 'account_create_controller.dart';

class AccountCreateBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddUserUseCase>(() => AddUserUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<AccountCreateController>(
        () => AccountCreateController(addUserUseCase: Get.find()),
        fenix: true);
  }
}
