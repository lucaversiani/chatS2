import '../models/chat_model.dart';
import '../models/secret_model.dart';
import '../models/user_model.dart';

abstract class RemoteDataSource {
  Future<void> addUser(UserModel user);
  Future<void> updateUserVerifiedEmail(UserModel user);
  Stream<List<UserModel>> getUser(UserModel user);

  Future<void> updateChatMemory(ChatModel chat);
  Future<void> updateChatSelection(ChatModel chat);
  Future<void> updateMessageFailure(ChatModel chat);
  Future<String> addChat(ChatModel chat);
  Stream<List<ChatModel>> getChats(String userUid);
  Future<Map> sendChat(String input, var memory, var apiKey);
  Future<void> deleteChat(ChatModel chat);
  Future<void> deleteLastMessage(ChatModel chat, String lastInput);
  Future<void> addMessageInConversation(ChatModel chat, String message);

  Future<List<SecretsModel>> getSecrets();
}
