import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class UpdateChatMemoryUseCase {
  final Repository repository;

  UpdateChatMemoryUseCase({required this.repository});

  Future<void> call(ChatModel chat) async {
    return repository.updateChatMemory(chat);
  }
}
