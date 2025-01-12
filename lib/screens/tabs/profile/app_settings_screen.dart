import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/app_settings_provider.dart';
import 'package:provider/provider.dart';

class AppSettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettingsProvider = Provider.of<AppSettingsProvider>(
      context,
    );

    return Directionality(
      textDirection: localization.currentLocale.localeIdentifier == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocale.app_settings_label.getString(
              context,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 60) * 0.45,
                  child: Text(
                    AppLocale.language_label.getString(
                      context,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ComboBox<String>(
                  value: appSettingsProvider.currentLanguage,
                  items: ["English", "العربية"].map((e) {
                    return ComboBoxItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    appSettingsProvider.updateCurrentLanguage(
                      value,
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (MediaQuery.sizeOf(context).width - 60) * 0.45,
                  child: Text(
                    AppLocale.dark_mode_label.getString(
                      context,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: CupertinoSwitch(
                    value: appSettingsProvider
                        .isDark, // Boolean value indicating the current state of the switch
                    onChanged: (bool value) {
                      appSettingsProvider.updateDarkMode(value, context);
                    },
                    activeColor: CupertinoColors
                        .activeGreen, // Color when the switch is ON
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
