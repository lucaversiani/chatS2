import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/instance_manager.dart';
import 'package:http/http.dart';

import '../../domain/use_cases/chat/get_secrets_uc.dart';
import '../../domain/use_cases/chat/get_user_uc.dart';
import '../../domain/use_cases/chat/update_user_verified_email_uc.dart';
import '../../external/data_sources/remote_data_source.dart';
import '../../external/data_sources/remote_data_source_impl.dart';
import '../../infra/repository.dart';
import '../../infra/repository_impl.dart';
import 'authorization_controller.dart';
import 'secrets_controller.dart';
import 'user_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance,
        fenix: true);

    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);

    Get.lazyPut<Client>(() => Client(), fenix: true);

    Get.lazyPut<RemoteDataSource>(
        () => RemoteDataSourceImpl(instance: Get.find(), client: Get.find()),
        fenix: true);

    Get.lazyPut<Repository>(() => RepositoryImpl(remoteDataSource: Get.find()),
        fenix: true);

    // ---------- //

    Get.lazyPut<GetSecretsUseCase>(
        () => GetSecretsUseCase(repository: Get.find()),
        fenix: true);

    Get.put<SecretsController>(SecretsController(getSecretsUseCase: Get.find()),
        permanent: true);

    Get.lazyPut<GetUserUseCase>(() => GetUserUseCase(repository: Get.find()),
        fenix: true);

    Get.lazyPut<UpdateUserVerifiedEmail>(
        () => UpdateUserVerifiedEmail(repository: Get.find()),
        fenix: true);

    Get.put<UserController>(
        UserController(
            getUserUseCase: Get.find(), updateUserVerifiedEmail: Get.find()),
        permanent: true);

    Get.put<AuthorizationController>(AuthorizationController(),
        permanent: true);
  }
}
