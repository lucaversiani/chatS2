// ignore_for_file: dead_code

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/app/external/models/chat_model.dart';
import 'package:frontend/app/presenter/core/authorization_controller.dart';
import 'package:frontend/app/presenter/modules/chat/chat_controller.dart';
import 'package:frontend/app/presenter/modules/chat/widgets/initial_widget.dart';
import 'package:frontend/app/presenter/modules/chat/widgets/verify_email.dart';
import 'package:frontend/app/presenter/modules/chat/widgets/waiting_chat_widget.dart';
import 'package:get/get.dart';

import '../../core/user_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Timer? _timer;
  final _chatController = Get.find<ChatController>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _chatController.colorIndexSelection =
          (_chatController.colorIndexSelection + 1) %
              _chatController.selectionColors.length;
      _chatController.colorIndexBoosted =
          (_chatController.colorIndexBoosted + 1) %
              _chatController.boostedColors.length;
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
    return Scaffold(
      body: Obx(() => Get.find<UserController>().user.value.emailVerified!
          ? Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: 200,
                      color: Colors.black45,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Column(
                        children: [
                          _chatController.isLoadingChatCreation.value
                              ? const SizedBox(
                                  height: 38.5,
                                  width: 38.5,
                                  child: CircularProgressIndicator())
                              : Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      border: Border.all(
                                          color: Colors.grey.shade700,
                                          width: 1)),
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.5)),
                                    onPressed: () async {
                                      if (_chatController.chats.length < 5) {
                                        _chatController
                                            .isLoadingChatCreation.value = true;
                                        await _chatController.createNewChat();
                                        _chatController.isLoadingChatCreation
                                            .value = false;
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
                                          width: 10,
                                        ),
                                        Text(
                                          "New Chat",
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
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
                                          itemCount:
                                              _chatController.chats.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              children: [
                                                MaterialButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.5)),
                                                  height: 40,
                                                  minWidth:
                                                      MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                  onPressed: _chatController
                                                          .isLoadingChatSelection
                                                          .value
                                                      ? () {}
                                                      : () async =>
                                                          await _chatController
                                                              .selectChat(
                                                                  chatId: _chatController
                                                                      .chats[
                                                                          index]
                                                                      .id),
                                                  padding: EdgeInsets.zero,
                                                  child: AnimatedContainer(
                                                    duration: const Duration(
                                                        milliseconds: 200),
                                                    curve: Curves.easeInOut,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.5),
                                                        border: Border.all(
                                                            color: _chatController
                                                                    .chats[
                                                                        index]
                                                                    .selected
                                                                ? _chatController
                                                                        .selectionColors[
                                                                    _chatController
                                                                        .colorIndexSelection]
                                                                : Colors.grey
                                                                    .shade700,
                                                            width: 1)),
                                                    child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            width: 125,
                                                            child: Text(
                                                                _chatController
                                                                        .chats[
                                                                            index]
                                                                        .conversation
                                                                        .isEmpty
                                                                    ? "New chat"
                                                                    : '${_chatController.chats[index].conversation[0]}',
                                                                overflow:
                                                                    TextOverflow
                                                                        .clip,
                                                                maxLines: 1,
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            11)),
                                                          ),
                                                          const Spacer(),
                                                          GestureDetector(
                                                            onTap: () async => await _chatController
                                                                .deleteChatUseCase
                                                                .call(ChatModel(
                                                                    id: _chatController
                                                                        .chats[
                                                                            index]
                                                                        .id)),
                                                            child: const FaIcon(
                                                                FontAwesomeIcons
                                                                    .trashCan,
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
                                _chatController.isLoadingChatsDeletion.value =
                                    true;
                                for (var chat in _chatController.chats) {
                                  await _chatController.deleteChatUseCase
                                      .call(ChatModel(id: chat.id));
                                }
                                _chatController.isLoadingChatsDeletion.value =
                                    false;
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
                                await Get.find<AuthorizationController>()
                                    .signOut(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.5, vertical: 17.5),
                            child: Row(
                              children: const [
                                Icon(Icons.logout, size: 17.5),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Log out",
                                  style: TextStyle(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SelectionArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              () {
                                if ((_chatController.chats.isEmpty ||
                                        _chatController
                                            .selectedChats.isEmpty) &&
                                    _chatController
                                            .isLoadingChatSelection.value ==
                                        false) {
                                  return const WaitingChatWidget();
                                } else if (_chatController
                                    .isLoadingChatSelection.value) {
                                  return Expanded(
                                    child: Column(
                                      children: const [
                                        Spacer(),
                                        CircularProgressIndicator(),
                                        Spacer()
                                      ],
                                    ),
                                  );
                                } else if (_chatController
                                    .selectedChats[0].conversation.isEmpty) {
                                  return const InitialChatWidget();
                                } else if (_chatController
                                    .selectedChats[0].conversation.isNotEmpty) {
                                  return Expanded(
                                    child: Column(
                                      children: [
                                        Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            color: Colors.grey.shade800,
                                            child: Row(
                                              children: [
                                                const Spacer(),
                                                Container(
                                                  alignment: Alignment.center,
                                                  width: 30,
                                                  height: 30,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xff11a37f),
                                                  ),
                                                  child: const FaIcon(
                                                      FontAwesomeIcons.heart,
                                                      size: 20),
                                                ),
                                                const SizedBox(
                                                  width: 12.5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                      "ChatS2 (Chat created in ${_chatController.selectedChats[0].creationDate.substring(0, 19)})",
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                      maxLines: 1,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                const Spacer(),
                                              ],
                                            )),
                                        Expanded(
                                          child: ListView.builder(
                                              itemCount: _chatController
                                                  .selectedChats[0]
                                                  .conversation
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                if (index % 2 == 0) {
                                                  return Column(
                                                    children: [
                                                      index == 0
                                                          ? const SizedBox(
                                                              height: 15)
                                                          : const SizedBox
                                                              .shrink(),
                                                      SizedBox(
                                                        width: 600,
                                                        child: Row(
                                                          children: [
                                                            const Spacer(),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(15),
                                                                  decoration: BoxDecoration(
                                                                      color: const Color(
                                                                          0xff11a37f),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7.5)),
                                                                  constraints: const BoxConstraints(
                                                                      minWidth:
                                                                          100,
                                                                      maxWidth:
                                                                          300),
                                                                  child: Text(
                                                                      _chatController
                                                                              .selectedChats[0].conversation[
                                                                          index],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12)),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    width: 40,
                                                                    height: 40,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      color: Colors
                                                                          .red
                                                                          .shade600,
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            7.5),
                                                                    child: Text(
                                                                        "${Get.find<UserController>().user.value.name?.substring(0, 1) ?? ''}${Get.find<UserController>().user.value.name?.split(' ').length == 1 ? "" : Get.find<UserController>().user.value.name?.split(' ').last.substring(0, 1)}",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 16)))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      () {
                                                        if (_chatController
                                                                .isLoadingChatMessage
                                                                .value &&
                                                            index ==
                                                                _chatController.selectedChats[0].conversation.length -
                                                                    1) {
                                                          return SizedBox(
                                                            width: 600,
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Color(
                                                                            0xff11a37f),
                                                                      ),
                                                                      child: const FaIcon(
                                                                          FontAwesomeIcons
                                                                              .heart,
                                                                          size:
                                                                              23),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              15),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade800,
                                                                          borderRadius:
                                                                              BorderRadius.circular(7.5)),
                                                                      width:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: const [
                                                                          Text(
                                                                              "ChatS2",
                                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff11a37f))),
                                                                          SizedBox(
                                                                              height: 10),
                                                                          SpinKitThreeBounce(
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                12.5,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Spacer(),
                                                              ],
                                                            ),
                                                          );
                                                        } else if (_chatController.selectedChats[0].lastMessageFailed ==
                                                                true &&
                                                            _chatController
                                                                    .isLoadingChatMessageFailure
                                                                    .value ==
                                                                false &&
                                                            index ==
                                                                _chatController.selectedChats[0].conversation.length -
                                                                    1) {
                                                          return SizedBox(
                                                            width: 600,
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              7.5),
                                                                      child: const Icon(
                                                                          Icons
                                                                              .error_outline),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade800,
                                                                          borderRadius:
                                                                              BorderRadius.circular(7.5)),
                                                                      width:
                                                                          250,
                                                                      child:
                                                                          MaterialButton(
                                                                        padding:
                                                                            EdgeInsets.zero,
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(7.5)),
                                                                        onPressed:
                                                                            () async {
                                                                          await _chatController.tryAgainFailedMessage(
                                                                              chatId: _chatController.selectedChats[0].id);
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(15.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: const [
                                                                              Text("ChatS2", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff11a37f))),
                                                                              SizedBox(height: 10),
                                                                              Text("Request error. Please click here to try again. If the issue persists, contact developers.", style: TextStyle(fontSize: 11, color: Colors.red))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Spacer(),
                                                              ],
                                                            ),
                                                          );
                                                        } else if (_chatController
                                                                .isLoadingChatMessageFailure
                                                                .value &&
                                                            index ==
                                                                _chatController.selectedChats[0].conversation.length -
                                                                    1) {
                                                          return SizedBox(
                                                            width: 600,
                                                            child: Row(
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      width: 40,
                                                                      height:
                                                                          40,
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Color(
                                                                            0xff11a37f),
                                                                      ),
                                                                      child: const FaIcon(
                                                                          FontAwesomeIcons
                                                                              .heart,
                                                                          size:
                                                                              23),
                                                                    ),
                                                                    const SizedBox(
                                                                        width:
                                                                            10),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              15),
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .shade800,
                                                                          borderRadius:
                                                                              BorderRadius.circular(7.5)),
                                                                      width:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: const [
                                                                          Text(
                                                                              "ChatS2",
                                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff11a37f))),
                                                                          SizedBox(
                                                                              height: 10),
                                                                          SpinKitThreeBounce(
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                12.5,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const Spacer(),
                                                              ],
                                                            ),
                                                          );
                                                        } else if (_chatController
                                                                .selectedChats
                                                                .isNotEmpty &&
                                                            _chatController
                                                                .selectedChats[
                                                                    0]
                                                                .conversation
                                                                .isNotEmpty &&
                                                            _chatController.selectedChats[0].conversation.length % 2 !=
                                                                0 &&
                                                            _chatController
                                                                    .isLoadingChatMessage
                                                                    .value ==
                                                                false &&
                                                            _chatController
                                                                    .selectedChats[0]
                                                                    .lastMessageFailed ==
                                                                false &&
                                                            index == _chatController.selectedChats[0].conversation.length - 1) {
                                                          return Column(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              const Color(0xff11a37f),
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(7.5)),
                                                                child:
                                                                    MaterialButton(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(20),
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7.5)),
                                                                  onPressed:
                                                                      () async {
                                                                    await _chatController.regenerateResponse(
                                                                        chatId: _chatController
                                                                            .selectedChats[0]
                                                                            .id);
                                                                  },
                                                                  child: const Text(
                                                                      "Regenerate response",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Color(0xff11a37f))),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                            ],
                                                          );
                                                        } else {
                                                          return const SizedBox
                                                              .shrink();
                                                        }
                                                      }()
                                                    ],
                                                  );
                                                } else {
                                                  return Column(
                                                    children: [
                                                      SizedBox(
                                                        width: 600,
                                                        child: Row(
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  width: 40,
                                                                  height: 40,
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Color(
                                                                        0xff11a37f),
                                                                  ),
                                                                  child: const FaIcon(
                                                                      FontAwesomeIcons
                                                                          .heart,
                                                                      size: 23),
                                                                ),
                                                                const SizedBox(
                                                                    width: 10),
                                                                Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(15),
                                                                  decoration: BoxDecoration(
                                                                      border: _chatController.selectedChats[0].conversation[index].length > 2 &&
                                                                              _chatController.selectedChats[0].conversation[index].substring(_chatController.selectedChats[0].conversation[index].length - 2) ==
                                                                                  "**"
                                                                          ? Border.all(
                                                                              color: _chatController.boostedColors[_chatController
                                                                                  .colorIndexSelection],
                                                                              width:
                                                                                  1)
                                                                          : null,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade800,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              7.5)),
                                                                  constraints: const BoxConstraints(
                                                                      minWidth:
                                                                          100,
                                                                      maxWidth:
                                                                          300),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          const Text(
                                                                              "ChatS2",
                                                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff11a37f))),
                                                                          _chatController.selectedChats[0].conversation[index].length > 2 && _chatController.selectedChats[0].conversation[index].substring(_chatController.selectedChats[0].conversation[index].length - 2) == "**"
                                                                              ? const SizedBox(width: 2.5)
                                                                              : const SizedBox.shrink(),
                                                                          _chatController.selectedChats[0].conversation[index].length > 2 && _chatController.selectedChats[0].conversation[index].substring(_chatController.selectedChats[0].conversation[index].length - 2) == "**"
                                                                              ? Row(
                                                                                  children: [
                                                                                    Icon(Icons.star_border, color: Colors.grey.shade500, size: 11),
                                                                                    const SizedBox(width: 2.5),
                                                                                    Text("Boosted", style: TextStyle(fontSize: 10.5, fontStyle: FontStyle.italic, color: Colors.grey.shade500)),
                                                                                  ],
                                                                                )
                                                                              : const SizedBox.shrink()
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              5),
                                                                      Text(
                                                                          _chatController.selectedChats[0].conversation[index].length > 2 && _chatController.selectedChats[0].conversation[index].substring(_chatController.selectedChats[0].conversation[index].length - 2) == "**"
                                                                              ? _chatController.selectedChats[0].conversation[index].substring(0, _chatController.selectedChats[0].conversation[index].length - 2)
                                                                              : _chatController.selectedChats[0].conversation[index],
                                                                          style: const TextStyle(fontSize: 12)),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                    ],
                                                  );
                                                }
                                              }),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }(),
                              const SizedBox(
                                height: 10,
                              ),
                              (_chatController.chats.isEmpty ||
                                          _chatController
                                              .selectedChats.isEmpty) &&
                                      _chatController
                                              .isLoadingChatSelection.value ==
                                          false
                                  ? const SizedBox.shrink()
                                  : SizedBox(
                                      width: 700,
                                      child: Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.done,
                                            readOnly: (_chatController
                                                            .selectedChats
                                                            .isNotEmpty &&
                                                        _chatController
                                                                    .selectedChats[
                                                                        0]
                                                                    .conversation
                                                                    .length %
                                                                2 !=
                                                            0) ||
                                                    _chatController
                                                        .isLoadingChatMessage
                                                        .value ||
                                                    (_chatController
                                                            .selectedChats
                                                            .isNotEmpty &&
                                                        _chatController
                                                                .selectedChats[
                                                                    0]
                                                                .lastMessageFailed ==
                                                            true)
                                                ? true
                                                : false,
                                            onChanged: (value) =>
                                                setState(() {}),
                                            controller: _chatController
                                                .chatController.value,
                                            validator: (string) {
                                              if (string!.trim() == '') {
                                                return "You need to type something.";
                                              } else {
                                                return null;
                                              }
                                            },
                                            onFieldSubmitted: (string) async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                try {
                                                  final str = _chatController
                                                      .chatController
                                                      .value
                                                      .text;
                                                  _chatController
                                                      .chatController.value
                                                      .clear();
                                                  await _chatController
                                                      .sendChatMessage(
                                                          userInput: str.trim(),
                                                          chatId: _chatController
                                                              .selectedChats[0]
                                                              .id);
                                                } catch (e) {
                                                  Get.showSnackbar(GetSnackBar(
                                                    borderRadius: 7.5,
                                                    margin:
                                                        const EdgeInsets.only(
                                                      top: 15,
                                                    ),
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.6),
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    maxWidth: 350,
                                                    titleText: const Text(
                                                        "Oh oh...",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    messageText: const Text(
                                                        "Looks like you have already sent this message!",
                                                        style: TextStyle(
                                                            fontSize: 12)),
                                                    duration: const Duration(
                                                        seconds: 5),
                                                  ));
                                                }
                                              }
                                            },
                                            style:
                                                const TextStyle(fontSize: 12),
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey.shade800,
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade800),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.5)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors
                                                            .grey.shade800),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.5)),
                                                hintText:
                                                    "What do you want to know?",
                                                helperText: ' ',
                                                errorStyle: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.red),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7.5)),
                                                errorBorder: OutlineInputBorder(
                                                    borderSide: const BorderSide(
                                                        color: Colors.red),
                                                    borderRadius: BorderRadius.circular(7.5)),
                                                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                                suffixIcon: GestureDetector(
                                                  onTap: () async {},
                                                  child: const Icon(
                                                    Icons.send,
                                                    size: 15,
                                                  ),
                                                ),
                                                suffix: _chatController.isLoadingChatMessage.value ? const SizedBox(height: 15, width: 15, child: CircularProgressIndicator()) : const SizedBox.shrink()),
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(
                                    "ChatS2 uses OpenAI's GPT-3 model. ⓘ Boosted means ChatS2 had to consult an external API to achieve the final answer.",
                                    style: TextStyle(fontSize: 11),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          : const VerifyEmail()),
    );
  }
}
