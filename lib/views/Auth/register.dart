import 'package:wishes_app/export.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: '92',
    countryCode: 'PK',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Pakistan',
    example: 'Pakistan',
    displayName: 'Pakistan',
    displayNameNoCountryCode: 'PK',
    e164Key: '',
  );

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(),
                    SizedBox(height: 4.h),
                    Text('Phone Number',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 10),
                    Text(
                        "Add your phone number. We'll send you a verification code.",
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 20),
                    CustomTextField(
                      name: 'phoneNumber',
                      hintText: 'Enter Phone Number',
                      fillColor: AppColors.fieldFillColor,
                      keyboardType: TextInputType.phone,
                      validator: FormBuilderValidators.required(),
                      prefixIcon: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 14),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                onSelect: (value) {
                                  setState(() {
                                    selectedCountry = value;
                                  });
                                },
                                countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 550));
                          },
                          child: Text(
                            '${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 55.h),
                    BlocConsumer<AuthenticationCubit, AuthenticationState>(
                      builder: (context, state) {
                        if (state is AuthenticationLoading) {
                          return Align(
                            alignment: Alignment.center,
                            child: CustomButton(
                              foregroundColor: AppColors.whiteColor,
                              borderColor: AppColors.grayColor,
                              height: 6.h,
                              width: 70.w,
                              borderRadius: 20.sp,
                              label: 'Send Code',
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
                              label: 'Send Code',
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  await BlocProvider.of<AuthenticationCubit>(
                                          context)
                                      .phoneAuthentication(
                                    context: context,
                                    phoneNumber:
                                        '+${selectedCountry.phoneCode}${_formKey.currentState!.fields['phoneNumber']!.value.toString().trim()}',
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
                              state.error.split(":").last.trim(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.redAccent,
                          ));
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
