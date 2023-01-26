import 'package:get/instance_manager.dart';

import '../../../domain/use_cases/chat/add_chat_uc.dart';
import '../../../domain/use_cases/chat/add_message_in_conversation_uc.dart';
import '../../../domain/use_cases/chat/delete_chat_uc.dart';
import '../../../domain/use_cases/chat/delete_last_message_uc.dart';
import '../../../domain/use_cases/chat/get_chats_uc.dart';
import '../../../domain/use_cases/chat/send_chat_uc.dart';
import '../../../domain/use_cases/chat/update_chat_memory_uc.dart';
import '../../../domain/use_cases/chat/update_chat_selection.dart';
import '../../../domain/use_cases/chat/update_message_failure_uc.dart';
import 'chat_controller.dart';

class ChatBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SendChatUseCase>(() => SendChatUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<UpdateChatMemoryUseCase>(
        () => UpdateChatMemoryUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<UpdateChatSelectionUseCase>(
        () => UpdateChatSelectionUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<AddChatUseCase>(() => AddChatUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<GetChatsUseCase>(() => GetChatsUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<DeleteChatUseCase>(
        () => DeleteChatUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<AddMessageInConversationUseCase>(
        () => AddMessageInConversationUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<UpdateMessageFailureUseCase>(
        () => UpdateMessageFailureUseCase(repository: Get.find()),
        fenix: true);
    Get.lazyPut<DeleteLastMessageUseCase>(
        () => DeleteLastMessageUseCase(repository: Get.find()),
        fenix: true);

    Get.lazyPut<ChatController>(
        () => ChatController(
            sendChatUseCase: Get.find(),
            updateChatMemoryUseCase: Get.find(),
            addChatUseCase: Get.find(),
            getChatsUseCase: Get.find(),
            updateChatSelectionUseCase: Get.find(),
            deleteChatUseCase: Get.find(),
            addMessageInConversationUseCase: Get.find(),
            updateMessageFailureUseCase: Get.find(),
            deleteLastMessageUseCase: Get.find()),
        fenix: true);
  }
}
