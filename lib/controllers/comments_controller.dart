import 'dart:io';

import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as p;

class CommentsController {
  // Add Comment
  static Future<Map<String, dynamic>> addComment(
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

      var currentUserDataRes = await AuthController.getCurrentUserData();

      if (currentUserDataRes["result"] == false) {
        return currentUserDataRes;
      }

      Map<String, dynamic> currentUserData = Map<String, dynamic>.from(
        currentUserDataRes["data"] as Map,
      );

      var userData = currentUserData["user_metadata"];
      var username = userData["fullName"].toString();
      var photoUrl =
          userData["picUrl"] == null ? "" : userData["picUrl"].toString();

      Map<String, dynamic> formData = {
        "user_id": uid,
        "added_by": uid,
        "updated_by": "",
        "date_added": DateTime.now().toIso8601String(),
        "date_updated": "",
        "active": true,
        "username": username,
        "user_photo": photoUrl,
        "reply_to": -1,
        ...data,
      };

      await Supabase.instance.client.from("post_comments").insert(formData);

      return {
        "result": true,
        "message": "Uploaded successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  // Get Comments (For Post)
  static Future<List<Map<String, dynamic>>> getCommentsForPost(
    int postId,
  ) async {
    try {
      var res = await Supabase.instance.client
          .from("post_comments")
          .select()
          .eq("post_id", postId)
          .eq("active", true);

      return res;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get Comments Count (For Post)
  static Future<int> getCommentsCountForPost(
    int postId,
  ) async {
    try {
      var res = await Supabase.instance.client
          .from("post_comments")
          .select()
          .eq("post_id", postId)
          .eq("active", true)
          .count();

      return res.count;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  // Reply to Comment
  static Future<Map<String, dynamic>> replyToComment(
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

      var currentUserDataRes = await AuthController.getCurrentUserData();

      if (currentUserDataRes["result"] == false) {
        return currentUserDataRes;
      }

      Map<String, dynamic> currentUserData = Map<String, dynamic>.from(
        currentUserDataRes["data"] as Map,
      );

      var userData = currentUserData["user_metadata"];
      var username = userData["fullName"].toString();
      var photoUrl =
          userData["picUrl"] == null ? "" : userData["picUrl"].toString();

      Map<String, dynamic> formData = {
        "user_id": uid,
        "added_by": uid,
        "updated_by": "",
        "date_added": DateTime.now().toIso8601String(),
        "date_updated": "",
        "active": true,
        "username": username,
        "user_photo": photoUrl,
        ...data,
      };

      await Supabase.instance.client.from("post_comments").insert(formData);

      return {
        "result": true,
        "message": "Uploaded successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  // Get Comment Replies
  static Future<List<Map<String, dynamic>>> getCommentReplies(
    int commentId,
  ) async {
    try {
      var res = await Supabase.instance.client
          .from("post_comments")
          .select()
          .eq("reply_to", commentId)
          .eq("active", true);

      return res;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Upload Comment Image
  static Future<Map<String, dynamic>> uploadCommentImage(File file) async {
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('comments')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from("comments")
          .getPublicUrl(filename);

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

  // Upload Comment Video
  static Future<Map<String, dynamic>> uploadCommentVideo(File file) async {
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('comments')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from("comments")
          .getPublicUrl(filename);

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

  // Upload Comment Voice
  static Future<Map<String, dynamic>> uploadCommentVoice(File file) async {
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('comments')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = Supabase.instance.client.storage
          .from("comments")
          .getPublicUrl(filename);

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
