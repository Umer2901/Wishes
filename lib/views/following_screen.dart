import 'package:wishes_app/export.dart';

class FollowingScreen extends StatelessWidget {
  final String uid;
  const FollowingScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserServices.profileFollowingStream(uid),
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
                  '${snapshot.data!.length} Following',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                centerTitle: true,
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: SingleChildScrollView(
                  child: Column(children: [
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        subtitle: Text(
                          '${snapshot.data![i].followers.length} Followers . ${snapshot.data![i].following.length} Following',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: 7.sp),
                        ),
                        trailing: CustomButton(
                          height: 4.5.h,
                          width: 30.w,
                          borderRadius: 30.sp,
                          label: 'Following',
                          labelFontSize: 10.sp,
                          backgroundColor: AppColors.whiteColor,
                          borderColor: AppColors.blackColor,
                          foregroundColor: AppColors.blackColor,
                          onPressed: () {
                            UserServices.unfollow(uid, snapshot.data![i].uid);
                          },
                        ),
                      ),
                    }
                  ]),
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
                  '0 Following',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                centerTitle: true,
              ),
              body: Center(
                child: Text(
                  'No Following',
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
