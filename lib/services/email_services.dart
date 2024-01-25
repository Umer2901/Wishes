import 'package:wishes_app/export.dart';
import 'package:wishes_app/firebase_messaging_service.dart';

class EmailService {
  static final _emailCollection =
      FirebaseFirestore.instance.collection('emails');

  static Future<void> sendEmail(Email email) async {
    try {
      await _emailCollection.add(email.toMap()).then(
        (value) async {
          _emailCollection.doc(value.id).update({'id': value.id});
          AppUser? user = await UserServices.fetch(email.recieverUID);
          if (user!.emailNotification) {
            await NotificationServices.create(
              AppNotification(
                id: '',
                type: NotificationTypes.email.name,
                sender: FirebaseAuth.instance.currentUser!.uid,
                receiver: email.recieverUID,
                text: 'Sent you a mail.',
                objectId: value.id,
                timestamp: Timestamp.fromDate(
                  DateTime.now(),
                ),
              ),
            );
            if (user.token != null && user.pushNotification) {
              FirebaseMessagingServices().sendNotification(
                user,
                'Received Mail',
                'have send your a mail check it out.',
              );
            }
          }
        },
      );
    } on FirebaseException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<Email?> fetchEmail(String emailId) async {
    DocumentSnapshot emailDoc = await _emailCollection.doc(emailId).get();
    if (emailDoc.exists) {
      return Email.fromDoc(emailDoc);
    }
    return null;
  }

  static Stream<List<Map<String, dynamic>>?> emailStream() {
    return _emailCollection
        .orderBy('timestamp', descending: true)
        .where('recieverUID', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> emails = [];

      for (var emailDoc in snapshot.docs) {
        String userId = emailDoc['senderUID'];
        AppUser? user = await UserServices.fetch(userId);

        if (user != null &&
            (user.privateProfile == false ||
                user.followers
                    .contains(FirebaseAuth.instance.currentUser!.uid)) &&
            !user.block.contains(FirebaseAuth.instance.currentUser!.uid)) {
          emails.add({'email': Email.fromDoc(emailDoc), 'user': user});
        }
      }

      return emails.isNotEmpty ? emails : null;
    });
  }
}
