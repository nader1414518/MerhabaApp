import 'package:merhaba_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UsersController {
  static Future<Map<String, dynamic>> updateUserProfilePicture(
      String url) async {
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

      await Supabase.instance.client.from("users").update({
        "photo_url": url,
      }).eq("user_id", uid);

      return {
        "result": true,
        "message": "Updated successfully .. ",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      var res = await Supabase.instance.client
          .from("users")
          .select()
          .eq("user_id", userId);

      // return res[0];

      if (res.isEmpty) {
        return {
          "result": false,
          "message": "User not found .. ",
        };
      }

      return {
        "result": true,
        "message": "User data fetched successfully .. ",
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
