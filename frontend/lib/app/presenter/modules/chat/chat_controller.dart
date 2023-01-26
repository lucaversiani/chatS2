// ignore_for_file: avoid_init_to_null, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/app/domain/use_cases/chat/add_chat_uc.dart';
import 'package:frontend/app/domain/use_cases/chat/add_message_in_conversation_uc.dart';
import 'package:frontend/app/domain/use_cases/chat/delete_chat_uc.dart';
import 'package:frontend/app/domain/use_cases/chat/delete_last_message_uc.dart';
import 'package:frontend/app/domain/use_cases/chat/get_chats_uc.dart';
import 'package:frontend/app/domain/use_cases/chat/send_chat_uc.dart';
import 'package:frontend/app/domain/use_cases/chat/update_chat_memory_uc.dart';
import 'package:frontend/app/domain/use_cases/chat/update_chat_selection.dart';
import 'package:frontend/app/domain/use_cases/chat/update_message_failure_uc.dart';
import 'package:frontend/app/external/models/chat_model.dart';
import 'package:frontend/app/presenter/core/secrets_controller.dart';
import 'package:frontend/app/presenter/core/user_controller.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  @override
  void onInit() async {
    await getChats(userUid: Get.find<UserController>().user.value.userUid!);

    super.onInit();
  }

  final SendChatUseCase sendChatUseCase;
  final AddChatUseCase addChatUseCase;
  final UpdateChatMemoryUseCase updateChatMemoryUseCase;
  final UpdateChatSelectionUseCase updateChatSelectionUseCase;
  final GetChatsUseCase getChatsUseCase;
  final DeleteChatUseCase deleteChatUseCase;
  final AddMessageInConversationUseCase addMessageInConversationUseCase;
  final UpdateMessageFailureUseCase updateMessageFailureUseCase;
  final DeleteLastMessageUseCase deleteLastMessageUseCase;

  ChatController(
      {required this.sendChatUseCase,
      required this.addChatUseCase,
      required this.updateChatMemoryUseCase,
      required this.getChatsUseCase,
      required this.updateChatSelectionUseCase,
      required this.deleteChatUseCase,
      required this.addMessageInConversationUseCase,
      required this.updateMessageFailureUseCase,
      required this.deleteLastMessageUseCase});

  var chatController = TextEditingController().obs;

  var subscription;

  List<Color> boostedColors = [
    const Color.fromARGB(255, 21, 199, 154),
    const Color.fromARGB(255, 20, 190, 147),
    const Color.fromARGB(255, 19, 182, 141),
    const Color.fromARGB(255, 18, 173, 134),
    const Color.fromARGB(255, 17, 165, 128),
    const Color.fromARGB(255, 16, 157, 122)
  ];

  List<Color> selectionColors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple
  ];

  int colorIndexSelection = 0;
  int colorIndexBoosted = 0;

  var chats = [].obs;
  var selectedChats = [].obs;

  var humanRe = RegExp(r'(?<=Human: )(.*)(?=AI)');

  var isLoadingChatCreation = false.obs;
  var isLoadingChatsDeletion = false.obs;
  var isLoadingChatMessage = false.obs;
  var isLoadingChatSelection = false.obs;
  var isLoadingChatMessageFailure = false.obs;

  Future<void> getChats({required String userUid}) async {
    subscription = getChatsUseCase.call(userUid).listen((chats) {
      this.chats.value = chats;
      selectedChats.value =
          chats.where((element) => element.selected == true).toList();
    });
  }

  Future<void> selectChat({required String chatId}) async {
    isLoadingChatSelection.value = true;
    final List chatsId = chats
        .where((element) => element.selected == true)
        .toList()
        .map((element) => element.id)
        .toList();

    for (var id in chatsId) {
      await updateChatSelectionUseCase.call(ChatModel(id: id, selected: false));
    }

    await updateChatSelectionUseCase
        .call(ChatModel(id: chatId, selected: true));

    isLoadingChatSelection.value = false;
  }

  Future<void> createNewChat() async {
    final id = await addChatUseCase.call(ChatModel(
        creationDate: DateTime.now().toString(),
        memory: {},
        userUid: Get.find<UserController>().user.value.userUid,
        selected: false,
        lastMessageFailed: false,
        conversation: []));

    await selectChat(chatId: id);
  }

  Future<void> sendChatMessage(
      {required String userInput, required String chatId}) async {
    final apiKey = Get.find<SecretsController>().secrets.value.apiKey;
    late dynamic chatMemory;

    for (var chat in chats
        .where((element) => element.id == chatId)
        .toList()[0]
        .conversation) {
      if (chat == userInput) {
        throw UnimplementedError();
      }
    }

    if (chats
        .where((element) => element.id == chatId)
        .toList()[0]
        .memory
        .isEmpty) {
      chatMemory = null;
    } else {
      final memory =
          chats.where((element) => element.id == chatId).toList()[0].memory;
      chatMemory = jsonEncode({
        "human_prefix": memory["human_prefix"],
        "ai_prefix": memory["ai_prefix"],
        "buffer": memory["buffer"],
        "memory_key": memory["memory_key"],
        "output_key": memory["output_key"],
        "input_key": memory["input_key"],
        "k": memory["k"]
      });
    }

    try {
      await addMessageInConversationUseCase.call(
          ChatModel(id: chatId), userInput);

      isLoadingChatMessage.value = true;

      final response =
          await sendChatUseCase.call(userInput, chatMemory, apiKey);

      final memory = jsonDecode(response["memory"]);
      final output = response["output"];

      await addMessageInConversationUseCase.call(ChatModel(id: chatId), output);

      await updateChatMemoryUseCase.call(ChatModel(memory: memory, id: chatId));
    } catch (e) {
      await updateMessageFailureUseCase
          .call(ChatModel(id: chatId, lastMessageFailed: true));
    } finally {
      isLoadingChatMessage.value = false;
    }
  }

  Future<void> regenerateResponse({required String chatId}) async {
    final lastMessage = chats
        .where((element) => element.id == chatId)
        .toList()[0]
        .conversation
        .last;

    await deleteLastMessageUseCase
        .call(ChatModel(id: chatId), lastMessage)
        .then((_) async =>
            await sendChatMessage(userInput: lastMessage, chatId: chatId));
  }

  Future<void> tryAgainFailedMessage({required String chatId}) async {
    final apiKey = Get.find<SecretsController>().secrets.value.apiKey;
    late dynamic chatMemory;

    if (chats
        .where((element) => element.id == chatId)
        .toList()[0]
        .memory
        .isEmpty) {
      chatMemory = null;
    } else {
      final memory =
          chats.where((element) => element.id == chatId).toList()[0].memory;
      chatMemory = jsonEncode({
        "human_prefix": memory["human_prefix"],
        "ai_prefix": memory["ai_prefix"],
        "buffer": memory["buffer"],
        "memory_key": memory["memory_key"],
        "output_key": memory["output_key"],
        "input_key": memory["input_key"],
        "k": memory["k"]
      });
    }

    isLoadingChatMessageFailure.value = true;

    Future<String> call() async {
      try {
        final response = await sendChatUseCase.call(
            chats
                .where((element) => element.id == chatId)
                .toList()[0]
                .conversation
                .last,
            chatMemory,
            apiKey);

        final memory = jsonDecode(response["memory"]);
        final output = response["output"];

        await updateChatMemoryUseCase
            .call(ChatModel(memory: memory, id: chatId));

        await updateMessageFailureUseCase
            .call(ChatModel(id: chatId, lastMessageFailed: false));
        return output;
      } catch (e) {
        Get.showSnackbar(GetSnackBar(
          borderRadius: 7.5,
          margin: const EdgeInsets.only(
            top: 15,
          ),
          backgroundColor: Colors.red.withOpacity(0.6),
          snackPosition: SnackPosition.TOP,
          maxWidth: 350,
          titleText: const Text("Failure",
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          messageText: const Text(
              "Message sending failed. Please check your connection and try again.",
              style: TextStyle(fontSize: 12)),
          duration: const Duration(seconds: 5),
        ));
        throw UnimplementedError();
      }
    }

    await call()
        .whenComplete(() => isLoadingChatMessageFailure.value = false)
        .then((output) async {
      await addMessageInConversationUseCase.call(ChatModel(id: chatId), output);
    }).onError((error, stackTrace) => null);
  }

  void clearChats() {
    if (subscription != null) subscription.cancel();
    Future.delayed(const Duration(seconds: 1), () => chats.value = []);
  }
}
