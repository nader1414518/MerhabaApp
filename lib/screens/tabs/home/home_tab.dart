import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/providers/profile_tab_provider.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocale.home_label.getString(
              context,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  color: Colors.grey.withOpacity(
                    0.05,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width - 60) * 0.6,
                          child: Text(
                            AppLocale.whats_on_your_mind_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.photo,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              onTap: () async {
                // Go to post screen
                final profileTabProvider = Provider.of<ProfileTabProvider>(
                  context,
                  listen: false,
                );

                await profileTabProvider.getData();

                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pushNamed("/new_post");
              },
            ),
          ],
        ),
      ),
    );
  }
}
