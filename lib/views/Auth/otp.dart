import 'package:wishes_app/export.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: FormBuilder(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(),
                    SizedBox(height: 3.h),
                    Text('Verify Phone',
                        style: Theme.of(context).textTheme.headlineMedium),
                    SizedBox(height: 2.h),
                    Text(
                      "Enter the OTP send to your phone number",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    Pinput(
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: AppColors.primaryColor)),
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                      controller: otpController,
                      validator: FormBuilderValidators.required(),
                    ),
                    SizedBox(height: 4.h),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Didn't recieve any code?",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    BlocBuilder<AuthenticationCubit, AuthenticationState>(
                        builder: (conteext, state) {
                      if (state is AuthenticationLoading) {
                        return Align(
                          alignment: Alignment.center,
                          child: TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.refresh,
                              color: AppColors.blackColor,
                            ),
                            label: Text(
                              'Resend Code',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppColors.grayColor),
                            ),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.center,
                          child: TextButton.icon(
                            onPressed: () {
                              BlocProvider.of<AuthenticationCubit>(context)
                                  .phoneAuthentication(
                                context: context,
                                phoneNumber: widget.phoneNumber,
                              );
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: AppColors.blackColor,
                            ),
                            label: Text(
                              'Resend Code',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                        );
                      }
                    }),
                    SizedBox(height: 40.h),
                    BlocConsumer<AuthenticationCubit, AuthenticationState>(
                      builder: (context, state) {
                        if (state is VerifyCode) {
                          return Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                              foregroundColor: AppColors.whiteColor,
                              borderColor: AppColors.grayColor,
                              height: 6.h,
                              width: 70.w,
                              borderRadius: 20.sp,
                              label: 'Verify',
                              isLoading: true,
                              onPressed: () {},
                            ),
                          );
                        } else {
                          return Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                              foregroundColor: AppColors.whiteColor,
                              borderColor: AppColors.grayColor,
                              height: 6.h,
                              width: 70.w,
                              borderRadius: 20.sp,
                              isLoading: false,
                              label: 'Verify',
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  BlocProvider.of<AuthenticationCubit>(context)
                                      .verifyOTP(
                                    context,
                                    otpController.text.trim(),
                                    widget.verificationId,
                                  );
                                }
                              },
                            ),
                          );
                        }
                      },
                      listener: ((context, state) {
                        if (state is AuthenticationError) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              state.error
                                  .split(":")
                                  .last
                                  .trim()
                                  .split(']')
                                  .last
                                  .trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.redAccent,
                          ));
                        }

                        if (state is RegisterAuthentication ||
                            state is Authenticated) {
                          AppCustomNavigator.pop(context);
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
