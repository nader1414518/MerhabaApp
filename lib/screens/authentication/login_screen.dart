import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:merhaba_app/utils/assets_utils.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passControlle = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
              controller: emailController,
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
                onPressed: () {},
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
        ],
      ),
    );
  }
}
