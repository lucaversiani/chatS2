import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _controller = Get.find<LoginController>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Obx(
        () => Align(
          alignment: Alignment.center,
          child: Form(
            key: _formKey,
            child: Container(
              alignment: Alignment.center,
              width: 300,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.heart, size: 50),
                    const SizedBox(height: 30),
                    const Text("Welcome Back", style: TextStyle(fontSize: 30)),
                    const SizedBox(height: 45),
                    TextFormField(
                      onChanged: (value) => setState(() {}),
                      controller: _controller.emailController.value,
                      validator: (string) {
                        if (string == '' || string == null) {
                          return "Required field.";
                        } else if (!GetUtils.isEmail(string)) {
                          return "Invalid email.";
                        } else {
                          return null;
                        }
                      },
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(7.5)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(7.5)),
                          hintText: "Email",
                          helperText: ' ',
                          errorStyle:
                              const TextStyle(fontSize: 12, color: Colors.red),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.5)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.5)),
                          hintStyle: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                          prefixIcon:
                              const Icon(Icons.email_outlined, size: 14)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) => setState(() {}),
                      controller: _controller.passwordController.value,
                      validator: (string) {
                        if (string == '' || string == null) {
                          return "Required field.";
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      onFieldSubmitted: _controller.isLoading.value == false
                          ? (string) async {
                              if (_formKey.currentState!.validate()) {
                                await _controller.loginWithMail();
                              }
                            }
                          : (string) {},
                      textInputAction: TextInputAction.done,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade800,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(7.5)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade800),
                              borderRadius: BorderRadius.circular(7.5)),
                          hintText: "Password",
                          helperText: ' ',
                          errorStyle:
                              const TextStyle(fontSize: 12, color: Colors.red),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.5)),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(7.5)),
                          hintStyle: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                          prefixIcon:
                              const Icon(Icons.password_outlined, size: 14)),
                    ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5)),
                      padding: const EdgeInsets.all(20),
                      onPressed: _controller.isLoading.value
                          ? () {}
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await _controller.loginWithMail();
                              }
                            },
                      color: const Color(0xff11a37f),
                      child: _controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Sign in",
                              style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? ",
                            style: TextStyle(fontSize: 12)),
                        TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => Get.offAllNamed('/account-create'),
                            child: const Text("Sign up!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff11a37f),
                                    fontSize: 12)))
                      ],
                    ),
                    const SizedBox(height: 7.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Forgot your password? ",
                            style: TextStyle(fontSize: 12)),
                        TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () =>
                                Get.offAllNamed('/forgot-password'),
                            child: const Text("Click here!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff11a37f),
                                    fontSize: 12)))
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
