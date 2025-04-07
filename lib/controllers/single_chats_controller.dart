import 'dart:convert';

import 'package:merhaba_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
}
