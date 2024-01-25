// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:wishes_app/export.dart';

class Post {
  final String id;
  final String uid;
  final String? description;
  final List<dynamic> postImageURL;
  final List<dynamic> likes;
  final List<dynamic> comment;
  final Timestamp timestamp;
  final String language;
  Post({
    required this.id,
    required this.uid,
    this.description,
    required this.postImageURL,
    required this.likes,
    required this.comment,
    required this.timestamp,
    this.language = 'English',
  });

  Post copyWith({
    String? id,
    String? uid,
    String? description,
    List<dynamic>? postImageURL,
    List<dynamic>? likes,
    List<dynamic>? comment,
    Timestamp? timestamp,
    String? language,
  }) {
    return Post(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      description: description ?? this.description,
      postImageURL: postImageURL ?? this.postImageURL,
      likes: likes ?? this.likes,
      comment: comment ?? this.comment,
      timestamp: timestamp ?? this.timestamp,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uid': uid,
      'description': description,
      'postImageURL': postImageURL,
      'likes': likes,
      'comment': comment,
      'timestamp': timestamp,
      'language': language,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      uid: map['uid'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      postImageURL: List<dynamic>.from((map['postImageURL'] as List<dynamic>)),
      likes: List<dynamic>.from((map['likes'] as List<dynamic>)),
      comment: List<dynamic>.from((map['comment'] as List<dynamic>)),
      timestamp: map['timestamp'],
      language: map['language'] as String,
    );
  }

  factory Post.fromDoc(DocumentSnapshot snapshot) {
    return Post(
      id: snapshot['id'] as String,
      uid: snapshot['uid'] as String,
      description: snapshot['description'] != null
          ? snapshot['description'] as String
          : null,
      postImageURL:
          List<dynamic>.from((snapshot['postImageURL'] as List<dynamic>)),
      likes: List<dynamic>.from((snapshot['likes'] as List<dynamic>)),
      comment: List<dynamic>.from((snapshot['comment'] as List<dynamic>)),
      timestamp: snapshot['timestamp'],
      language: snapshot['language'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) =>
      Post.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Post(id: $id, uid: $uid, description: $description, postImageURL: $postImageURL, likes: $likes, comment: $comment, timestamp: $timestamp, language: $language)';
  }

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uid == uid &&
        other.description == description &&
        listEquals(other.postImageURL, postImageURL) &&
        listEquals(other.likes, likes) &&
        listEquals(other.comment, comment) &&
        other.timestamp == timestamp &&
        other.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uid.hashCode ^
        description.hashCode ^
        postImageURL.hashCode ^
        likes.hashCode ^
        comment.hashCode ^
        timestamp.hashCode ^
        language.hashCode;
  }
}
