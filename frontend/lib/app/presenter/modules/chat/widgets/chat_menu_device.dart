import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/external/models/chat_model.dart';
import 'package:frontend/app/presenter/core/authorization_controller.dart';
import 'package:frontend/app/presenter/modules/chat/chat_controller.dart';
import 'package:get/get.dart';

class ChatMenuDevice extends StatefulWidget {
  const ChatMenuDevice({super.key});

  @override
  State<ChatMenuDevice> createState() => _ChatMenuDeviceState();
}

class _ChatMenuDeviceState extends State<ChatMenuDevice> {
  final _chatController = Get.find<ChatController>();
  Timer? _timer;
  bool _isExpanded = false;

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _chatController.colorIndexSelection =
          (_chatController.colorIndexSelection + 1) %
              _chatController.selectionColors.length;
      if (mounted) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isExpanded
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: 200,
            color: Colors.black45,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                _chatController.isLoadingChatCreation.value
                    ? const SizedBox(
                        height: 38.5,
                        width: 38.5,
                        child: CircularProgressIndicator())
                    : Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7.5),
                                  border: Border.all(
                                      color: Colors.grey.shade700, width: 1)),
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7.5)),
                                onPressed: () async {
                                  if (_chatController.chats.length < 5) {
                                    _chatController
                                        .isLoadingChatCreation.value = true;
                                    await _chatController.createNewChat();
                                    _chatController
                                        .isLoadingChatCreation.value = false;
                                  } else {
                                    Get.showSnackbar(GetSnackBar(
                                      borderRadius: 7.5,
                                      margin: const EdgeInsets.only(
                                        top: 15,
                                      ),
                                      backgroundColor:
                                          Colors.red.withOpacity(0.6),
                                      snackPosition: SnackPosition.TOP,
                                      maxWidth: 350,
                                      titleText: const Text("Not allowed",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      messageText: const Text(
                                          "You can only create up to 5 chats. Delete one.",
                                          style: TextStyle(fontSize: 12)),
                                      duration: const Duration(seconds: 5),
                                    ));
                                  }
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.5, vertical: 17.5),
                                child: Row(
                                  children: const [
                                    Icon(Icons.add, size: 17.5),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "New Chat",
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          IconButton(
                              padding: EdgeInsets.zero,
                              splashRadius: 1,
                              onPressed: () {
                                setState(() {
                                  _isExpanded = false;
                                });
                              },
                              icon: const Icon(Icons.menu_open, size: 22.5))
                        ],
                      ),
                const SizedBox(height: 5),
                Divider(color: Colors.grey.shade600),
                const SizedBox(height: 5),
                () {
                  if (_chatController.isLoadingChatsDeletion.value) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: const SizedBox(
                            height: 45,
                            width: 45,
                            child: CircularProgressIndicator()),
                      ),
                    );
                  } else if (_chatController.chats.isNotEmpty) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Active Chats",
                            style: TextStyle(fontSize: 11),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                                itemCount: _chatController.chats.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.5)),
                                        height: 40,
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        onPressed: _chatController
                                                .isLoadingChatSelection.value
                                            ? () {}
                                            : () async => await _chatController
                                                .selectChat(
                                                    chatId: _chatController
                                                        .chats[index].id),
                                        padding: EdgeInsets.zero,
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          curve: Curves.easeInOut,
                                          padding: const EdgeInsets.all(10),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7.5),
                                              border: Border.all(
                                                  color: _chatController
                                                          .chats[index].selected
                                                      ? _chatController
                                                              .selectionColors[
                                                          _chatController
                                                              .colorIndexSelection]
                                                      : Colors.grey.shade700,
                                                  width: 1)),
                                          child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 125,
                                                  child: Text(
                                                      _chatController
                                                              .chats[index]
                                                              .conversation
                                                              .isEmpty
                                                          ? "New chat"
                                                          : '${_chatController.chats[index].conversation[0]}',
                                                      overflow:
                                                          TextOverflow.clip,
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                          fontSize: 11)),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: () async =>
                                                      await _chatController
                                                          .deleteChatUseCase
                                                          .call(ChatModel(
                                                              id: _chatController
                                                                  .chats[index]
                                                                  .id)),
                                                  child: const FaIcon(
                                                      FontAwesomeIcons.trashCan,
                                                      size: 13),
                                                )
                                              ]),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Spacer();
                  }
                }(),
                Divider(color: Colors.grey.shade600),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5)),
                  onPressed: () async {
                    if (_chatController.chats.isNotEmpty) {
                      _chatController.isLoadingChatsDeletion.value = true;
                      for (var chat in _chatController.chats) {
                        await _chatController.deleteChatUseCase
                            .call(ChatModel(id: chat.id));
                      }
                      _chatController.isLoadingChatsDeletion.value = false;
                    }
                  },
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.5, vertical: 17.5),
                  child: Row(
                    children: const [
                      Icon(Icons.clear, size: 17.5),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Clear all",
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.5)),
                  onPressed: () async =>
                      await Get.find<AuthorizationController>().signOut(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.5, vertical: 17.5),
                  child: Row(
                    children: const [
                      Icon(Icons.logout, size: 17.5),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Sign out",
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.all(5),
            color: Colors.black45,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                IconButton(
                    splashRadius: 1,
                    onPressed: () {
                      setState(() {
                        _isExpanded = true;
                      });
                    },
                    icon: const Icon(Icons.menu, size: 22.5)),
                const Spacer(),
                IconButton(
                    splashRadius: 1,
                    onPressed: () async {
                      if (_chatController.chats.isNotEmpty) {
                        _chatController.isLoadingChatsDeletion.value = true;
                        for (var chat in _chatController.chats) {
                          await _chatController.deleteChatUseCase
                              .call(ChatModel(id: chat.id));
                        }
                        _chatController.isLoadingChatsDeletion.value = false;
                      }
                    },
                    icon: const Icon(Icons.clear, size: 22.5)),
                IconButton(
                    splashRadius: 1,
                    onPressed: () async =>
                        await Get.find<AuthorizationController>().signOut(),
                    icon: const Icon(Icons.logout, size: 22.5)),
                const SizedBox(height: 5),
              ],
            ),
          );
  }
}
