import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:wishes_app/export.dart';

class CommentContainer extends StatelessWidget {
  final AppUser user;
  final Comment comment;
  final Function(String) onReplyTap;
  const CommentContainer({
    super.key,
    required this.user,
    required this.comment,
    required this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Column(
          children: [
            Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: CircleAvatar(
                    radius: 5.w,
                    backgroundImage: NetworkImage(user.imageURL!),
                  ),
                  title: Text(
                    user.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  subtitle: Text(
                    DateTime.now()
                                .difference(DateTime.fromMicrosecondsSinceEpoch(
                                    comment.timestamp.microsecondsSinceEpoch))
                                .inDays <
                            1
                        ? DateTime.now()
                                    .difference(
                                        DateTime.fromMicrosecondsSinceEpoch(comment
                                            .timestamp.microsecondsSinceEpoch))
                                    .inHours >=
                                1
                            ? '${DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(comment.timestamp.microsecondsSinceEpoch)).inHours.toString()} hours ago'
                            : DateTime.now()
                                        .difference(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                comment.timestamp
                                                    .microsecondsSinceEpoch))
                                        .inMinutes >=
                                    1
                                ? '${(DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(comment.timestamp.microsecondsSinceEpoch)).inMinutes % 60).toString()} mins ago'
                                : '${DateTime.now().difference(DateTime.fromMicrosecondsSinceEpoch(comment.timestamp.microsecondsSinceEpoch)).inSeconds.toString()} sec ago'
                        : DateFormat('dd-MM-yyyy')
                            .format(DateTime.fromMicrosecondsSinceEpoch(comment.timestamp.microsecondsSinceEpoch)),
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontSize: 8.sp),
                  ),
                ),
                SizedBox(height: 1.h),
                if (comment.commentDescription != null &&
                    comment.commentDescription != 'null')
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      comment.commentDescription!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
              ],
            ),
            SizedBox(height: 1.h),
            if (comment.commentImageURL.length == 1)
              Container(
                constraints: BoxConstraints(maxHeight: 40.h),
                width: double.infinity,
                margin:
                    const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  image: DecorationImage(
                      image: NetworkImage(
                        comment.commentImageURL[0],
                      ),
                      fit: BoxFit.cover),
                ),
              ),
            if (comment.commentImageURL.length == 2)
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
                      width: 34.w,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0.5, vertical: 0.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(
                            image: NetworkImage(
                              comment.commentImageURL[0],
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      width: 1.5.w,
                    ),
                    Container(
                      height: 25.h,
                      width: 34.w,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 0.5, vertical: 0.5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(
                              comment.commentImageURL[1],
                            ),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              ),
            if (comment.commentImageURL.length > 2)
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
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                              image: NetworkImage(
                                comment.commentImageURL[0],
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
                                    comment.commentImageURL[1],
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
                                    comment.commentImageURL[2],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Likes
                GestureDetector(
                  onTap: () {
                    CommentServices.like(comment);
                  },
                  child: SizedBox(
                    child: Row(
                      children: [
                        Icon(
                          comment.likes.contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: Colors.red,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${comment.likes.length} Likes',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontSize: 8.sp),
                        )
                      ],
                    ),
                  ),
                ),
                // //Comments
                GestureDetector(
                  onTap: () {
                    onReplyTap(comment.commentId);
                  },
                  child: SizedBox(
                    child: Row(
                      children: [
                        const Icon(Icons.comment_rounded),
                        SizedBox(width: 1.w),
                        Text('Reply',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(fontSize: 8.sp))
                      ],
                    ),
                  ),
                ),
                //Shares
                GestureDetector(
                  onTap: () => _showShareBottomSheet(
                      context, comment.commentDescription ?? ''),
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
            const Divider(),
          ],
        ));
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
