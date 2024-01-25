import 'package:intl/intl.dart';
import 'package:wishes_app/export.dart';
import 'package:wishes_app/views/email_detail.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            AppCustomNavigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
        child: StreamBuilder(
          stream: NotificationServices.notificationStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var notification in snapshot.data!) ...{
                        notificationContainer(
                          context,
                          notification['notification'],
                          notification['user'],
                        ),
                        const Divider(),
                      }
                    ],
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'No Notification',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget notificationContainer(
      BuildContext context, AppNotification notification, AppUser user) {
    return ListTile(
      onTap: () async {
        if (notification.type == 'email') {
          Email? email = await EmailService.fetchEmail(notification.objectId);
          await UserServices.fetch(notification.sender).then((user) {
            AppCustomNavigator.push(
                context, EmailDetailScreen(user: user!, email: email!));
          });
        }
        if (notification.type == 'like' || notification.type == 'email') {
          await PostServices.fetchPost(notification.objectId).then((value) {
            AppCustomNavigator.push(context, CommentScreen(post: value!));
          });
        }
      },
      contentPadding: const EdgeInsets.all(0),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 10.w,
            backgroundImage: NetworkImage(user.imageURL!),
          ),
          if (notification.type == 'email')
            Positioned(
              bottom: 0,
              right: 1.w,
              child: CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                radius: 2.5.w,
                child: Icon(
                  Icons.mail,
                  color: AppColors.whiteColor,
                  size: 10.sp,
                ),
              ),
            )
        ],
      ),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      subtitle: Text(
        notification.text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: notification.type == 'request'
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    await UserServices.follow(
                            notification.sender, notification.receiver)
                        .whenComplete(
                      () => NotificationServices.remove(notification.id),
                    );
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    NotificationServices.remove(notification.id);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ],
            )
          : Text(
              DateTime.now()
                          .difference(DateTime.fromMicrosecondsSinceEpoch(
                              notification.timestamp.microsecondsSinceEpoch))
                          .inDays <
                      1
                  ? DateFormat('hh:mm a').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          notification.timestamp.microsecondsSinceEpoch))
                  : DateFormat('dd-MM-yyyy').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                          notification.timestamp.microsecondsSinceEpoch)),
              style: Theme.of(context).textTheme.bodySmall,
            ),
    );
  }
}
