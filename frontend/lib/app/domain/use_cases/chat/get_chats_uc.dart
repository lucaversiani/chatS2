import '../../../external/models/chat_model.dart';
import '../../../infra/repository.dart';

class GetChatsUseCase {
  final Repository repository;

  GetChatsUseCase({required this.repository});

  Stream<List<ChatModel>> call(String userUid) {
    return repository.getChats(userUid);
  }
}
