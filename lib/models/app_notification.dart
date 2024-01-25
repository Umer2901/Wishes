// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:wishes_app/export.dart';

class AppNotification {
  final String id;
  final String type;
  final String sender;
  final String receiver;
  final String text;
  final String objectId;
  final Timestamp timestamp;
  AppNotification({
    required this.id,
    required this.type,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.objectId,
    required this.timestamp,
  });

  AppNotification copyWith({
    String? id,
    String? type,
    String? sender,
    String? receiver,
    String? text,
    String? objectId,
    Timestamp? timestamp,
  }) {
    return AppNotification(
      id: id ?? this.id,
      type: type ?? this.type,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      text: text ?? this.text,
      objectId: objectId ?? this.objectId,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'sender': sender,
      'receiver': receiver,
      'text': text,
      'objectId': objectId,
      'timestamp': timestamp,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      type: map['type'] as String,
      sender: map['sender'] as String,
      receiver: map['receiver'] as String,
      text: map['text'] as String,
      objectId: map['objectId'] as String,
      timestamp: map['timestamp'],
    );
  }

  factory AppNotification.fromDoc(DocumentSnapshot snapshot) {
    return AppNotification(
      id: snapshot['id'] as String,
      type: snapshot['type'] as String,
      sender: snapshot['sender'] as String,
      receiver: snapshot['receiver'] as String,
      text: snapshot['text'] as String,
      objectId: snapshot['objectId'] as String,
      timestamp: snapshot['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AppNotification.fromJson(String source) =>
      AppNotification.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppNotification(id: $id, type: $type, sender: $sender, receiver: $receiver, text: $text, objectId: $objectId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant AppNotification other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        other.sender == sender &&
        other.receiver == receiver &&
        other.text == text &&
        other.objectId == objectId &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        sender.hashCode ^
        receiver.hashCode ^
        text.hashCode ^
        objectId.hashCode ^
        timestamp.hashCode;
  }
}

enum NotificationTypes {
  like,
  comment,
  email,
  request,
}
