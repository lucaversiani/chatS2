import '../../../external/models/user_model.dart';
import '../../../infra/repository.dart';

class AddUserUseCase {
  final Repository repository;

  AddUserUseCase({required this.repository});

  Future<void> call(UserModel user) async {
    return repository.addUser(user);
  }
}
