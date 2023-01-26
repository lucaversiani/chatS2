import '../../../external/models/secret_model.dart';
import '../../../infra/repository.dart';

class GetSecretsUseCase {
  final Repository repository;

  GetSecretsUseCase({required this.repository});

  Future<List<SecretsModel>> call() async {
    return repository.getSecrets();
  }
}
