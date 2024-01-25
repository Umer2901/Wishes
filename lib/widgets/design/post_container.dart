import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:wishes_app/export.dart';
import 'package:wishes_app/firebase_messaging_service.dart';

class PostContainer extends StatelessWidget {
  final AppUser user;
  final Post post;
  final bool isProfilePost;
  const PostContainer({
    super.key,
    required this.user,
    required this.post,
    this.isProfilePost = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          child: Column(
            children: [
              SizedBox(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageURL!),
                  ),
                  title: GestureDetector(
                    onTap: () {
                      if (user.uid != FirebaseAuth.instance.currentUser!.uid) {
                        AppCustomNavigator.push(
                          context,
                          OtherUserProfileScreen(
                            user: user,
                          ),
                        );
                      }
                    },
                    child: Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  subtitle: Text(
                    DateTime.now()
                                .difference(DateTime.fromMicrosecondsSinceEpoch(
                                    post.timestamp.microsecondsSinceEpoch))
                                .inDays <
                            1
                        ? DateTime.now()
                                    .difference(
                                        DateTime.fromMicrosecondsSinceEpoch(post
                                            .timestamp.microsecondsSinceEpoch))
                                    .inHours >=
                                1
                            ? '${DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(post.timestamp.microsecondsSinceEpoch)).inHours.toString()} hours ago'
                            : DateTime.now()
                                        .difference(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                post.timestamp
                                                    .microsecondsSinceEpoch))
                                        .inMinutes >=
                                    1
                                ? '${(DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(post.timestamp.microsecondsSinceEpoch)).inMinutes % 60).toString()} mins ago'
                                : '${DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(post.timestamp.microsecondsSinceEpoch)).inSeconds.toString()} sec ago'
                        : DateFormat('dd-MM-yyyy').format(
                            DateTime.fromMicrosecondsSinceEpoch(
                                post.timestamp.microsecondsSinceEpoch),
                          ),
                  ),
                  trailing: isProfilePost == true
                      ? PopupMenuButton<String>(
                          color: AppColors.whiteColor,
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete_forever),
                                    SizedBox(width: 1.w),
                                    const Text('Delete'),
                                  ],
                                ),
                              ),
                            ];
                          },
                          onSelected: (String choice) {
                            if (choice == 'delete') {
                              PostServices.delete(post);
                            }
                          },
                          child: const Icon(Icons.more_horiz),
                        )
                      : const SizedBox(),
                ),
              ),
              Align(
                alignment: post.language == 'English'
                    ? Alignment.topLeft
                    : Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: RichText(
                    textAlign: post.language == 'English'
                        ? TextAlign.left
                        : TextAlign.right,
                    text: TextSpan(
                      text: user.accountType != 'Personal'
                          ? post.language == 'English'
                              ? 'We Wish '
                              : 'نتمنى '
                          : post.language == 'English'
                              ? 'I Wish '
                              : 'نتمنى',
                      style: post.language == 'English'
                          ? TextStyle(
                              fontFamily: 'MCPU',
                              color: AppColors.primaryColor,
                              fontSize: 9.sp,
                            )
                          : TextStyle(
                              fontFamily: 'Arabic',
                              color: AppColors.primaryColor,
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w900),
                      children: [
                        TextSpan(
                            text: post.description != null
                                ? post.description!
                                : '',
                            style: Theme.of(context).textTheme.titleSmall)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              if (post.postImageURL.length == 1)
                Container(
                  constraints: BoxConstraints(maxHeight: 40.h),
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0.5, vertical: 0.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    image: DecorationImage(
                        image: NetworkImage(
                          post.postImageURL[0],
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
              if (post.postImageURL.length == 2)
                Container(
                  height: 25.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25.h,
                        width: 44.w,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0.5, vertical: 0.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                              image: NetworkImage(
                                post.postImageURL[0],
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(
                        width: 1.5.w,
                      ),
                      Container(
                        height: 25.h,
                        width: 44.w,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 0.5, vertical: 0.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                post.postImageURL[1],
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
              if (post.postImageURL.length > 2)
                Container(
                    height: 25.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 25.h,
                          width: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            image: DecorationImage(
                                image: NetworkImage(
                                  post.postImageURL[0],
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          width: 1.h,
                        ),
                        Column(
                          children: [
                            Container(
                              height: 12.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      post.postImageURL[1],
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Container(
                              height: 12.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: NetworkImage(
                                      post.postImageURL[2],
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              SizedBox(height: 1.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!post.likes.contains(
                                FirebaseAuth.instance.currentUser!.uid) &&
                            user.likesNotification) {
                          NotificationServices.create(
                            AppNotification(
                              id: '',
                              type: NotificationTypes.like.name,
                              sender: FirebaseAuth.instance.currentUser!.uid,
                              receiver: post.uid,
                              text: 'Liked you a post.',
                              objectId: post.id,
                              timestamp: Timestamp.fromDate(
                                DateTime.now(),
                              ),
                            ),
                          );
                          if (user.token != null && user.pushNotification) {
                            FirebaseMessagingServices().sendNotification(
                                user,
                                'Post Liked',
                                'have liked your post check it out.');
                          }
                        }
                        PostServices.like(post);
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            Icon(
                              post.likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid)
                                  ? CupertinoIcons.heart_fill
                                  : CupertinoIcons.heart,
                              color: Colors.red,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${post.likes.length} Likes',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 8.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    //Comments
                    GestureDetector(
                      onTap: () {
                        AppCustomNavigator.push(
                          context,
                          CommentScreen(
                            post: post,
                          ),
                        );
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            const Icon(Icons.comment_rounded),
                            SizedBox(width: 1.w),
                            Text('${post.comment.length} Comments',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontSize: 8.sp))
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          _showShareBottomSheet(context, post.description!),
                      child: SizedBox(
                        child: Row(
                          children: [
                            const Icon(Icons.share),
                            SizedBox(width: 1.w),
                            Text(
                              'Shares',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(fontSize: 8.sp),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 0.5.h),
        Divider(
          height: 0.5.h,
          color: AppColors.borderColor.withOpacity(0.5),
        ),
      ],
    );
  }
}

void _showShareBottomSheet(BuildContext context, String text) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(
              'Share on WhatsApp',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap: () {
              _shareUrlOnWhatsApp(text);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void _shareUrlOnWhatsApp(String text) {
  SocialShare.shareWhatsapp(text);
}
