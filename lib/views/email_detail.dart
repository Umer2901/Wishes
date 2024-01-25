import 'package:intl/intl.dart';
import 'package:wishes_app/views/compose_email.dart';
import 'package:wishes_app/export.dart';

class EmailDetailScreen extends StatelessWidget {
  final AppUser user;
  final Email email;
  const EmailDetailScreen({super.key, required this.user, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [const Icon(Icons.more_horiz), SizedBox(width: 3.w)],
        leading: GestureDetector(
          onTap: () => AppCustomNavigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (email.subject != null)
              Padding(
                padding: EdgeInsets.only(left: 3.w),
                child: Text(
                  email.subject!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.imageURL!),
              ),
              title: Text(
                user.name,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              subtitle: Text(
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
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: AppColors.grayColor,
                  borderRadius: BorderRadius.circular(12.sp),
                ),
                child: Text(
                  email.description,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 10.sp, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.center,
              child: CustomButton(
                foregroundColor: AppColors.blackColor.withOpacity(0.5),
                borderColor: AppColors.grayColor,
                backgroundColor: AppColors.whiteColor,
                height: 6.h,
                width: 90.w,
                borderRadius: 20.sp,
                icon: AppSvgs.replyIcon,
                iconColor: AppColors.blackColor.withOpacity(0.5),
                label: 'Send a Reply',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComposeEmailScreen(
                        user: user,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
