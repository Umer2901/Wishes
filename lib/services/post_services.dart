import 'dart:io';
import 'package:wishes_app/export.dart';

class PostServices {
  static final _postCollection = FirebaseFirestore.instance.collection('posts');

  static final _storage = FirebaseStorage.instance;

  static Future<void> create(Post createPost, List<File> images) async {
    try {
      List<String> imageURLs = [];
      await _postCollection.add(createPost.toMap()).then((value) async {
        for (File image in images) {
          String postImageURL = await uploadImage(
              image, "${value.id}-${images.indexOf(image) + 1}");
          imageURLs.add(postImageURL);
        }
        await _postCollection.doc(value.id).update({
          'id': value.id,
          'postImageURL': imageURLs,
        });
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String> uploadImage(File file, String uid) async {
    final ref = _storage.ref("posts/$uid");
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  static Future<Post?> fetch(String uid) async {
    DocumentSnapshot createPost = await _postCollection.doc(uid).get();
    if (createPost.exists) {
      return Post.fromDoc(createPost);
    }
    return null;
  }

  static Stream<List<Map<String, dynamic>>?> forYouStream() {
    return _postCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> posts = [];
      for (var postDoc in snapshot.docs) {
        String userId = postDoc['uid'];
        AppUser? user = await UserServices.fetch(userId);

        if (user != null &&
                (user.privateProfile == false ||
                    user.followers
                        .contains(FirebaseAuth.instance.currentUser!.uid)) &&
                !user.block.contains(FirebaseAuth.instance.currentUser!.uid) ||
            user!.uid == FirebaseAuth.instance.currentUser!.uid) {
          posts.add({'post': Post.fromDoc(postDoc), 'user': user});
        }
      }

      return posts.isNotEmpty ? posts : null;
    });
  }

  static Stream<List<Map<String, dynamic>>?> followerStream(AppUser user) {
    return _postCollection
        .where('uid',
            whereIn: user.following.isEmpty ? ['Nil'] : user.following)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> posts = [];
      for (var postDoc in snapshot.docs) {
        String userId = postDoc['uid'];
        AppUser? user = await UserServices.fetch(userId);

        if (user != null) {
          posts.add({'post': Post.fromDoc(postDoc), 'user': user});
        }
      }

      return posts.isNotEmpty ? posts : null;
    });
  }

  static Stream<Map<String, dynamic>?> getPostByIdStream(String postId) {
    return _postCollection.doc(postId).snapshots().asyncMap((postDoc) async {
      if (postDoc.exists) {
        String userId = postDoc['uid'];
        AppUser? user = await UserServices.fetch(userId);

        if (user != null &&
                (user.privateProfile == false ||
                    user.followers
                        .contains(FirebaseAuth.instance.currentUser!.uid)) &&
                !user.block.contains(FirebaseAuth.instance.currentUser!.uid) ||
            user!.uid == FirebaseAuth.instance.currentUser!.uid) {
          return {'post': Post.fromDoc(postDoc), 'user': user};
        }
      }

      return null; // Post not found or does not meet the conditions
    });
  }

  static Stream<List<Map<String, dynamic>>?> userStream(String uid) {
    return _postCollection
        .where('uid', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> posts = [];

      for (var postDoc in snapshot.docs) {
        String userId = postDoc['uid'];
        AppUser? user = await UserServices.fetch(userId);

        if (user != null) {
          posts.add({'post': Post.fromDoc(postDoc), 'user': user});
        }
      }

      return posts.isNotEmpty ? posts : null;
    });
  }

  static Future<Post?> fetchPost(String postId) async {
    DocumentSnapshot postDoc = await _postCollection.doc(postId).get();
    if (postDoc.exists) {
      return Post.fromDoc(postDoc);
    }
    return null;
  }

  static Future<void> delete(Post post) async {
    for (String comments in post.comment) {
      await CommentServices.deleteComment(comments);
    }
    await _postCollection.doc(post.id).delete();
  }

  static Future<void> like(Post post) async {
    try {
      List<dynamic> likes = post.likes;
      if (likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
        likes.remove(FirebaseAuth.instance.currentUser!.uid);
      } else {
        likes.add(FirebaseAuth.instance.currentUser!.uid);
      }
      await _postCollection.doc(post.id).update({'likes': likes});
    } catch (e) {
      throw Exception("Like Failed");
    }
  }

  static Future<void> comment(String postId, String commentId) async {
    try {
      Post? post = await PostServices.fetch(postId);
      List<dynamic> comment = post!.comment;
      comment.add(commentId);
      await _postCollection.doc(post.id).update({'comment': comment});
    } catch (e) {
      throw Exception("Comment Failed");
    }
  }

  static Future<void> updatePost(Post updatedPost) async {
    try {
      await _postCollection.doc(updatedPost.uid).update(updatedPost.toMap());
    } catch (e) {
      throw Exception("Failed to update user data");
    }
  }
}
