import 'package:supabase_flutter/supabase_flutter.dart';

class PublicProfileController {
  static Future<Map<String, dynamic>> getPublicProfile(String uid) async {
    try {
      var res = await Supabase.instance.client.from("users").select().eq(
            "user_id",
            uid,
          );

      if (res.isEmpty) {
        return {
          "result": false,
          "message": "User not found",
        };
      }

      return {
        "result": true,
        "message": "Retrieved successfully ... ",
        "data": res[0],
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
