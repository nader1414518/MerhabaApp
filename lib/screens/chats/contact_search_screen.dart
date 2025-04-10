import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:merhaba_app/controllers/single_chats_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:merhaba_app/providers/chat_provider.dart';
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
                children: [
                  TypeAheadField<Map<String, dynamic>>(
                    suggestionsCallback: (search) =>
                        SingleChatsController.searchContacts(
                      search,
                    ),
                    builder: (context, controller, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          labelText: AppLocale.contact_label.getString(
                            context,
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, contact) {
                      return ListTile(
                        title: Text(
                          contact["full_name"].toString(),
                        ),
                        subtitle: Text(
                          contact["email"].toString(),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            final chatProvider = Provider.of<ChatProvider>(
                              context,
                              listen: false,
                            );

                            chatProvider.setOtherUserId(
                              contact["user_id"].toString(),
                            );

                            chatProvider.getData();

                            Navigator.of(context).pushNamed(
                              "/chat",
                            );
                          },
                          style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.blue,
                            ),
                            foregroundColor: WidgetStatePropertyAll(
                              Colors.white,
                            ),
                            visualDensity: VisualDensity.compact,
                            elevation: WidgetStatePropertyAll(
                              3,
                            ),
                          ),
                          child: Text(
                            AppLocale.start_chat_label.getString(
                              context,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (contact) {
                      // Navigator.of(context).pushNamed(
                      //   "/chat",
                      // );

                      // TODO: go to user profile
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
