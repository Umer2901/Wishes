import 'package:intl/intl.dart';
import 'package:wishes_app/export.dart';

class OtherUserProfileScreen extends StatefulWidget {
  final AppUser user;
  const OtherUserProfileScreen({super.key, required this.user});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen> {
  bool isLoading = true;
  List<String> requested = [];

  @override
  void initState() {
    super.initState();
    config();
  }

  config() async {
    List<AppNotification>? notificationDoc =
        await NotificationServices.fetchAll();

    if (notificationDoc != null) {
      for (var element in notificationDoc) {
        if (element.type == 'request') {
          requested.add(element.receiver);
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

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
          widget.user.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: UserServices.stream(widget.user.uid),
                builder: (context, snapshot2) {
                  return StreamBuilder(
                      stream: PostServices.userStream(widget.user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: 10.w,
                                    backgroundImage:
                                        NetworkImage(snapshot2.data!.imageURL!),
                                  ),
                                  if (snapshot2.data!.uid !=
                                      FirebaseAuth.instance.currentUser!.uid)
                                    CustomButton(
                                      height: 5.5.h,
                                      width: 30.w,
                                      borderRadius: 30.sp,
                                      label: requested.contains(widget.user.uid)
                                          ? 'Requested'
                                          : snapshot2.data!.followers.contains(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid)
                                              ? 'Following'
                                              : 'Follow',
                                      onPressed: () async {
                                        if (!requested
                                            .contains(widget.user.uid)) {
                                          if (snapshot2.data!.followers
                                              .contains(FirebaseAuth
                                                  .instance.currentUser!.uid)) {
                                            await UserServices.unfollow(
                                                FirebaseAuth
                                                    .instance.currentUser!.uid,
                                                widget.user.uid);
                                          } else {
                                            if (widget.user.privateProfile) {
                                              setState(() {
                                                requested.add(widget.user.uid);
                                              });
                                              NotificationServices.create(
                                                AppNotification(
                                                  id: '',
                                                  type: NotificationTypes
                                                      .request.name,
                                                  sender: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  receiver: widget.user.uid,
                                                  text:
                                                      'Requested to follow you.',
                                                  objectId: '',
                                                  timestamp: Timestamp.fromDate(
                                                      DateTime.now()),
                                                ),
                                              );
                                            } else {
                                              UserServices.follow(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  widget.user.uid);
                                            }
                                          }
                                        }
                                      },
                                      backgroundColor: AppColors.whiteColor,
                                      borderColor: AppColors.primaryColor,
                                      foregroundColor: AppColors.primaryColor,
                                    )
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                snapshot2.data!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 10.sp,
                                    color:
                                        AppColors.blackColor.withOpacity(0.5),
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    DateFormat('dd-MM-yyyy').format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          snapshot2.data!.date
                                              .microsecondsSinceEpoch),
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                snapshot2.data!.bio ?? '',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(height: 1.h),
                              RichText(
                                text: TextSpan(
                                  text: snapshot2.data?.followers.length
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: ' Followers',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    TextSpan(
                                      text:
                                          '\t\t${snapshot2.data?.following.length}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' Following',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    TextSpan(
                                      text:
                                          '\t\t${(snapshot.data?.length ?? 0).toString()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    TextSpan(
                                      text: ' Posts',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Expanded(
                                child: (snapshot2.data!.privateProfile &&
                                        snapshot2.data!.uid !=
                                            FirebaseAuth
                                                .instance.currentUser!.uid &&
                                        !snapshot2.data!.followers.contains(
                                            FirebaseAuth
                                                .instance.currentUser!.uid))
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Image(
                                              image: NetworkImage(
                                                  'https://thumbs.dreamstime.com/b/default-avatar-profile-image-vector-social-media-user-icon-potrait-182347582.jpg',
                                                  scale: 5),
                                            ),
                                            Text(
                                              'Private Profile',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                          ],
                                        ),
                                      )
                                    : snapshot.hasData
                                        ? SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                for (var snap
                                                    in snapshot.data!) ...{
                                                  PostContainer(
                                                    user: snap['user'],
                                                    post: snap['post'],
                                                  ),
                                                }
                                              ],
                                            ),
                                          )
                                        : Expanded(
                                            child: Center(
                                              child: Text(
                                                'No Post',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            ),
                                          ),
                              )
                            ],
                          );
                        }
                      });
                }),
      ),
    );
  }
}
