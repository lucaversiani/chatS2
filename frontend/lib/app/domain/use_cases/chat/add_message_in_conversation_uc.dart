import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class AddMessageInConversationUseCase {
  final Repository repository;

  AddMessageInConversationUseCase({required this.repository});

  Future<void> call(ChatModel chat, String message) async {
    return repository.addMessageInConversation(chat, message);
  }
}
