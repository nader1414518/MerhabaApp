import 'dart:io';

import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/main.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:video_player/video_player.dart';

class ReelsController {
  static Future<Map<String, dynamic>> uploadReel(
    File file,
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

      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('reels')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl =
          Supabase.instance.client.storage.from("reels").getPublicUrl(filename);

      VideoPlayerController controller =
          VideoPlayerController.networkUrl(Uri.parse(publicUrl));

      await controller.initialize();

      int duration = controller.value.duration.inSeconds;

      await Supabase.instance.client.from("reels").insert({
        "user_id": uid,
        "user_photo": photoUrl,
        "user_name": username,
        "reel_url": publicUrl,
        "duration": duration,
        "active": true,
        "date_added": DateTime.now().toIso8601String(),
        "date_updated": DateTime.now().toIso8601String(),
        "added_by": uid,
        "updated_by": "",
      });

      return {
        "result": true,
        "message": "Reel uploaded successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        'result': false,
        'message': e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getReels() async {
    try {
      var res = await Supabase.instance.client
          .from("reels")
          .select()
          .eq("active", true);

      return res.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getReelsForUser(
      String userId) async {
    try {
      var res = await Supabase.instance.client
          .from("reels")
          .select()
          .eq("user_id", userId)
          .eq("active", true);

      return res.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getReelsForCurrentUser() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var res = await Supabase.instance.client
          .from("reels")
          .select()
          .eq("user_id", uid)
          .eq("active", true)
          .order("date_added", ascending: false);

      return res.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Map<String, dynamic>> deleteReel(int reelId) async {
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

      var res = await Supabase.instance.client
          .from("reels")
          .select()
          .eq("id", reelId)
          .eq("active", true);

      if (res.isEmpty) {
        return {
          "result": false,
          "message": "Reel not found!!",
        };
      }

      await Supabase.instance.client.from("reels").update({
        "active": false,
        "date_updated": DateTime.now().toIso8601String(),
        "updated_by": uid,
      }).eq("id", reelId);

      return {
        "result": true,
        "message": "Reel deleted successfully ... ",
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
