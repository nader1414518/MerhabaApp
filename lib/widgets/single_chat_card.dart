import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/controllers/single_chats_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/providers/chat_provider.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:provider/provider.dart';

class SingleChatCard extends StatefulWidget {
  Map<String, dynamic> chat = {};
  SingleChatCard({super.key, required this.chat});

  @override
  _SingleChatCardState createState() => _SingleChatCardState();
}

class _SingleChatCardState extends State<SingleChatCard> {
  Map<String, dynamic> otherUserData = {};
  String lastMessage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  Future<void> getData() async {
    try {
      var res = await SingleChatsController.getChatUserInfo(
        widget.chat["id"],
        context,
      );

      if (res["result"] == true) {
        setState(() {
          otherUserData = Map<String, dynamic>.from(
            res["userData"] as Map,
          );

          // print(otherUserData);

          lastMessage = res["lastMessage"].toString();
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          final chatProvider = Provider.of<ChatProvider>(
            context,
            listen: false,
          );

          chatProvider.setChatId(
            widget.chat["id"],
          );

          chatProvider.getData();

          Navigator.of(context).pushNamed(
            "/chat",
          );
        },
        leading: CircleAvatar(
          backgroundImage: otherUserData["photo_url"] == null
              ? const AssetImage(
                  "assets/images/profile_avatar.png",
                )
              : CachedNetworkImageProvider(
                  otherUserData["photo_url"].toString(),
                ),
        ),
        title: Text(
          otherUserData.isEmpty
              ? AppLocale.loading_label.getString(
                  context,
                )
              : otherUserData["full_name"].toString(),
        ),
        subtitle: Text(
          lastMessage,
        ),
      ),
    );
  }
}
