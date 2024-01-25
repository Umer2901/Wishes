import 'package:wishes_app/export.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
        child: SingleChildScrollView(
          child: StreamBuilder<AppUser?>(
              stream:
                  UserServices.stream(FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Settings',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Card(
                        surfaceTintColor: AppColors.whiteColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 4.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Email Notifications',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Switch(
                                    activeColor: AppColors.whiteColor,
                                    activeTrackColor: AppColors.blackColor,
                                    value: snapshot.data!.emailNotification,
                                    onChanged: (value) {
                                      BlocProvider.of<PostCubit>(context)
                                          .updateUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        {'emailNotification': value},
                                        null,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              const Divider(),
                              SizedBox(height: 0.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Push Notifications',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Switch(
                                    activeColor: AppColors.whiteColor,
                                    activeTrackColor: AppColors.blackColor,
                                    value: snapshot.data!.pushNotification,
                                    onChanged: (value) {
                                      BlocProvider.of<PostCubit>(context)
                                          .updateUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        {'pushNotification': value},
                                        null,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              const Divider(),
                              SizedBox(height: 0.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Comment Notifications',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Switch(
                                    activeColor: AppColors.whiteColor,
                                    activeTrackColor: AppColors.blackColor,
                                    value: snapshot.data!.commentNotification,
                                    onChanged: (value) {
                                      BlocProvider.of<PostCubit>(context)
                                          .updateUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        {'commentNotification': value},
                                        null,
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              const Divider(),
                              SizedBox(height: 0.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Likes Notifications',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Switch(
                                    activeColor: AppColors.whiteColor,
                                    activeTrackColor: AppColors.blackColor,
                                    value: snapshot.data!.likesNotification,
                                    onChanged: (value) {
                                      BlocProvider.of<PostCubit>(context)
                                          .updateUser(
                                        FirebaseAuth.instance.currentUser!.uid,
                                        {'likesNotification': value},
                                        null,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Privacy Settings',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Card(
                        surfaceTintColor: AppColors.whiteColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Private Account',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Switch(
                                activeColor: AppColors.whiteColor,
                                activeTrackColor: AppColors.blackColor,
                                value: snapshot.data!.privateProfile,
                                onChanged: (value) {
                                  BlocProvider.of<PostCubit>(context)
                                      .updateUser(
                                    FirebaseAuth.instance.currentUser!.uid,
                                    {'privateProfile': value},
                                    null,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Language Settings',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Card(
                        surfaceTintColor: AppColors.whiteColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 4.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Language (${snapshot.data!.language})',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              PopupMenuButton(
                                icon: const Icon(Icons.language),
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'English',
                                    child: const Text('English'),
                                    onTap: () {
                                      UserServices.update(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          {'language': 'English'},
                                          null);
                                    },
                                  ),
                                  PopupMenuItem(
                                    value: 'Arabic',
                                    child: const Text('Arabic'),
                                    onTap: () {
                                      setState(() {
                                        UserServices.update(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            {'language': 'Arabic'},
                                            null);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Privacy & Terms',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Card(
                        surfaceTintColor: AppColors.whiteColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 4.w),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Privacy Policy',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      AppCustomNavigator.push(
                                        context,
                                        const PrivacyPolicyScreen(),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              const Divider(),
                              SizedBox(height: 0.5.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Terms of Use',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      AppCustomNavigator.push(
                                        context,
                                        const TermOfUseScreen(),
                                      );
                                    },
                                    icon: const Icon(Icons.arrow_forward_ios),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      CustomButton(
                        height: 6.5.h,
                        width: 100.w,
                        borderRadius: 25.sp,
                        label: 'Logout',
                        backgroundColor: AppColors.secondaryColor,
                        onPressed: () async {
                          await BlocProvider.of<AuthenticationCubit>(context)
                              .signout()
                              .whenComplete(
                                () => AppCustomNavigator.pop(context),
                              );
                        },
                      )
                    ],
                  );
                } else {
                  return SizedBox(
                    height: 85.h,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              }),
        ),
      ),
    );
  }
}
