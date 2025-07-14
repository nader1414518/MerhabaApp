import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:merhaba_app/controllers/friends_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/post_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class SingleChatsController {
  static Future<Map<String, dynamic>> startChat(
    Map<String, dynamic> data, // {message, user_id}
  ) async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      Map<String, dynamic> chatData = {
        "user1_id": uid,
        "user2_id": data["user_id"],
        "active": true,
        "added_by": uid,
        "date_added": DateTime.now().toIso8601String(),
      };

      var chatRes = await Supabase.instance.client
          .from("single_chats")
          .insert(chatData)
          .select('id');

      var chatId = num.parse(chatRes.first["id"].toString()).toInt();

      await Supabase.instance.client.from("single_chat_messages").insert({
        "chat_id": chatId,
        "user_id": uid,
        "content": jsonEncode({
          "text": data["message"].toString(),
          "type": "text",
        }),
        "active": true,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
      });

      return {
        "result": true,
        "message": "Added successfully ... ",
        "chatId": chatId,
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  // data => {chatId, message}
  static Future<Map<String, dynamic>> onSendMessage(
    Map<String, dynamic> data,
  ) async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      await Supabase.instance.client.from("single_chat_messages").insert({
        "chat_id": data["chatId"],
        "user_id": uid,
        "content": jsonEncode({
          "text": data["message"].toString(),
          "type": "text",
        }),
        "active": true,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
      });

      return {
        "result": true,
        "message": "Sent successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getMyChats() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var user1Res = await Supabase.instance.client
          .from("single_chats")
          .select()
          .eq("user1_id", uid);

      var user2Res = await Supabase.instance.client
          .from("single_chats")
          .select()
          .eq("user2_id", uid);

      var blockedUsers = await FriendsController.getBlockList();

      return [
        ...user1Res.where(
          (element) => !blockedUsers.any(
            (blockedUser) => blockedUser["user_id"] == element["user2_id"],
          ),
        ),
        ...user2Res.where(
          (element) => !blockedUsers.any(
            (blockedUser) => blockedUser["user_id"] == element["user1_id"],
          ),
        ),
      ];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Map<String, dynamic>> getChatData(int chatId) async {
    try {
      var res = await Supabase.instance.client
          .from("single_chats")
          .select()
          .eq("id", chatId);

      if (res.isEmpty) {
        return {
          "result": false,
          "message": "Chat not found!!",
        };
      }

      return {
        "result": true,
        "message": "Retrieved successfully ... ",
        "data": res.first,
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getChatUserInfo(
    int id,
    BuildContext context,
  ) async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      var chatDataRes = await getChatData(id);
      if (chatDataRes["result"] == false) {
        return chatDataRes;
      }

      Map<String, dynamic> chatData = Map<String, dynamic>.from(
        chatDataRes["data"] as Map,
      );

      String otherUserId = chatData["user1_id"].toString();
      if (otherUserId == uid) {
        otherUserId = chatData["user2_id"].toString();
      }

      var userDataRes = await Supabase.instance.client
          .from("users")
          .select()
          .eq("user_id", otherUserId);

      Map<String, dynamic> userData = {};
      if (userDataRes.isNotEmpty) {
        userData = userDataRes.first;
      }

      var messages = await getMessages(id);

      // print(messages.last);

      var parsedLastMessage = jsonDecode(messages.last["content"].toString());

      return {
        "result": true,
        "message": "Retrieved successfully",
        "userData": userData,
        "lastMessage": parsedLastMessage["type"] == "text"
            ? parsedLastMessage["text"].toString()
            : parsedLastMessage["type"] == "image"
                ? "👾 ${AppLocale.image_label.getString(
                    context,
                  )}"
                : parsedLastMessage["type"] == "video"
                    ? "📹 ${AppLocale.video_label.getString(
                        context,
                      )}"
                    : parsedLastMessage["type"] == "file"
                        ? "🗄️ ${AppLocale.attchment_label.getString(
                            context,
                          )}"
                        : parsedLastMessage["type"] == "voice"
                            ? "🔊 ${AppLocale.voice_label.getString(
                                context,
                              )}"
                            : "",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getMessages(int chatId) async {
    try {
      var res = await Supabase.instance.client
          .from("single_chat_messages")
          .select()
          .eq("chat_id", chatId)
          .order("date_added", ascending: true);

      return res;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> searchContacts(String query) async {
    try {
      var emailMatched = await Supabase.instance.client
          .from("users")
          .select()
          .eq("email", query.toLowerCase().trim());
      var fullNameMatched = await Supabase.instance.client
          .from("users")
          .select()
          .eq("full_name", query.toLowerCase().trim());
      var phoneMatched = await Supabase.instance.client
          .from("users")
          .select()
          .eq("phone", query.toLowerCase().trim());

      return [
        ...emailMatched,
        ...fullNameMatched,
        ...phoneMatched,
      ];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Map<String, dynamic>> uploadChatPhoto(
      int chatId, File file) async {
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('singlechats')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from("singlechats")
          .getPublicUrl(filename);

      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      await Supabase.instance.client.from("single_chat_messages").insert({
        "chat_id": chatId,
        "user_id": uid,
        "content": jsonEncode({
          "image": publicUrl,
          "type": "image",
        }),
        "active": true,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
      });

      return {
        "result": true,
        "message": "Uploaded successfully ... ",
        "url": publicUrl,
        "filename": filename,
        "fullPath": fullPath,
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> uploadChatVideo(
      int chatId, File file) async {
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('singlechats')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from("singlechats")
          .getPublicUrl(filename);

      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      await Supabase.instance.client.from("single_chat_messages").insert({
        "chat_id": chatId,
        "user_id": uid,
        "content": jsonEncode({
          "video": publicUrl,
          "type": "video",
        }),
        "active": true,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
      });

      return {
        "result": true,
        "message": "Uploaded successfully ... ",
        "url": publicUrl,
        "filename": filename,
        "fullPath": fullPath,
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> uploadChatFile(
      int chatId, File file) async {
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('singlechats')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from("singlechats")
          .getPublicUrl(filename);

      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      await Supabase.instance.client.from("single_chat_messages").insert({
        "chat_id": chatId,
        "user_id": uid,
        "content": jsonEncode({
          "file": publicUrl,
          "type": "file",
          "filename": filename,
        }),
        "active": true,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
      });

      return {
        "result": true,
        "message": "Uploaded successfully ... ",
        "url": publicUrl,
        "filename": filename,
        "fullPath": fullPath,
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> uploadChatAudio(
    int chatId,
    File file,
  ) async {
    print("Sending audio to server");
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('singlechats')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from("singlechats")
          .getPublicUrl(filename);

      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return {
          "result": false,
          "message": "Please login again!!",
        };
      }

      await Supabase.instance.client.from("single_chat_messages").insert({
        "chat_id": chatId,
        "user_id": uid,
        "content": jsonEncode({
          "voice": publicUrl,
          "type": "voice",
          "filename": filename,
        }),
        "active": true,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
      });

      return {
        "result": true,
        "message": "Uploaded successfully ... ",
        "url": publicUrl,
        "filename": filename,
        "fullPath": fullPath,
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }
}
