import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merhaba_app/controllers/single_chats_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;
import 'package:flutter_chat_types/flutter_chat_types.dart' as chat_types;
import 'package:merhaba_app/providers/chat_provider.dart';
import 'package:merhaba_app/utils/globals.dart';
import 'package:merhaba_app/widgets/chat/file_message.dart';
import 'package:merhaba_app/widgets/chat/video_message.dart';
import 'package:merhaba_app/widgets/chat/voice_message.dart';
import 'package:merhaba_app/widgets/chat/voice_recorder_widget.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

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
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          //   icon: const Icon(
          //     Icons.arrow_back_ios_new,
          //   ),
          // ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: chatProvider.otherUserData["photo_url"] == null
                    ? const AssetImage(
                        "assets/images/profile_avatar.png",
                      )
                    : CachedNetworkImageProvider(
                        chatProvider.otherUserData["photo_url"].toString(),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                chatProvider.otherUserData["full_name"].toString(),
                style: const TextStyle(
                  fontSize: 20,
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
            ],
          ),
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

                messages.sort(
                  (a, b) =>
                      DateTime.parse(b["date_added"].toString()).compareTo(
                    DateTime.parse(
                      a["date_added"].toString(),
                    ),
                  ),
                );

                print(messages.length);
              }
            } else {
              messages = [];
            }

            chatProvider.setMessages(messages);

            return Stack(
              children: [
                chat_ui.Chat(
                  messages: messages.map((message) {
                    Map<String, dynamic> parsedContent =
                        Map<String, dynamic>.from(
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
                    } else if (parsedContent["type"] == "image") {
                      return chat_types.ImageMessage(
                        author: chat_types.User(
                          id: message["user_id"].toString(),
                        ),
                        id: message["id"].toString(),
                        name: "",
                        size: 300,
                        uri: parsedContent["image"].toString(),
                      );
                    } else if (parsedContent["type"] == "video") {
                      return chat_types.CustomMessage(
                        author: chat_types.User(
                          id: message["user_id"].toString(),
                        ),
                        id: message["id"].toString(),
                        metadata: {
                          "type": "video",
                          "url": parsedContent["video"].toString(),
                        },
                      );
                    } else if (parsedContent["type"] == "file") {
                      return chat_types.CustomMessage(
                        author: chat_types.User(
                          id: message["user_id"].toString(),
                        ),
                        id: message["id"].toString(),
                        metadata: {
                          "type": "file",
                          "url": parsedContent["file"].toString(),
                          "filename": parsedContent["filename"].toString(),
                        },
                      );
                    } else if (parsedContent["type"] == "voice") {
                      return chat_types.CustomMessage(
                        author: chat_types.User(
                          id: message["user_id"].toString(),
                        ),
                        id: message["id"].toString(),
                        metadata: {
                          "type": "voice",
                          "url": parsedContent["voice"].toString(),
                          "filename": parsedContent["filename"].toString(),
                        },
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
                  onAttachmentPressed: () {
                    showDialog(
                      context: context,
                      builder: (_1) => fluent.ContentDialog(
                        title: Text(
                          AppLocale.choose_media_label.getString(
                            _1,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Material(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_2) => fluent.ContentDialog(
                                      title: Text(
                                        AppLocale.choose_source_label.getString(
                                          _2,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  Navigator.of(_2).pop();

                                                  await Future.delayed(
                                                    const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                  );

                                                  Navigator.of(_1).pop();

                                                  chatProvider
                                                      .setIsLoading(true);

                                                  try {
                                                    ImagePicker imagePicker =
                                                        ImagePicker();

                                                    var file = await imagePicker
                                                        .pickImage(
                                                      source:
                                                          ImageSource.gallery,
                                                      imageQuality: 50,
                                                    );

                                                    if (file != null) {
                                                      var res =
                                                          await SingleChatsController
                                                              .uploadChatPhoto(
                                                        chatProvider.chatId,
                                                        File(
                                                          file.path,
                                                        ),
                                                      );

                                                      if (res["result"] ==
                                                          false) {
                                                        Fluttertoast.showToast(
                                                          msg: res["message"]
                                                              .toString(),
                                                        );
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }

                                                  chatProvider
                                                      .setIsLoading(false);
                                                },
                                                label: Text(
                                                  AppLocale.gallery_label
                                                      .getString(
                                                    _2,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons.photo_library,
                                                  size: 18,
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  Navigator.of(_2).pop();

                                                  await Future.delayed(
                                                    const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                  );

                                                  Navigator.of(_1).pop();

                                                  chatProvider
                                                      .setIsLoading(true);

                                                  try {
                                                    ImagePicker imagePicker =
                                                        ImagePicker();

                                                    var file = await imagePicker
                                                        .pickImage(
                                                      source:
                                                          ImageSource.camera,
                                                      imageQuality: 50,
                                                    );

                                                    if (file != null) {
                                                      var res =
                                                          await SingleChatsController
                                                              .uploadChatPhoto(
                                                        chatProvider.chatId,
                                                        File(
                                                          file.path,
                                                        ),
                                                      );

                                                      if (res["result"] ==
                                                          false) {
                                                        Fluttertoast.showToast(
                                                          msg: res["message"]
                                                              .toString(),
                                                        );
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }

                                                  chatProvider
                                                      .setIsLoading(false);
                                                },
                                                label: Text(
                                                  AppLocale.camera_label
                                                      .getString(
                                                    _2,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons.camera,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(
                                      0.25,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.sizeOf(_1).width - 40) *
                                                0.6,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.photo,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppLocale.photo_label.getString(
                                                _1,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_2) => fluent.ContentDialog(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            AppLocale.choose_source_label
                                                .getString(
                                              _2,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  Navigator.of(_2).pop();

                                                  await Future.delayed(
                                                    const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                  );

                                                  Navigator.of(_1).pop();

                                                  chatProvider
                                                      .setIsLoading(true);

                                                  try {
                                                    ImagePicker imagePicker =
                                                        ImagePicker();

                                                    var file = await imagePicker
                                                        .pickVideo(
                                                      source:
                                                          ImageSource.gallery,
                                                    );

                                                    if (file != null) {
                                                      var res =
                                                          await SingleChatsController
                                                              .uploadChatVideo(
                                                        chatProvider.chatId,
                                                        File(
                                                          file.path,
                                                        ),
                                                      );

                                                      if (res["result"] ==
                                                          false) {
                                                        Fluttertoast.showToast(
                                                          msg: res["message"]
                                                              .toString(),
                                                        );
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }

                                                  chatProvider
                                                      .setIsLoading(false);
                                                },
                                                label: Text(
                                                  AppLocale.gallery_label
                                                      .getString(
                                                    _2,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons.photo_library,
                                                  size: 18,
                                                ),
                                              ),
                                              ElevatedButton.icon(
                                                onPressed: () async {
                                                  Navigator.of(_2).pop();

                                                  await Future.delayed(
                                                    const Duration(
                                                      milliseconds: 200,
                                                    ),
                                                  );

                                                  Navigator.of(_1).pop();

                                                  chatProvider
                                                      .setIsLoading(true);

                                                  try {
                                                    ImagePicker imagePicker =
                                                        ImagePicker();

                                                    var file = await imagePicker
                                                        .pickVideo(
                                                      source:
                                                          ImageSource.camera,
                                                    );

                                                    if (file != null) {
                                                      var res =
                                                          await SingleChatsController
                                                              .uploadChatVideo(
                                                        chatProvider.chatId,
                                                        File(
                                                          file.path,
                                                        ),
                                                      );

                                                      if (res["result"] ==
                                                          false) {
                                                        Fluttertoast.showToast(
                                                          msg: res["message"]
                                                              .toString(),
                                                        );
                                                      }
                                                    }
                                                  } catch (e) {
                                                    print(e.toString());
                                                  }

                                                  chatProvider
                                                      .setIsLoading(false);
                                                },
                                                label: Text(
                                                  AppLocale.camera_label
                                                      .getString(
                                                    _2,
                                                  ),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                icon: const Icon(
                                                  Icons.camera,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(
                                      0.25,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.sizeOf(_1).width - 40) *
                                                0.6,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.video_call,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppLocale.video_label.getString(
                                                _1,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.of(_1).pop();

                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles();

                                  if (result != null) {
                                    chatProvider.setIsLoading(true);

                                    try {
                                      File file =
                                          File(result.files.single.path!);

                                      var res = await SingleChatsController
                                          .uploadChatFile(
                                        chatProvider.chatId,
                                        file,
                                      );

                                      if (res["result"] == false) {
                                        Fluttertoast.showToast(
                                          msg: res["message"].toString(),
                                        );
                                      }
                                    } catch (e) {
                                      print(e.toString());
                                    }

                                    chatProvider.setIsLoading(false);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.withOpacity(
                                      0.25,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            (MediaQuery.sizeOf(_1).width - 40) *
                                                0.6,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.attachment,
                                              size: 20,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              AppLocale.attchment_label
                                                  .getString(
                                                _1,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  onMessageTap: (_, msg) {},
                  onSendPressed: (partialText) {
                    chatProvider.onSendMessage(
                      context,
                      partialText.text,
                    );
                  },
                  inputOptions: chat_ui.InputOptions(
                    sendButtonVisibilityMode:
                        chat_ui.SendButtonVisibilityMode.always,
                    onTextChanged: (text) {
                      chatProvider.setIsInputEmpty(text.isEmpty);
                    },
                  ),
                  customMessageBuilder: (p0, {required messageWidth}) {
                    if (p0.metadata!["type"] == "video") {
                      return VideoMessage(
                        url: p0.metadata!["url"],
                      );
                    } else if (p0.metadata!["type"] == "file") {
                      return FileMessage(
                        url: p0.metadata!["url"],
                        filename: p0.metadata!["filename"],
                      );
                    } else if (p0.metadata!["type"] == "voice") {
                      return VoiceMessage(
                        url: p0.metadata!["url"],
                        filename: p0.metadata!["filename"],
                      );
                    }

                    return Container();
                  },
                  showUserAvatars: true,
                  showUserNames: true,
                  user: chat_types.User(
                    id: Supabase.instance.client.auth.currentUser!.id,
                  ),
                  theme: Globals.theme == "Dark"
                      ? chat_ui.DarkChatTheme(
                          sendButtonIcon: chatProvider.isInputEmpty
                              ? InkWell(
                                  onTap: () {
                                    chatProvider.toggleVoiceRecorderOpen();
                                  },
                                  child: Icon(
                                    Icons.mic,
                                    color: chatProvider.isVoiceRecorderOpen
                                        ? Colors.blue
                                        : Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                  size: 30,
                                ),
                        )
                      : chat_ui.DefaultChatTheme(
                          sendButtonIcon: chatProvider.isInputEmpty
                              ? InkWell(
                                  onTap: () {
                                    chatProvider.toggleVoiceRecorderOpen();
                                  },
                                  child: Icon(
                                    Icons.mic,
                                    color: chatProvider.isVoiceRecorderOpen
                                        ? Colors.blue
                                        : Colors.white,
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                ),
                        ),
                ),
                if (chatProvider.isVoiceRecorderOpen)
                  const Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: VoiceRecorderWidget(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
