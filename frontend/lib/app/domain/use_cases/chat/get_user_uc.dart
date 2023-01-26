import '../../../external/models/user_model.dart';
import '../../../infra/repository.dart';

class GetUserUseCase {
  final Repository repository;

  GetUserUseCase({required this.repository});

  Stream<List<UserModel>> call(UserModel user) {
    return repository.getUser(user);
  }
}
