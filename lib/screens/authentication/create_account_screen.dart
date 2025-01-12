import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/create_account_provider.dart';
import 'package:merhaba_app/utils/assets_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localization/flutter_localization.dart';

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

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
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
                    label: AppLocale.enter_your_email_label.getString(
                      context,
                    ),
                    child: fluent.TextBox(
                      placeholder: AppLocale.email_label.getString(
                        context,
                      ),
                      expands: false,
                      controller: emailController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fluent.InfoLabel(
                    label: AppLocale.enter_your_fullname_label.getString(
                      context,
                    ),
                    child: fluent.TextBox(
                      placeholder:
                          AppLocale.enter_your_fullname_label.getString(
                        context,
                      ),
                      expands: false,
                      controller: fullNameController,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fluent.InfoLabel(
                    label: AppLocale.enter_your_phone_label.getString(
                      context,
                    ),
                    child: fluent.TextBox(
                      placeholder: AppLocale.enter_your_phone_label.getString(
                        context,
                      ),
                      expands: false,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fluent.InfoLabel(
                    label: AppLocale.enter_your_password_label.getString(
                      context,
                    ),
                    child: fluent.TextBox(
                      placeholder:
                          AppLocale.enter_your_password_label.getString(
                        context,
                      ),
                      expands: false,
                      controller: passController,
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  fluent.InfoLabel(
                    label: AppLocale.confirm_your_password_label.getString(
                      context,
                    ),
                    child: fluent.TextBox(
                      placeholder:
                          AppLocale.confirm_your_password_label.getString(
                        context,
                      ),
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

                          if (confirmPassController.text !=
                              passController.text) {
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
                        child: Text(
                          AppLocale.signup_label.getString(
                            context,
                          ),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
