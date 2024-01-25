import 'package:wishes_app/export.dart';

class NotificationServices {
  static final _notificationCollection =
      FirebaseFirestore.instance.collection('notifications');

  static Future<void> create(AppNotification notification) async {
    try {
      await _notificationCollection
          .add(notification.toMap())
          .then((value) async {
        await _notificationCollection.doc(value.id).update({'id': value.id});
      });
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<AppNotification?> fetch(String id) async {
    DocumentSnapshot notification = await _notificationCollection.doc(id).get();
    if (notification.exists) {
      return AppNotification.fromDoc(notification);
    }
    return null;
  }

  static Future<void> remove(String id) async {
    await _notificationCollection.doc(id).delete();
  }

  static Future<List<AppNotification>?> fetchAll() async {
    QuerySnapshot notification = await _notificationCollection.get();
    if (notification.docs.isNotEmpty) {
      return notification.docs.map((e) => AppNotification.fromDoc(e)).toList();
    }
    return null;
  }

  static Stream<List<Map<String, dynamic>>?> notificationStream() {
    return _notificationCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> notifications = [];

      var temp = snapshot.docs;

      temp.removeWhere((element) =>
          element['receiver'] != FirebaseAuth.instance.currentUser!.uid);

      for (var notificationDoc in temp) {
        String userId = notificationDoc['sender'];
        AppUser? user = await UserServices.fetch(userId);

        if (user != null) {
          notifications.add({
            'notification': AppNotification.fromDoc(notificationDoc),
            'user': user
          });
        }
      }

      return notifications.isNotEmpty ? notifications : null;
    });
  }
}
