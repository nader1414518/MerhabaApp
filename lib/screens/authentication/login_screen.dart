import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:merhaba_app/providers/login_provider.dart';
import 'package:merhaba_app/providers/timeline_provider.dart';
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

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
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
                    label: AppLocale.enter_your_password_label.getString(
                      context,
                    ),
                    child: fluent.TextBox(
                      placeholder: AppLocale.password_label.getString(
                        context,
                      ),
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
                              final timelineProvider =
                                  Provider.of<TimelineProvider>(
                                context,
                              );

                              timelineProvider.getData();

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
                        child: Text(
                          AppLocale.login_label.getString(
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
                        child: Text(
                          AppLocale.create_account_label.getString(
                            context,
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
