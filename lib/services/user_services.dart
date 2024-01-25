import 'dart:io';
import 'package:wishes_app/export.dart';

class UserServices {
  static final _userCollection = FirebaseFirestore.instance.collection('users');
  static final _storage = FirebaseStorage.instance;

  static Future<void> create(AppUser appUser, File file) async {
    try {
      String imageURL = await uploadImage(file, appUser.uid);
      QuerySnapshot temp = await _userCollection
          .where('username', isEqualTo: appUser.username)
          .get();

      if (temp.docs.isEmpty) {
        await _userCollection
            .doc(appUser.uid)
            .set(appUser.toMap())
            .then((value) async {
          _userCollection.doc(appUser.uid).update(
            {
              'imageURL': imageURL,
            },
          );
        });
      } else {
        throw Exception('Username already taken!');
      }
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String> uploadImage(File file, String uid) async {
    final ref = _storage.ref("profile/$uid");
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  static Future<AppUser?> fetch(String uid) async {
    DocumentSnapshot appuser = await _userCollection.doc(uid).get();
    if (appuser.exists) {
      return AppUser.fromDoc(appuser);
    }
    return null;
  }

  static Stream<AppUser?> stream(String uid) {
    return _userCollection.doc(uid).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return AppUser.fromDoc(snapshot);
      } else {
        return null;
      }
    });
  }

  static Future<void> update(
      String uid, Map<String, dynamic> data, File? file) async {
    try {
      QuerySnapshot temp = await _userCollection
          .where('username', isEqualTo: data['username'])
          .get();

      if (temp.docs.isEmpty ||
          temp.docs.first['uid'] == FirebaseAuth.instance.currentUser!.uid) {
        await _userCollection.doc(uid).update(data).then((value) async {
          if (file != null) {
            String imageURL = await uploadImage(file, uid);
            _userCollection.doc(uid).update({'imageURL': imageURL});
          }
        });
      } else {
        throw Exception('Username already taken!');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> follow(String uid, String otherUId) async {
    try {
      AppUser fUser = AppUser.fromDoc(await _userCollection.doc(uid).get());
      List<dynamic> following = fUser.following;
      following.add(otherUId);
      await _userCollection.doc(uid).update({'following': following});
      AppUser sUser =
          AppUser.fromDoc(await _userCollection.doc(otherUId).get());
      List<dynamic> followers = sUser.followers;
      followers.add(uid);
      await _userCollection.doc(otherUId).update({'followers': followers});
    } catch (e) {
      throw Exception("Failed to update user data");
    }
  }

  static Future<void> unfollow(String uid, String otherUId) async {
    try {
      AppUser fUser = AppUser.fromDoc(await _userCollection.doc(uid).get());
      List<dynamic> following = fUser.following;
      following.remove(otherUId);
      await _userCollection.doc(uid).update({'following': following});
      AppUser sUser =
          AppUser.fromDoc(await _userCollection.doc(otherUId).get());
      List<dynamic> followers = sUser.followers;
      followers.remove(uid);
      await _userCollection.doc(otherUId).update({'followers': followers});
    } catch (e) {
      throw Exception("Failed to update user data");
    }
  }

  static Stream<List<AppUser>?> profileFollowerStream(String uid) {
    return _userCollection.doc(uid).snapshots().asyncMap((snapshot) async {
      List<AppUser> followers = [];

      for (var follower in snapshot['followers']) {
        AppUser? user = await UserServices.fetch(follower);

        if (user != null) {
          followers.add(user);
        }
      }

      return followers.isNotEmpty ? followers : null;
    });
  }

  static Stream<List<AppUser>?> profileFollowingStream(String uid) {
    return _userCollection.doc(uid).snapshots().asyncMap((snapshot) async {
      List<AppUser> following = [];

      for (var follow in snapshot['following']) {
        AppUser? user = await UserServices.fetch(follow);

        if (user != null) {
          following.add(user);
        }
      }

      return following.isNotEmpty ? following : null;
    });
  }

  static Future<void> block(String uid) async {
    try {
      AppUser user = AppUser.fromDoc(await _userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get());
      List<dynamic> block = user.block;
      await unfollow(uid, FirebaseAuth.instance.currentUser!.uid);
      block.add(uid);
      await _userCollection
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'block': block});
    } catch (e) {
      throw Exception("Failed to block the user.");
    }
  }
}
