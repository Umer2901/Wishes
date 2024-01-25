import 'dart:io';
import 'package:wishes_app/export.dart';

class CommentServices {
  static final _commentCollection =
      FirebaseFirestore.instance.collection('comments');
  static final _storage = FirebaseStorage.instance;

  static Future<void> addComment(Comment comment, List<File> images) async {
    try {
      List<String> imageURLs = [];

      await _commentCollection.add(comment.toMap()).then((value) async {
        for (File image in images) {
          String commentImageURL = await uploadImage(
              image, "${value.id}-${images.indexOf(image) + 1}");
          imageURLs.add(commentImageURL);
        }

        await _commentCollection
            .doc(value.id)
            .update({'commentImageURL': imageURLs, 'commentId': value.id});
        await PostServices.comment(comment.postId, value.id);
      });
    } catch (e) {
      throw Exception("Failed to add comment: $e");
    }
  }

  static Stream<List<Map<String, dynamic>>?> getCommentsForPost(String postId) {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> comments = [];
      for (var commentDoc in snapshot.docs) {
        String userId = commentDoc['senderUid'];
        AppUser? user = await UserServices.fetch(userId);

        if (user != null) {
          comments.add({'comment': Comment.fromDoc(commentDoc), 'user': user});
        }
        // print('Coment:$comments');
      }
      // print('Coment:$comments');
      return comments.isNotEmpty ? comments : null;
    });
  }

  // static Stream<List<Map<String, dynamic>>?> getRepliesForComment(
  //     String postId) {
  //   return FirebaseFirestore.instance
  //       .collection('comments')
  //       .where('postId', isEqualTo: postId)
  //       .where('parentId', isNotEqualTo: '')
  //       .orderBy('timestamp', descending: false)
  //       .snapshots()
  //       .asyncMap((snapshot) async {
  //     List<Map<String, dynamic>> comments = [];
  //     for (var commentDoc in snapshot.docs) {
  //       String userId = commentDoc['senderUid'];
  //       AppUser? user = await UserServices.fetch(userId);

  //       if (user != null) {
  //         comments.add({'comment': Comment.fromDoc(commentDoc), 'user': user});
  //       }
  //     }
  //     print('Coment:$comments');
  //     return comments.isNotEmpty ? comments : null;
  //   });
  // }
  static Stream<List<Map<String, dynamic>>?> getRepliesForComment(
      String postId) {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .where('parentId', isNotEqualTo: '')
        .orderBy('parentId') // Change to the field you want to order by
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Stream<int> getCommentCountStream(String postId) {
    return FirebaseFirestore.instance
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .where('parentId', isEqualTo: '')
        .snapshots()
        .map((querySnapshot) => querySnapshot.size);
  }

  static Future<void> updateComment(Comment updatedComment) async {
    try {
      await _commentCollection
          .doc(updatedComment.commentId)
          .update(updatedComment.toMap());
    } catch (e) {
      throw Exception("Failed to update comment: $e");
    }
  }

  static Future<void> deleteComment(String commentId) async {
    try {
      await _commentCollection.doc(commentId).delete();
    } catch (e) {
      throw Exception("Failed to delete comment: $e");
    }
  }

  static Future<String> uploadImage(File file, String uid) async {
    final ref = _storage.ref("comments/$uid");
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  static Future<void> like(Comment comment) async {
    try {
      List<dynamic> likes = comment.likes;
      if (likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
        likes.remove(FirebaseAuth.instance.currentUser!.uid);
      } else {
        likes.add(FirebaseAuth.instance.currentUser!.uid);
      }
      await _commentCollection.doc(comment.commentId).update({'likes': likes});
    } catch (e) {
      throw Exception("Like Failed");
    }
  }
}
