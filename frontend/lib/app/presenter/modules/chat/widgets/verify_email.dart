import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        const SizedBox(
          height: 20,
        ),
        const FaIcon(FontAwesomeIcons.solidIdBadge, size: 50),
        const SizedBox(
          height: 20,
        ),
        Container(
          alignment: Alignment.center,
          child:
              const Text("Verify your email", style: TextStyle(fontSize: 27.5)),
        ),
        const SizedBox(
          height: 20,
        ),
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
              try {
                if (Get.find<FirebaseAuth>().currentUser != null) {
                  await Get.find<FirebaseAuth>()
                      .currentUser!
                      .sendEmailVerification();
                }
                Get.showSnackbar(GetSnackBar(
                  borderRadius: 7.5,
                  margin: const EdgeInsets.only(
                    top: 15,
                  ),
                  backgroundColor: Colors.green.withOpacity(0.6),
                  snackPosition: SnackPosition.TOP,
                  maxWidth: 350,
                  titleText: const Text("Success",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  messageText: const Text(
                      "Email sent! Check your inbox and spam.",
                      style: TextStyle(fontSize: 12)),
                  duration: const Duration(seconds: 5),
                ));
              } catch (e) {
                Get.showSnackbar(GetSnackBar(
                  borderRadius: 7.5,
                  margin: const EdgeInsets.only(
                    top: 15,
                  ),
                  backgroundColor: Colors.red.withOpacity(0.6),
                  snackPosition: SnackPosition.TOP,
                  maxWidth: 350,
                  titleText: const Text("Oh oh...",
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  messageText: const Text(
                      "We had a problem sending the email. Try again.",
                      style: TextStyle(fontSize: 12)),
                  duration: const Duration(seconds: 5),
                ));
              }
            },
            child: const Text("Resend verification email",
                style: TextStyle(fontSize: 12, color: Color(0xff11a37f))),
          ),
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
        Container(
          alignment: Alignment.center,
          child: const Text("How to verify my email in the speed of light? 🤔",
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
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
                    """To verify your email address in the "speed of light", you can follow these steps:

1. Look for a verification link or code in the email sent to the address you provided. This link or code is typically sent when you sign up for a new account or request to change your email address.
2. Click on the link or enter the code in the verification process. This will confirm that you have access to the email address and it belongs to you.
3. Once you have completed the verification process, the email address will be considered verified and you can proceed with creating your account or making changes to your email address.

Note that, the speed of light is a constant, and can't be achieved, this is just a metaphorical term that means really fast.""",
                    speed: const Duration(milliseconds: 80)),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Spacer()
      ],
    );
  }
}
