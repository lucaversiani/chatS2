import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class DeleteLastMessageUseCase {
  final Repository repository;

  DeleteLastMessageUseCase({required this.repository});

  Future<void> call(ChatModel chat, String lastInput) async {
    return repository.deleteLastMessage(chat, lastInput);
  }
}
