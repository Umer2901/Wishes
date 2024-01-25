import '../export.dart';
import 'package:intl/intl.dart';
import 'package:wishes_app/views/email_detail.dart';
import 'package:wishes_app/views/compose_email.dart';

class AllEmailScreen extends StatefulWidget {
  const AllEmailScreen({super.key});
  @override
  State<AllEmailScreen> createState() => _AllEmailScreenState();
}

class _AllEmailScreenState extends State<AllEmailScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 3.w),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.5.h,
                  horizontal: 6.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/images/inbox.png'),
                    InkWell(
                        onTap: () {
                          setState(() {
                            isSearched = !isSearched;
                          });
                        },
                        child: const Icon(Icons.search))
                  ],
                ),
              ),
              SizedBox(
                height: 3.h,
              ),
              if (isSearched)
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
              SizedBox(
                height: 2.h,
              ),
              StreamBuilder(
                stream: EmailService.emailStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                        child: Center(child: CircularProgressIndicator()));
                  } else {
                    if (snapshot.hasData) {
                      List<Map<String, dynamic>> filteredEmails = snapshot.data!
                          .where((user) => (user['user']
                              .name
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase())))
                          .toList();

                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Column(
                          children: [
                            for (var email in filteredEmails)
                              emailContainer(
                                context,
                                email['user'],
                                email['email'],
                              )
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'No Email',
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: TextButton.icon(
        style: TextButton.styleFrom(backgroundColor: AppColors.primaryColor),
        onPressed: () {
          AppCustomNavigator.push(
            context,
            const ComposeEmailScreen(),
          );
        },
        icon: Icon(
          color: AppColors.whiteColor,
          Icons.edit,
          size: 10.sp,
        ),
        label: Text(
          'New Email',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: 8.sp,
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget emailContainer(BuildContext context, AppUser user, Email email) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmailDetailScreen(
                  user: user,
                  email: email,
                ),
              ),
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user.imageURL!),
          ),
          title: Text(
            user.name,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (email.subject != null)
                Text(
                  email.subject!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 8.sp, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                email.description,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontSize: 8.sp),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )
            ],
          ),
          trailing: Text(
            DateTime.now()
                        .difference(DateTime.fromMicrosecondsSinceEpoch(
                            email.timestamp.microsecondsSinceEpoch))
                        .inDays <
                    1
                ? DateFormat('hh:mm a').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        email.timestamp.microsecondsSinceEpoch))
                : DateFormat('dd-MM-yyyy').format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        email.timestamp.microsecondsSinceEpoch)),
            style:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 8.sp),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
