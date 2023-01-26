import 'package:frontend/app/external/models/user_model.dart';

import '../../../infra/repository.dart';

class UpdateUserVerifiedEmail {
  final Repository repository;

  UpdateUserVerifiedEmail({required this.repository});

  Future<void> call(UserModel user) async {
    return repository.updateUserVerifiedEmail(user);
  }
}
