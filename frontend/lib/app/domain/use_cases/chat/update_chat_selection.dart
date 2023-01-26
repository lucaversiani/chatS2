import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class UpdateChatSelectionUseCase {
  final Repository repository;

  UpdateChatSelectionUseCase({required this.repository});

  Future<void> call(ChatModel chat) async {
    return repository.updateChatSelection(chat);
  }
}
