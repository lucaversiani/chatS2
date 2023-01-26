import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class DeleteChatUseCase {
  final Repository repository;

  DeleteChatUseCase({required this.repository});

  Future<void> call(ChatModel chat) async {
    return repository.deleteChat(chat);
  }
}
