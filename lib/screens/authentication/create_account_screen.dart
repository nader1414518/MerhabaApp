import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/providers/create_account_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createAccountProvider = Provider.of<CreateAccountProvider>(
      context,
    );

    return Scaffold(
      body: createAccountProvider.isLoading
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
                  label: "Enter your Full Name",
                  child: fluent.TextBox(
                    placeholder: 'Full Name',
                    expands: false,
                    controller: fullNameController,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                fluent.InfoLabel(
                  label: "Enter your Phone",
                  child: fluent.TextBox(
                    placeholder: 'Phone',
                    expands: false,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
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
                  height: 10,
                ),
                fluent.InfoLabel(
                  label: "Confirm your password",
                  child: fluent.TextBox(
                    placeholder: 'Confirm Password',
                    expands: false,
                    controller: confirmPassController,
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

                        if (confirmPassController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please confirm your password!!",
                          );
                          return;
                        }

                        if (confirmPassController.text != passController.text) {
                          Fluttertoast.showToast(
                            msg: "Passwords don't match!!",
                          );
                          return;
                        }

                        if (fullNameController.text == "") {
                          Fluttertoast.showToast(
                            msg: "Please enter your full name!!",
                          );
                          return;
                        }

                        createAccountProvider.toggleLoading();

                        try {
                          var res = await AuthController.createAccount(
                            {
                              "email":
                                  emailController.text.toLowerCase().trim(),
                              "password": passController.text,
                              "fullName": fullNameController.text,
                              "phone": phoneController.text,
                            },
                          );

                          if (res["result"] == true) {
                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(
                              msg: res["message"].toString(),
                            );
                          }
                        } catch (e) {
                          print(e.toString());
                        }

                        createAccountProvider.toggleLoading();
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.green,
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
