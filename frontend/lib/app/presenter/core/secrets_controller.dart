import 'package:get/get.dart';

import '../../domain/use_cases/chat/get_secrets_uc.dart';
import '../../external/models/secret_model.dart';

class SecretsController extends GetxController {
  @override
  void onInit() async {
    await getSecrets();
    super.onInit();
  }

  final GetSecretsUseCase getSecretsUseCase;

  SecretsController({required this.getSecretsUseCase});

  var secrets = SecretsModel().obs;

  Future<void> getSecrets() async {
    final result = await getSecretsUseCase.call();
    secrets.value = result[0];
  }
}
