import 'dart:io';
import 'package:intl/intl.dart';
import 'package:wishes_app/export.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  File? image;
  final _formKey = GlobalKey<FormBuilderState>();
  DateTime date = DateTime.now();

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/appbar.png'),
                SizedBox(height: 5.h),
                GestureDetector(
                  onTap: () async {
                    final XFile? pickedImage = await picker.pickImage(
                        imageQuality: 10, source: ImageSource.gallery);

                    if (pickedImage != null) {
                      setState(() {
                        image = File(pickedImage.path);
                      });
                    }
                  },
                  child: image == null
                      ? const CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          radius: 50,
                          child: Icon(
                            Icons.account_circle,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(image!),
                          radius: 50,
                        ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  margin: const EdgeInsets.only(top: 20),
                  child: FormBuilder(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Account Type',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        CustomDropdown(
                          name: 'type',
                          hintText: 'Select Type',
                          fillColor: AppColors.fieldFillColor,
                          initialValue: "Personal",
                          onChanged: (value) {
                            setState(() {});
                          },
                          items: ["Personal", "Company"].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Username',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 1.h),
                        CustomTextField(
                          hintText: 'Enter here',
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          name: 'username',
                          fillColor: AppColors.fieldFillColor,
                          validator: FormBuilderValidators.required(),
                        ),
                        SizedBox(height: 2.h),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Personal')
                          Text(
                            'Your Name',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Company')
                          Text(
                            'Company Name',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        SizedBox(height: 1.h),
                        CustomTextField(
                          hintText: 'Enter here',
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          maxLines: 1,
                          name: 'name',
                          fillColor: AppColors.fieldFillColor,
                          validator: FormBuilderValidators.required(),
                        ),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Personal')
                          SizedBox(height: 2.h),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Personal')
                          Text(
                            "What’s your Gender?",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Personal')
                          SizedBox(height: 1.h),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Personal')
                          CustomDropdown(
                            items:
                                ["Male", "Female", "Other"].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              );
                            }).toList(),
                            name: 'gender',
                            hintText: 'Select Gender',
                            fillColor: AppColors.fieldFillColor,
                            validator: FormBuilderValidators.compose([
                              if ((_formKey.currentState?.fields['type']
                                          ?.value ??
                                      'Personal') ==
                                  'Personal')
                                FormBuilderValidators.required()
                            ]),
                          ),
                        SizedBox(height: 2.h),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Personal')
                          Text(
                            "Your Date of Birth?",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        if ((_formKey.currentState?.fields['type']?.value ??
                                'Personal') ==
                            'Company')
                          Text(
                            "Formation Date?",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        SizedBox(height: 1.h),
                        GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.fieldFillColor,
                                borderRadius: BorderRadius.circular(20.sp)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 1.5.h,
                                horizontal: 4.w,
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(formattedDate),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                BlocConsumer<PostCubit, PostState>(
                  listener: (context, state) {
                    if (state is PostingError) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          state.error.split(':').last.trim(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: Colors.redAccent,
                      ));
                    }
                  },
                  builder: (context, state) {
                    if (state is PostingData) {
                      return Align(
                        alignment: Alignment.center,
                        child: CustomButton(
                          foregroundColor: AppColors.whiteColor,
                          borderColor: AppColors.grayColor,
                          height: 6.h,
                          width: 70.w,
                          borderRadius: 20.sp,
                          label: 'Next',
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
                          label: 'Next',
                          onPressed: () {
                            if (image == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                  'No Image Selected!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.redAccent,
                              ));
                            }
                            if (_formKey.currentState!.validate() &&
                                image != null) {
                              BlocProvider.of<PostCubit>(context)
                                  .createNewUser(
                                      AppUser(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid,
                                        username: _formKey.currentState
                                            ?.fields['username']?.value,
                                        name: _formKey.currentState
                                            ?.fields['name']?.value,
                                        imageURL: '',
                                        gender: (_formKey
                                                        .currentState
                                                        ?.fields['type']
                                                        ?.value ??
                                                    'Personal') ==
                                                'Personal'
                                            ? _formKey.currentState
                                                ?.fields['gender']?.value
                                            : null,
                                        date: Timestamp.fromDate(
                                          DateTime(
                                              date.year, date.month, date.day),
                                        ),
                                        followers: [],
                                        following: [],
                                        block: [],
                                        accountType: _formKey.currentState
                                            ?.fields['type']?.value,
                                        joiningDate:
                                            Timestamp.fromDate(DateTime.now()),
                                      ),
                                      image!)
                                  .whenComplete(
                                    () => BlocProvider.of<AuthenticationCubit>(
                                            context)
                                        .authenticate(),
                                  );
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }
}
