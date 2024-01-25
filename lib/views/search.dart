import 'package:wishes_app/export.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            AppCustomNavigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                elevation: MaterialStateProperty.all(0.5),
                backgroundColor:
                    MaterialStateProperty.all(AppColors.fieldFillColor),
                hintText: 'Search here...',
                hintStyle: MaterialStatePropertyAll(
                  Theme.of(context).textTheme.bodyMedium,
                ),
                controller: _searchController,
                onChanged: (query) {
                  setState(() {});
                },
                trailing: const [
                  Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                  )
                ],
              ),
              SizedBox(height: 2.h),
              Text(
                'Suggested',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(
                height: 1.h,
              ),
              isLoading
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          var users = snapshot.data!.docs;
                          users.removeWhere(
                            (user) => (user.id ==
                                    FirebaseAuth.instance.currentUser!.uid ||
                                !(user['name'].toLowerCase().contains(
                                    _searchController.text.toLowerCase())) ||
                                user['block'].contains(
                                    FirebaseAuth.instance.currentUser!.uid)),
                          );

                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var user in users) ...{
                                  buildUserListTile(AppUser.fromDoc(user)),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                }
                              ],
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserListTile(AppUser user) {
    return ListTile(
      onTap: () {
        AppCustomNavigator.push(context, OtherUserProfileScreen(user: user));
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          color: AppColors.fieldFillColor,
        ),
      ),
      tileColor: AppColors.fieldFillColor,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          user.imageURL!,
        ),
      ),
      title: Text(
        user.name,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: Text(
        '${user.followers.length} Followers',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: SizedBox(
        height: 3.h,
        width: 26.5.w,
        child: OutlinedButton(
          onPressed: () {
            if (!requested.contains(user.uid)) {
              if (user.followers
                  .contains(FirebaseAuth.instance.currentUser!.uid)) {
                UserServices.unfollow(
                    FirebaseAuth.instance.currentUser!.uid, user.uid);
              } else {
                if (user.privateProfile) {
                  setState(() {
                    requested.add(user.uid);
                  });
                  NotificationServices.create(
                    AppNotification(
                      id: '',
                      type: NotificationTypes.request.name,
                      sender: FirebaseAuth.instance.currentUser!.uid,
                      receiver: user.uid,
                      text: 'Requested to follow you.',
                      objectId: '',
                      timestamp: Timestamp.fromDate(DateTime.now()),
                    ),
                  );
                } else {
                  UserServices.follow(
                      FirebaseAuth.instance.currentUser!.uid, user.uid);
                }
              }
            }
          },
          child: Text(
            requested.contains(user.uid)
                ? 'Requested'
                : user.followers
                        .contains(FirebaseAuth.instance.currentUser!.uid)
                    ? 'Following'
                    : 'Follow',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 8.sp),
          ),
        ),
      ),
    );
  }
}
