import 'package:wishes_app/export.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit , AuthenticationState>(builder: (context, state) {
      if (state is AuthenticationLoading) {
        return const Material(
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ),
        );
      } else {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              SizedBox(
                height: 50.h,
                child: Center(
                  child: Image.asset('assets/images/welcome.png'),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Welcome to Wishes',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 1.h),
              Text(
                'How would you like to signup to the app',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 6.h),
              CustomButton(
                backgroundColor: AppColors.whiteColor,
                foregroundColor: AppColors.blackColor,
                borderColor: AppColors.grayColor,
                height: 6.h,
                width: 80.w,
                borderRadius: 20.sp,
                icon: AppSvgs.googleAuthIcon,
                iconColor: AppColors.primaryColor,
                label: 'Continue using Google',
                onPressed: () {
                  BlocProvider.of<AuthenticationCubit>(context)
                      .googleAuthentication();
                },
              ),
              // SizedBox(height: 2.h),
              // CustomButton(
              //   backgroundColor: AppColors.whiteColor,
              //   foregroundColor: AppColors.blackColor,
              //   borderColor: AppColors.grayColor,
              //   height: 6.h,
              //   width: 80.w,
              //   borderRadius: 20.sp,
              //   icon: AppSvgs.facebookAuthIcon,
              //   iconColor: AppColors.primaryColor,
              //   label: 'Continue using Facebook',
              //   onPressed: () {},
              // ),
              // SizedBox(height: 2.h),
              // CustomButton(
              //   backgroundColor: AppColors.whiteColor,
              //   foregroundColor: AppColors.blackColor,
              //   borderColor: AppColors.grayColor,
              //   height: 6.h,
              //   width: 80.w,
              //   borderRadius: 20.sp,
              //   icon: AppSvgs.appleAuthIcon,
              //   iconColor: AppColors.blackColor,
              //   label: 'Continue using Apple',
              //   onPressed: () {},
              // ),
              SizedBox(height: 2.h),
              CustomButton(
                backgroundColor: AppColors.whiteColor,
                foregroundColor: AppColors.blackColor,
                borderColor: AppColors.grayColor,
                height: 6.h,
                width: 80.w,
                borderRadius: 20.sp,
                icon: AppSvgs.phoneAuthIcon,
                iconColor: AppColors.primaryColor,
                label: 'Continue using Phone',
                onPressed: () {
                  AppCustomNavigator.push(
                    context,
                    const RegisterScreen(),
                  );
                },
              )
            ],
          ),
        );
      }
    });
  }
}
