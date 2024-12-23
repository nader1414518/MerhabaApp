import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/providers/login_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(
      context,
    );

    return Scaffold(
      body: loginProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Image.asset(
                  AssetsUtils.appIconLight,
                  // width: (MediaQuery.sizeOf(context).width - 60) * 0.5,
                ),
                const SizedBox(
                  height: 40,
                ),
                fluent.InfoLabel(
                  label: "Enter your email",
                  child: fluent.TextBox(
                    placeholder: 'Email',
                    expands: false,
                    controller: emailController,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                fluent.InfoLabel(
                  label: "Enter your password",
                  child: fluent.TextBox(
                    placeholder: 'Password',
                    expands: false,
                    controller: passController,
                    obscureText: true,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        if (emailController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please enter your email!!",
                          );
                          return;
                        }

                        if (passController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please enter your password!!",
                          );
                          return;
                        }

                        loginProvider.toggleLoading();

                        try {
                          var res = await AuthController.login(
                            emailController.text,
                            passController.text,
                          );

                          if (res["result"] == true) {
                            Navigator.of(context).pushNamed("/home");
                          } else {
                            Fluttertoast.showToast(
                              msg: res["message"].toString(),
                            );
                          }
                        } catch (e) {
                          print(e.toString());
                        }

                        loginProvider.toggleLoading();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.green,
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/create_account");
                      },
                      child: const Text(
                        "Create Account",
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
