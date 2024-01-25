// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:wishes_app/export.dart';

class AppUser {
  final String uid;
  final String name;
  final String username;
  final String? imageURL;
  final String? gender;
  final String language;
  final Timestamp date;
  final String? email;
  final String? bio;
  final List<dynamic> following;
  final List<dynamic> followers;
  final List<dynamic> block;
  final bool emailNotification;
  final bool pushNotification;
  final bool commentNotification;
  final bool likesNotification;
  final bool privateProfile;
  final String? token;
  final String accountType;
  final Timestamp joiningDate;
  AppUser({
    required this.uid,
    required this.name,
    required this.username,
    this.imageURL,
    this.gender,
    this.language = 'English',
    required this.date,
    this.email,
    this.bio,
    required this.following,
    required this.followers,
    required this.block,
    this.emailNotification = false,
    this.pushNotification = false,
    this.commentNotification = false,
    this.likesNotification = false,
    this.privateProfile = false,
    this.token,
    required this.accountType,
    required this.joiningDate,
  });

  AppUser copyWith({
    String? uid,
    String? name,
    String? username,
    String? imageURL,
    String? gender,
    String? language,
    Timestamp? date,
    String? email,
    String? bio,
    List<dynamic>? following,
    List<dynamic>? followers,
    List<dynamic>? block,
    bool? emailNotification,
    bool? pushNotification,
    bool? commentNotification,
    bool? likesNotification,
    bool? privateProfile,
    String? token,
    String? accountType,
    Timestamp? joiningDate,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      username: username ?? this.username,
      imageURL: imageURL ?? this.imageURL,
      gender: gender ?? this.gender,
      language: language ?? this.language,
      date: date ?? this.date,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      block: block ?? this.block,
      emailNotification: emailNotification ?? this.emailNotification,
      pushNotification: pushNotification ?? this.pushNotification,
      commentNotification: commentNotification ?? this.commentNotification,
      likesNotification: likesNotification ?? this.likesNotification,
      privateProfile: privateProfile ?? this.privateProfile,
      token: token ?? this.token,
      accountType: accountType ?? this.accountType,
      joiningDate: joiningDate ?? this.joiningDate,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'username': username,
      'imageURL': imageURL,
      'gender': gender,
      'language': language,
      'date': date,
      'email': email,
      'bio': bio,
      'following': following,
      'followers': followers,
      'block': block,
      'emailNotification': emailNotification,
      'pushNotification': pushNotification,
      'commentNotification': commentNotification,
      'likesNotification': likesNotification,
      'privateProfile': privateProfile,
      'token': token,
      'accountType': accountType,
      'joiningDate': joiningDate,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String,
      name: map['name'] as String,
      username: map['username'] as String,
      imageURL: map['imageURL'] != null ? map['imageURL'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      language: map['language'] as String,
      date: map['date'],
      email: map['email'] != null ? map['email'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      following: List<dynamic>.from((map['following'] as List<dynamic>)),
      followers: List<dynamic>.from((map['followers'] as List<dynamic>)),
      block: List<dynamic>.from((map['block'] as List<dynamic>)),
      emailNotification: map['emailNotification'] as bool,
      pushNotification: map['pushNotification'] as bool,
      commentNotification: map['commentNotification'] as bool,
      likesNotification: map['likesNotification'] as bool,
      privateProfile: map['privateProfile'] as bool,
      token: map['token'] != null ? map['token'] as String : null,
      accountType: map['accountType'] as String,
      joiningDate: map['joiningDate'],
    );
  }

  factory AppUser.fromDoc(DocumentSnapshot snapshot) {
    return AppUser(
      uid: snapshot['uid'] as String,
      name: snapshot['name'] as String,
      username: snapshot['username'] as String,
      imageURL:
          snapshot['imageURL'] != null ? snapshot['imageURL'] as String : null,
      gender: snapshot['gender'] != null ? snapshot['gender'] as String : null,
      language: snapshot['language'] as String,
      date: snapshot['date'],
      email: snapshot['email'] != null ? snapshot['email'] as String : null,
      bio: snapshot['bio'] != null ? snapshot['bio'] as String : null,
      following: List<dynamic>.from((snapshot['following'] as List<dynamic>)),
      followers: List<dynamic>.from((snapshot['followers'] as List<dynamic>)),
      block: List<dynamic>.from((snapshot['block'] as List<dynamic>)),
      emailNotification: snapshot['emailNotification'] as bool,
      pushNotification: snapshot['pushNotification'] as bool,
      commentNotification: snapshot['commentNotification'] as bool,
      likesNotification: snapshot['likesNotification'] as bool,
      privateProfile: snapshot['privateProfile'] as bool,
      token: snapshot['token'] != null ? snapshot['token'] as String : null,
      accountType: snapshot['accountType'] as String,
      joiningDate: snapshot['joiningDate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppUser(uid: $uid, name: $name, username: $username, imageURL: $imageURL, gender: $gender, language: $language, date: $date, email: $email, bio: $bio, following: $following, followers: $followers, block: $block, emailNotification: $emailNotification, pushNotification: $pushNotification, commentNotification: $commentNotification, likesNotification: $likesNotification, privateProfile: $privateProfile, token: $token, accountType: $accountType, joiningDate: $joiningDate)';
  }

  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.username == username &&
        other.imageURL == imageURL &&
        other.gender == gender &&
        other.language == language &&
        other.date == date &&
        other.email == email &&
        other.bio == bio &&
        listEquals(other.following, following) &&
        listEquals(other.followers, followers) &&
        listEquals(other.block, block) &&
        other.emailNotification == emailNotification &&
        other.pushNotification == pushNotification &&
        other.commentNotification == commentNotification &&
        other.likesNotification == likesNotification &&
        other.privateProfile == privateProfile &&
        other.token == token &&
        other.accountType == accountType &&
        other.joiningDate == joiningDate;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        username.hashCode ^
        imageURL.hashCode ^
        gender.hashCode ^
        language.hashCode ^
        date.hashCode ^
        email.hashCode ^
        bio.hashCode ^
        following.hashCode ^
        followers.hashCode ^
        block.hashCode ^
        emailNotification.hashCode ^
        pushNotification.hashCode ^
        commentNotification.hashCode ^
        likesNotification.hashCode ^
        privateProfile.hashCode ^
        token.hashCode ^
        accountType.hashCode ^
        joiningDate.hashCode;
  }
}
