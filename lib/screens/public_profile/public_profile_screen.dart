import 'package:flutter/material.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/public_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

class PublicProfileScreen extends StatelessWidget {
  const PublicProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final publicProfileProvider = Provider.of<PublicProfileProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocale.user_profile_label.getString(
                context,
              ),
            ),
          ),
          body: publicProfileProvider.isLoading
              ? const Center(
                  child: fluent.ProgressBar(),
                )
              : Container(),
        ),
      ),
    );
  }
}
