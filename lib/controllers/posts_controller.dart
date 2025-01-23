import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:supabase_flutter/supabase_flutter.dart';

class PostsController {
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
