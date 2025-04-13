import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:merhaba_app/providers/chat_provider.dart';
import 'package:merhaba_app/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(
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
            AppLocale.chat_label.getString(
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
        body: StreamBuilder(
          stream: Supabase.instance.client
              .from("single_chat_messages")
              .stream(primaryKey: ['id']).eq('chat_id', chatProvider.chatId),
          builder: (context, snapshot) {
            List<Map<String, dynamic>> messages = [];
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                messages = snapshot.data!;
              }
            }

            chatProvider.setMessages(messages);

            return chat_ui.Chat(
              messages: messages.map((message) {
                Map<String, dynamic> parsedContent = Map<String, dynamic>.from(
                  jsonDecode(message["content"].toString()) as Map,
                );

                if (parsedContent["type"] == "text") {
                  return chat_types.TextMessage(
                    author: chat_types.User(
                      id: message["user_id"].toString(),
                    ),
                    id: message["id"].toString(),
                    text: parsedContent["text"].toString(),
                  );
                }

                return chat_types.TextMessage(
                  author: chat_types.User(
                    id: message["user_id"].toString(),
                  ),
                  id: message["id"].toString(),
                  text: "Invalid message",
                );
              }).toList(),
              onAttachmentPressed: () {},
              onMessageTap: (_, msg) {},
              onSendPressed: (partialText) {
                chatProvider.onSendMessage(
                  context,
                  partialText.text,
                );
              },
              showUserAvatars: true,
              showUserNames: true,
              user: chat_types.User(
                id: Supabase.instance.client.auth.currentUser!.id,
              ),
              theme: Globals.theme == "Dark"
                  ? chat_ui.DarkChatTheme()
                  : chat_ui.DefaultChatTheme(),
            );
          },
        ),
        // body: chat_ui.Chat(
        //   messages: [],
        //   onAttachmentPressed: () {},
        //   onMessageTap: (_, msg) {},
        //   onSendPressed: (partialText) {
        //     chatProvider.onSendMessage(
        //       context,
        //       partialText.text,
        //     );
        //   },
        //   showUserAvatars: true,
        //   showUserNames: true,
        //   user: chat_types.User(
        //     id: Supabase.instance.client.auth.currentUser!.id,
        //   ),
        //   theme: Globals.theme == "Dark"
        //       ? chat_ui.DarkChatTheme()
        //       : chat_ui.DefaultChatTheme(),
        // ),
      ),
    );
  }
}
