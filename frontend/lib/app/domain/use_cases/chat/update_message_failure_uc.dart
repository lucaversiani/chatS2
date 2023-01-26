import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class UpdateMessageFailureUseCase {
  final Repository repository;

  UpdateMessageFailureUseCase({required this.repository});

  Future<void> call(ChatModel chat) async {
    return repository.updateMessageFailure(chat);
  }
}
