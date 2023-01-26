import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../chat_controller.dart';

class WaitingChatWidget extends StatefulWidget {
  const WaitingChatWidget({super.key});

  @override
  State<WaitingChatWidget> createState() => _WaitingChatWidgetState();
}

class _WaitingChatWidgetState extends State<WaitingChatWidget> {
  final _chatController = Get.find<ChatController>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FaIcon(FontAwesomeIcons.solidMoon, size: 40),
          const SizedBox(height: 15),
          const Text("Wow! It's so quiet here...",
              style: TextStyle(fontSize: 20)),
          const SizedBox(height: 15),
          const Text("Select or create a new chat!"),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xff11a37f),
                ),
                borderRadius: BorderRadius.circular(7.5)),
            child: MaterialButton(
              padding: const EdgeInsets.all(20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7.5)),
              onPressed: () async {
                if (_chatController.chats.length < 5) {
                  _chatController.isLoadingChatCreation.value = true;
                  await _chatController.createNewChat();
                  _chatController.isLoadingChatCreation.value = false;
                } else {
                  Get.showSnackbar(GetSnackBar(
                    borderRadius: 7.5,
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    backgroundColor: Colors.red.withOpacity(0.6),
                    snackPosition: SnackPosition.TOP,
                    maxWidth: 350,
                    titleText: const Text("Not allowed",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold)),
                    messageText: const Text(
                        "You can only create up to 5 chats. Delete one.",
                        style: TextStyle(fontSize: 12)),
                    duration: const Duration(seconds: 5),
                  ));
                }
              },
              child: const Text("Create a Chat",
                  style: TextStyle(fontSize: 12, color: Color(0xff11a37f))),
            ),
          ),
        ],
      ),
    );
  }
}
