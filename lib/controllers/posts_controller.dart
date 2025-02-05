import 'dart:io';
import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/main.dart';
import 'package:path/path.dart' as p;

import 'package:supabase_flutter/supabase_flutter.dart';

class PostsController {
  static Future<Map<String, dynamic>> addPost(Map<String, dynamic> data) async {
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

      data["user_id"] = uid;
      data["added_by"] = uid;
      data["updated_by"] = "";
      data["date_added"] = DateTime.now().toIso8601String();
      data["date_updated"] = DateTime.now().toIso8601String();

      await Supabase.instance.client.from("posts").insert(
            data,
          );

      return {
        "result": true,
        "message": "Posted successfully ... ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> uploadPostMedia(File file) async {
    try {
      String filename =
          "${DateTime.now().toIso8601String().replaceAll(" ", "").replaceAll(".", "").replaceAll(":", "")}_${p.basename(file.path).replaceAll(" ", "")}";

      final String fullPath = await Supabase.instance.client.storage
          .from('Posts')
          .upload(
            filename,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl =
          Supabase.instance.client.storage.from("Posts").getPublicUrl(filename);

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
