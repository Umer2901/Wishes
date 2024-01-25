import 'dart:convert';
import 'package:wishes_app/export.dart';

class Email {
  final String id;
  final String senderUID;
  final String recieverUID;
  final String? subject;
  final String description;
  final Timestamp timestamp;
  Email({
    required this.id,
    required this.senderUID,
    required this.recieverUID,
    this.subject,
    required this.description,
    required this.timestamp,
  });

  Email copyWith({
    String? id,
    String? senderUID,
    String? recieverUID,
    String? subject,
    String? description,
    Timestamp? timestamp,
  }) {
    return Email(
      id: id ?? this.id,
      senderUID: senderUID ?? this.senderUID,
      recieverUID: recieverUID ?? this.recieverUID,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderUID': senderUID,
      'recieverUID': recieverUID,
      'subject': subject,
      'description': description,
      'timestamp': timestamp,
    };
  }

  factory Email.fromMap(Map<String, dynamic> map) {
    return Email(
      id: map['id'] as String,
      senderUID: map['senderUID'] as String,
      recieverUID: map['recieverUID'] as String,
      subject: map['subject'] != null ? map['subject'] as String : null,
      description: map['description'] as String,
      timestamp: map['timestamp'],
    );
  }

  factory Email.fromDoc(DocumentSnapshot snapshot) {
    return Email(
      id: snapshot['id'] as String,
      senderUID: snapshot['senderUID'] as String,
      recieverUID: snapshot['recieverUID'] as String,
      subject:
          snapshot['subject'] != null ? snapshot['subject'] as String : null,
      description: snapshot['description'] as String,
      timestamp: snapshot['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Email.fromJson(String source) =>
      Email.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Email(id: $id, senderUID: $senderUID, recieverUID: $recieverUID, subject: $subject, description: $description, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant Email other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderUID == senderUID &&
        other.recieverUID == recieverUID &&
        other.subject == subject &&
        other.description == description &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderUID.hashCode ^
        recieverUID.hashCode ^
        subject.hashCode ^
        description.hashCode ^
        timestamp.hashCode;
  }
}
