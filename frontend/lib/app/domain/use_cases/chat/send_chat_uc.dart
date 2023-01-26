import '../../../infra/repository.dart';

class SendChatUseCase {
  final Repository repository;

  SendChatUseCase({required this.repository});

  Future<Map> call(String input, var memory, var apiKey) async {
    return repository.sendChat(input, memory, apiKey);
  }
}
