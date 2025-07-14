import 'package:merhaba_app/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsController {
  static Future<Map<String, dynamic>> addFriend(String otherUserId) async {
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

      await Supabase.instance.client.from("friends_requests").insert({
        "user1_id": uid,
        "user2_id": otherUserId,
        "status": "Pending",
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
        "date_updated": DateTime.now().toIso8601String(),
        "updated_by": "",
      });

      return {
        "result": true,
        "message": "Friend request sent successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> unFriend(String otherUserId) async {
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

      try {
        await Supabase.instance.client
            .from("friends")
            .delete()
            .eq("user1_id", uid)
            .eq("user2_id", otherUserId);
      } catch (e) {
        print(e.toString());
      }

      try {
        await Supabase.instance.client
            .from("friends")
            .delete()
            .eq("user1_id", otherUserId)
            .eq("user2_id", uid);
      } catch (e) {
        print(e.toString());
      }

      return {
        "result": true,
        "message": "Friend removed successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getFriends() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var friendsRes1 = await Supabase.instance.client
          .from("friends")
          .select()
          .eq("user1_id", uid);

      var friendsRes2 = await Supabase.instance.client
          .from("friends")
          .select()
          .eq("user2_id", uid);

      var users = await Supabase.instance.client.from("users").select();

      friendsRes1 = friendsRes1.map((element) {
        return {
          ...element,
          "user": users
              .firstWhere((user) => user["user_id"] == element["user2_id"]),
        };
      }).toList();

      friendsRes2 = friendsRes2.map((element) {
        return {
          ...element,
          "user": users
              .firstWhere((user) => user["user_id"] == element["user1_id"]),
        };
      }).toList();

      return [...friendsRes1, ...friendsRes2];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getFriendRequests() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var friendRequestsRes = await Supabase.instance.client
          .from("friends_requests")
          .select()
          .eq("status", "Pending")
          .eq("user2_id", uid);

      var users = await Supabase.instance.client.from("users").select();

      friendRequestsRes = friendRequestsRes.map((element) {
        return {
          ...element,
          "user": users
              .firstWhere((user) => user["user_id"] == element["user1_id"]),
        };
      }).toList();

      return friendRequestsRes;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Map<String, dynamic>> acceptFriendRequest(
    int requestId,
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

      await Supabase.instance.client.from("friends_requests").update({
        "status": "Accepted",
        "date_updated": DateTime.now().toIso8601String(),
        "updated_by": uid,
      }).eq("id", requestId);

      var friendRequestRes = await Supabase.instance.client
          .from("friends_requests")
          .select()
          .eq("id", requestId);

      var otherUserId = friendRequestRes[0]["user1_id"];

      await Supabase.instance.client.from("friends").insert({
        "user1_id": otherUserId,
        "user2_id": uid,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
        "date_updated": DateTime.now().toIso8601String(),
      });

      return {
        "result": true,
        "message": "Friend request accepted successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<List<Map<String, dynamic>>> getSuggestions() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var friends = await getFriends();
      var friendRequests =
          await Supabase.instance.client.from("friends_requests").select();

      var allUsers = await Supabase.instance.client
          .from("users")
          .select()
          .neq("user_id", uid);

      List<Map<String, dynamic>> list = [];
      for (var user in allUsers) {
        var isInFriends = friends
            .where((element) => element["user_id"] == user["user_id"])
            .isNotEmpty;

        if (isInFriends) {
          continue;
        }

        var isInFriendRequests = friendRequests
            .where((element) =>
                (element["user1_id"] == user["user_id"] &&
                    element["user2_id"] == uid) ||
                (element["user2_id"] == user["user_id"] &&
                    element["user1_id"] == uid))
            // .where((element) => element["status"] == "Pending")
            .isNotEmpty;

        if (isInFriendRequests) {
          continue;
        }

        list.add(user);
      }

      return list;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<Map<String, dynamic>> deleteFriendRequest(
    int requestId,
  ) async {
    try {
      await Supabase.instance.client
          .from("friends_requests")
          .delete()
          .eq("id", requestId);

      return {
        "result": true,
        "message": "Friend request deleted successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<bool> isInFriend(String userId) async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return false;
      }

      var friends = await getFriends();

      // print(friends);

      return friends
          .where((element) =>
              (element["user1_id"] == userId ||
                  element["user2_id"] == userId) &&
              (element["user1_id"] == uid || element["user2_id"] == uid))
          .isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<Map<String, dynamic>> blockUser(String userId) async {
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

      var blockedUsers = await getBlockList();

      if (blockedUsers.any((element) => element["user_id"] == userId)) {
        return {
          "result": false,
          "message": "User is already blocked",
        };
      }

      await Supabase.instance.client.from("blocked_users").insert({
        "blocking_user_id": uid,
        "blocked_user_id": userId,
        "date_added": DateTime.now().toIso8601String(),
        "added_by": uid,
        "date_updated": DateTime.now().toIso8601String(),
        "updated_by": uid,
        "active": true,
      });

      return {
        "result": true,
        "message": "User blocked successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> unblockUser(String userId) async {
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

      var blockedUsers = await getBlockList();

      if (!blockedUsers.any((element) => element["user_id"] == userId)) {
        return {
          "result": false,
          "message": "User is not blocked",
        };
      }

      await Supabase.instance.client
          .from("blocked_users")
          .update({
            "active": false,
            "date_updated": DateTime.now().toIso8601String(),
            "updated_by": uid,
          })
          .eq("blocking_user_id", uid)
          .eq("blocked_user_id", userId)
          .eq("active", true);

      return {
        "result": true,
        "message": "User unblocked successfully",
      };
    } catch (e) {
      print(e.toString());
      return {
        "result": false,
        "message": e.toString(),
      };
    }
  }

  static Future<bool> isBlocked(String userId) async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return false;
      }

      var blockedUsers = await getBlockList();

      return blockedUsers.any((element) => element["user_id"] == userId);
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getBlockList() async {
    try {
      var uid = await secureStorage.read(
        key: "uid",
      );

      if (uid == null) {
        return [];
      }

      var blockListRes = await Supabase.instance.client
          .from("blocked_users")
          .select()
          .eq("blocking_user_id", uid)
          .eq("active", true);

      List<String> blockList = blockListRes
          .map((element) => element["blocked_user_id"].toString())
          .toList();

      var users = await Supabase.instance.client
          .from("users")
          .select()
          .inFilter("user_id", blockList);

      return users;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
