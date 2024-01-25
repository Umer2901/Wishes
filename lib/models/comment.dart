import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:wishes_app/export.dart';

class Comment {
  final String commentId;
  final String senderUid;
  final String recieverUid;
  final String postId;
  late String? parentId;
  final String? commentDescription;
  final List<dynamic> likes;
  final Timestamp timestamp;
  final List<dynamic> commentImageURL;
  Comment({
    required this.commentId,
    required this.senderUid,
    required this.recieverUid,
    required this.postId,
    this.parentId,
    this.commentDescription,
    required this.likes,
    required this.timestamp,
    required this.commentImageURL,
  });

  Comment copyWith({
    String? commentId,
    String? senderUid,
    String? recieverUid,
    String? postId,
    String? parentId,
    String? commentDescription,
    List<dynamic>? likes,
    Timestamp? timestamp,
    List<dynamic>? commentImageURL,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      senderUid: senderUid ?? this.senderUid,
      recieverUid: recieverUid ?? this.recieverUid,
      postId: postId ?? this.postId,
      parentId: parentId ?? this.parentId,
      commentDescription: commentDescription ?? this.commentDescription,
      likes: likes ?? this.likes,
      timestamp: timestamp ?? this.timestamp,
      commentImageURL: commentImageURL ?? this.commentImageURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'senderUid': senderUid,
      'recieverUid': recieverUid,
      'postId': postId,
      'parentId': parentId,
      'commentDescription': commentDescription,
      'likes': likes,
      'timestamp': timestamp,
      'commentImageURL': commentImageURL,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      commentId: map['commentId'] as String,
      senderUid: map['senderUid'] as String,
      recieverUid: map['recieverUid'] as String,
      postId: map['postId'] as String,
      parentId: map['parentId'] != null ? map['parentId'] as String : null,
      commentDescription: map['commentDescription'] != null
          ? map['commentDescription'] as String
          : null,
      likes: List<dynamic>.from((map['likes'] as List<dynamic>)),
      timestamp: map['timestamp'],
      commentImageURL:
          List<dynamic>.from((map['commentImageURL'] as List<dynamic>)),
    );
  }

  factory Comment.fromDoc(DocumentSnapshot snapshot) {
    return Comment(
      commentId: snapshot['commentId'] as String,
      senderUid: snapshot['senderUid'] as String,
      recieverUid: snapshot['recieverUid'] as String,
      postId: snapshot['postId'] as String,
      parentId:
          snapshot['parentId'] != null ? snapshot['parentId'] as String : null,
      commentDescription: snapshot['commentDescription'] != null
          ? snapshot['commentDescription'] as String
          : null,
      likes: List<dynamic>.from((snapshot['likes'] as List<dynamic>)),
      timestamp: snapshot['timestamp'],
      commentImageURL:
          List<dynamic>.from((snapshot['commentImageURL'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(commentId: $commentId, senderUid: $senderUid, recieverUid: $recieverUid, postId: $postId, parentId: $parentId, commentDescription: $commentDescription, likes: $likes, timestamp: $timestamp, commentImageURL: $commentImageURL)';
  }

  @override
  bool operator ==(covariant Comment other) {
    if (identical(this, other)) return true;

    return other.commentId == commentId &&
        other.senderUid == senderUid &&
        other.recieverUid == recieverUid &&
        other.postId == postId &&
        other.parentId == parentId &&
        other.commentDescription == commentDescription &&
        listEquals(other.likes, likes) &&
        other.timestamp == timestamp &&
        listEquals(other.commentImageURL, commentImageURL);
  }

  @override
  int get hashCode {
    return commentId.hashCode ^
        senderUid.hashCode ^
        recieverUid.hashCode ^
        postId.hashCode ^
        parentId.hashCode ^
        commentDescription.hashCode ^
        likes.hashCode ^
        timestamp.hashCode ^
        commentImageURL.hashCode;
  }
}
