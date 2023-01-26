import 'package:get/route_manager.dart';

import '../modules/account_create/account_create_bindings.dart';
import '../modules/account_create/account_create_page.dart';
import '../modules/chat/chat_bindings.dart';
import '../modules/chat/chat_page.dart';
import '../modules/forgot_password/forgot_password_bindings.dart';
import '../modules/forgot_password/forgot_password_page.dart';
import '../modules/login/login_bindings.dart';
import '../modules/login/login_page.dart';
import '../utils/middleware.dart';
import '../utils/middleware_login.dart';
import '../utils/root.dart';
import 'my_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
        name: Routes.CHAT_HOME,
        page: () => const ChatPage(),
        binding: ChatBinding(),
        middlewares: [Guard()]),
    GetPage(
      name: Routes.ROOT,
      page: () => const RootPage(),
    ),
    GetPage(
        name: Routes.LOGIN,
        page: () => const LoginPage(),
        binding: LoginBinding(),
        middlewares: [GuardLogin()]),
    GetPage(
        name: Routes.ACCOUNT_CREATE,
        page: () => const AccountCreatePage(),
        binding: AccountCreateBinding(),
        middlewares: [GuardLogin()]),
    GetPage(
        name: Routes.FORGOT_PASSWORD,
        page: () => const ForgotPasswordPage(),
        binding: ForgotPasswordBinding(),
        middlewares: [GuardLogin()])
  ];
}
