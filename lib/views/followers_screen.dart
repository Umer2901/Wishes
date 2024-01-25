import 'package:wishes_app/export.dart';

class FollowersScreen extends StatelessWidget {
  final AppUser user;
  const FollowersScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserServices.profileFollowerStream(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    AppCustomNavigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                title: Text(
                  '${snapshot.data!.length} Followers',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 4.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int i = 0; i < snapshot.data!.length; i++) ...{
                        const Divider(),
                        ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          leading: CircleAvatar(
                            radius: 10.w,
                            backgroundImage:
                                NetworkImage(snapshot.data![i].imageURL!),
                          ),
                          title: Text(
                            snapshot.data![i].name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          subtitle: Text(
                            '${snapshot.data![i].followers.length} Followers . ${snapshot.data![i].following.length} Following',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontSize: 8.sp),
                          ),
                          trailing: SizedBox(
                            width: 30.w,
                            child: Row(
                              children: [
                                CustomButton(
                                  height: 4.5.h,
                                  width: 20.w,
                                  borderRadius: 30.sp,
                                  label: user.following
                                          .contains(snapshot.data![i].uid)
                                      ? 'Following'
                                      : 'Follow',
                                  labelFontSize: 9.sp,
                                  backgroundColor: AppColors.blackColor,
                                  borderColor: AppColors.blackColor,
                                  onPressed: () {
                                    if (user.followers.contains(FirebaseAuth
                                        .instance.currentUser!.uid)) {
                                      UserServices.unfollow(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          snapshot.data![i].uid);
                                    } else {
                                      UserServices.follow(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          snapshot.data![i].uid);
                                    }
                                  },
                                ),
                                SizedBox(width: 2.w),
                                PopupMenuButton<String>(
                                  color: AppColors.whiteColor,
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'block',
                                        child: Row(
                                          children: [
                                            const Icon(Icons.warning),
                                            SizedBox(width: 0.5.w),
                                            const Text('Block User'),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected: (String choice) {
                                    if (choice == 'block') {
                                      UserServices.block(snapshot.data![i].uid);
                                    }
                                  },
                                  child: const Icon(Icons.more_horiz),
                                ),
                              ],
                            ),
                          ),
                        )
                      }
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    AppCustomNavigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                title: Text(
                  '0 Followers',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                centerTitle: true,
              ),
              body: Center(
                child: Text(
                  'No Followers',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
