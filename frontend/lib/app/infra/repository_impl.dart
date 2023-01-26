import '../external/data_sources/remote_data_source.dart';
import '../external/models/chat_model.dart';
import '../external/models/secret_model.dart';
import '../external/models/user_model.dart';

import 'repository.dart';

class RepositoryImpl extends Repository {
  final RemoteDataSource remoteDataSource;

  RepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addUser(UserModel user) async {
    try {
      await remoteDataSource.addUser(user);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Stream<List<UserModel>> getUser(UserModel user) {
    try {
      return remoteDataSource.getUser(user);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> updateUserVerifiedEmail(UserModel user) async {
    try {
      await remoteDataSource.updateUserVerifiedEmail(user);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> updateChatMemory(ChatModel chat) async {
    try {
      await remoteDataSource.updateChatMemory(chat);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> updateMessageFailure(ChatModel chat) async {
    try {
      await remoteDataSource.updateMessageFailure(chat);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> updateChatSelection(ChatModel chat) async {
    try {
      await remoteDataSource.updateChatSelection(chat);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<String> addChat(ChatModel chat) async {
    try {
      return await remoteDataSource.addChat(chat);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteChat(ChatModel chat) async {
    try {
      return await remoteDataSource.deleteChat(chat);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> deleteLastMessage(ChatModel chat, String lastInput) async {
    try {
      return await remoteDataSource.deleteLastMessage(chat, lastInput);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<void> addMessageInConversation(ChatModel chat, String message) async {
    try {
      return await remoteDataSource.addMessageInConversation(chat, message);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<Map> sendChat(String input, var memory, var apiKey) async {
    try {
      return await remoteDataSource.sendChat(input, memory, apiKey);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Stream<List<ChatModel>> getChats(String userUid) {
    try {
      return remoteDataSource.getChats(userUid);
    } catch (e) {
      throw UnimplementedError();
    }
  }

  @override
  Future<List<SecretsModel>> getSecrets() async {
    try {
      return await remoteDataSource.getSecrets();
    } catch (e) {
      throw UnimplementedError();
    }
  }
}
