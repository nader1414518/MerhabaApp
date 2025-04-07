import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:merhaba_app/providers/contact_search_provider.dart';
import 'package:provider/provider.dart';

class ContactSearchScreen extends StatelessWidget {
  const ContactSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactSearchProvider = Provider.of<ContactSearchProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            AppLocale.search_label.getString(
              context,
            ),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .shimmer(duration: 3000.ms, color: const Color(0xFF80DDFF))
              .animate(
                  // onPlay: (controller) => controller.repeat(),
                  ) // this wraps the previous Animate in another Animate
              .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
              .slide(),
        ),
        body: contactSearchProvider.isLoading
            ? const Center(
                child: fluent.ProgressBar(),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [],
              ),
      ),
    );
  }
}
