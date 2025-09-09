import 'package:merhaba_app/controllers/auth_controller.dart';
import 'package:merhaba_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoriesController {
  static Future<Map<String, dynamic>> addStory(
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

      // print(currentUserData["data"]);

      var userData = currentUserData["user_metadata"];
      var username = userData["fullName"].toString();
      var photoUrl =
          userData["picUrl"] == null ? "" : userData["picUrl"].toString();

      data["username"] = username;
      data["user_photo"] = photoUrl;
      data["user_id"] = uid;
      data["active"] = true;
      data["added_by"] = uid;
      data["updated_by"] = "";
      data["date_added"] = DateTime.now().toIso8601String();
      data["date_updated"] = DateTime.now().toIso8601String();

      await Supabase.instance.client.from("stories").insert(
            data,
          );

      return {
        "result": true,
        "message": "Story added successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> updateStory(
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

      var storyRes = await Supabase.instance.client
          .from("stories")
          .select()
          .eq("id", data["id"])
          .eq("active", true);

      if (storyRes.isEmpty) {
        return {
          "result": false,
          "message": "Story not found!!",
        };
      }

      data["updated_by"] = uid;
      data["date_updated"] = DateTime.now().toIso8601String();

      await Supabase.instance.client
          .from("stories")
          .update(data)
          .eq("id", data["id"]);

      return {
        "result": true,
        "message": "Story updated successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> deleteStory(int id) async {
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

      var storyRes = await Supabase.instance.client
          .from("stories")
          .select()
          .eq("id", id)
          .eq("active", true);

      if (storyRes.isEmpty) {
        return {
          "result": false,
          "message": "Story not found!!",
        };
      }

      await Supabase.instance.client.from("stories").update({
        "active": false,
        "date_updated": DateTime.now().toIso8601String(),
        "updated_by": uid,
      }).eq("id", id);

      return {
        "result": true,
        "message": "Story deleted successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getStories() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var storiesRes = await Supabase.instance.client
          .from("stories")
          .select()
          .eq("active", true)
          .order("date_added", ascending: false);

      return storiesRes.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Map<String, dynamic>> getStory(int id) async {
    try {
      var storyRes = await Supabase.instance.client
          .from("stories")
          .select()
          .eq("id", id)
          .eq("active", true);

      if (storyRes.isEmpty) {
        return {
          "result": false,
          "message": "Story not found!!",
        };
      }

      return {
        "result": true,
        "message": "Story retrieved successfully",
        "data": storyRes[0],
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getStoryForUser(String userId) async {
    try {
      var storyRes = await Supabase.instance.client
          .from("stories")
          .select()
          .eq("user_id", userId)
          .eq("active", true);

      if (storyRes.isEmpty) {
        return {
          "result": false,
          "message": "Story not found!!",
        };
      }

      return {
        "result": true,
        "message": "Story retrieved successfully",
        "data": storyRes[0],
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getStoriesForUser(
      String userId) async {
    try {
      var storyRes = await Supabase.instance.client
          .from("stories")
          .select()
          .eq("user_id", userId)
          .eq("active", true)
          .order("date_added", ascending: false);

      return storyRes.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getStoriesForCurrentUser() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var storyRes = await Supabase.instance.client
          .from("stories")
          .select()
          .eq("user_id", uid)
          .eq("active", true)
          .order("date_added", ascending: false);

      return storyRes.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
