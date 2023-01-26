import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class InitialChatWidget extends StatefulWidget {
  const InitialChatWidget({super.key});

  @override
  State<InitialChatWidget> createState() => _InitialChatWidgetState();
}

class _InitialChatWidgetState extends State<InitialChatWidget> {
  var quotes = [
    {
      "Define what is a good question for a Chatbot 🤔":
          """A good question for a chatbot is one that is clear, specific, and can be answered with a concise response. It should also be within the scope of the chatbot's capabilities and knowledge. For example, "What is the weather like today in New York City?" is a clear and specific question that can be answered with a concise response, while "What is the meaning of life?" is not a good question for a chatbot because it is not within its capabilities to answer.""",
    },
    {
      "What is the best football team in the world? 🌎":
          """According to my researchs, the best football team in the entire world is Cruzeiro Esporte Clube.""",
    },
    {
      "How much time should I wait to make a question? ⌛":
          "There is no specific time frame that you should wait before asking a question to me. You can ask a question whenever you have one. I am always here to help."
    }
  ].obs;

  var selectedQuote = {}.obs;

  @override
  initState() {
    selectedQuote.value = quotes[Random().nextInt(quotes.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxHeight > 400) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const SizedBox(
                height: 20,
              ),
              const FaIcon(FontAwesomeIcons.heart, size: 50),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text("ChatS2", style: TextStyle(fontSize: 27.5)),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(),
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  child: Text(selectedQuote.entries.toList()[0].key,
                      style: const TextStyle(
                          fontSize: 15.5, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Obx(
                () => Container(
                  width: 475,
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 13.0,
                        color: Colors.white,
                        fontFamily: "Trueno",
                        fontStyle: FontStyle.italic),
                    child: AnimatedTextKit(
                      totalRepeatCount: 1,
                      animatedTexts: [
                        TypewriterAnimatedText(
                            selectedQuote.entries.toList()[0].value,
                            speed: const Duration(milliseconds: 80)),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer()
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const SizedBox(
                height: 20,
              ),
              const FaIcon(FontAwesomeIcons.heart, size: 50),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text("ChatS2", style: TextStyle(fontSize: 27.5)),
              ),
              const Spacer(),
            ],
          );
        }
      }),
    );
  }
}
