import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'account_create_controller.dart';

class AccountCreatePage extends StatefulWidget {
  const AccountCreatePage({super.key});

  @override
  State<AccountCreatePage> createState() => _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {
  final _controller = Get.find<AccountCreateController>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Obx(
        () => Align(
          alignment: Alignment.center,
          child: Container(
            alignment: Alignment.center,
            width: 300,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(FontAwesomeIcons.layerGroup, size: 50),
                    const SizedBox(height: 30),
                    const Text("Create Account",
                        style: TextStyle(fontSize: 30)),
                    const SizedBox(height: 30),
                    TextFormField(
                      onChanged: (value) => setState(() {}),
                      controller: _controller.nameController.value,
                      validator: (string) {
                        if (string == '' || string == null) {
                          return "Required field.";
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
                          hintText: "Name",
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
                          prefixIcon: const Icon(Icons.perm_identity_outlined,
                              size: 14)),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      onChanged: (value) => setState(() {}),
                      controller: _controller.mailController.value,
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
                        } else if (_controller
                                    .passwordController.value.text.length <
                                6 ||
                            !_controller.regexPassword.hasMatch(
                                _controller.passwordController.value.text)) {
                          return "Password invalid.";
                        } else {
                          return null;
                        }
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: _controller.isLoading.value
                          ? (string) {}
                          : (string) async {
                              if (_formKey.currentState!.validate()) {
                                await _controller.createUserAndLogin();
                              }
                            },
                      obscureText: true,
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
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.75),
                          borderRadius: BorderRadius.circular(7.5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Your password must contain:",
                              style: TextStyle(
                                fontSize: 12,
                              )),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _controller.passwordController.value.text
                                          .length >=
                                      6
                                  ? const Icon(Icons.check,
                                      color: Color(0xff11a37f))
                                  : const Icon(Icons.close, color: Colors.red),
                              const SizedBox(width: 7.5),
                              Text("At least 6 characters",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: _controller.passwordController
                                                  .value.text.length >=
                                              6
                                          ? const Color(0xff11a37f)
                                          : Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              _controller.regexPassword.hasMatch(
                                      _controller.passwordController.value.text)
                                  ? const Icon(Icons.check,
                                      color: Color(0xff11a37f))
                                  : const Icon(Icons.close, color: Colors.red),
                              const SizedBox(width: 7.5),
                              Text("At least 1 uppercase",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: _controller.regexPassword.hasMatch(
                                              _controller.passwordController
                                                  .value.text)
                                          ? const Color(0xff11a37f)
                                          : Colors.red)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      minWidth: MediaQuery.of(context).size.width,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.5)),
                      padding: const EdgeInsets.all(20),
                      onPressed: _controller.isLoading.value
                          ? () {}
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                await _controller.createUserAndLogin();
                              }
                            },
                      color: const Color(0xff11a37f),
                      child: _controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Continue",
                              style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? ",
                            style: TextStyle(fontSize: 12)),
                        TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => Get.offAllNamed('/login'),
                            child: const Text("Sign in!",
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
