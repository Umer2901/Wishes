import 'package:intl/intl.dart';
import 'package:wishes_app/export.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/home.png'),
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              AppCustomNavigator.push(context, const SettingScreen());
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        child: StreamBuilder(
            stream: UserServices.stream(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              return StreamBuilder(
                stream: PostServices.userStream(
                    FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot2) {
                  if (snapshot.hasData &&
                      snapshot2.connectionState != ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 10.w,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.imageURL!),
                            ),
                            CustomButton(
                              height: 5.5.h,
                              width: 30.w,
                              borderRadius: 30.sp,
                              label: 'Edit Profile',
                              onPressed: () {
                                AppCustomNavigator.push(
                                  context,
                                  EditProfileScreen(user: snapshot.data!),
                                );
                              },
                              backgroundColor: AppColors.whiteColor,
                              borderColor: AppColors.blackColor,
                              foregroundColor: AppColors.blackColor,
                            )
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          (snapshot.data!.name),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '@${snapshot.data!.username}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 0.25.h),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 8.sp,
                              color: AppColors.blackColor.withOpacity(0.5),
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              DateFormat('MMMM dd, yyyy').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                  snapshot
                                      .data!.joiningDate.microsecondsSinceEpoch,
                                ),
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: 8.sp,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          snapshot.data!.bio ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                AppCustomNavigator.push(
                                  context,
                                  FollowersScreen(user: snapshot.data!),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: snapshot.data!.followers.length
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
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            GestureDetector(
                              onTap: () {
                                AppCustomNavigator.push(
                                  context,
                                  FollowingScreen(uid: snapshot.data!.uid),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  text: snapshot.data!.following.length
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                  children: [
                                    TextSpan(
                                      text: ' Following',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            RichText(
                              text: TextSpan(
                                text: (snapshot2.data?.length ?? 0).toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                children: [
                                  TextSpan(
                                    text: ' Posts',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (snapshot2.hasData)
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  for (var snap in snapshot2.data!) ...{
                                    PostContainer(
                                      user: snap['user'],
                                      post: snap['post'],
                                      isProfilePost: true,
                                    ),
                                  }
                                ],
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Center(
                              child: Text(
                                'No Post',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        SizedBox(height: 2.h),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }),
      ),
    );
  }
}
