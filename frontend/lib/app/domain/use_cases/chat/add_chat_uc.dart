import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class AddChatUseCase {
  final Repository repository;

  AddChatUseCase({required this.repository});

  Future<String> call(ChatModel chat) async {
    return repository.addChat(chat);
  }
}
