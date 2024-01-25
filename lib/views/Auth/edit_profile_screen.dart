import 'dart:io';
import 'package:intl/intl.dart';
import 'package:wishes_app/export.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? image;

  DateTime? date;

  final _formKey = GlobalKey<FormBuilderState>();

  final _gender = ["Male", "Female", "Other"];

  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: GestureDetector(
          onTap: () => AppCustomNavigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          child: Center(
              child: Column(
            children: [
              InkWell(
                child: Column(
                  children: [
                    image != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(image!),
                            radius: 50,
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.user.imageURL.toString()),
                            radius: 50,
                          ),
                    SizedBox(height: 1.h),
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
                      child: Text(
                        'Change Photo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ],
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
                        'Username',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 1.h),
                      CustomTextField(
                        hintText: 'Enter here',
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        initialValue: widget.user.username,
                        name: 'username',
                        fillColor: AppColors.fieldFillColor,
                        validator: FormBuilderValidators.required(),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.user.accountType == 'Personal'
                            ? 'Your Name'
                            : 'Company Name',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 1.h),
                      CustomTextField(
                        hintText: 'Enter Name',
                        initialValue: widget.user.name,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        name: 'name',
                        fillColor: AppColors.fieldFillColor,
                        validator: FormBuilderValidators.required(),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Email',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 1.h),
                      CustomTextField(
                        hintText: 'abc@example.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        initialValue: widget.user.email,
                        name: 'email',
                        fillColor: AppColors.fieldFillColor,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.email(),
                          ],
                        ),
                      ),
                      if (widget.user.accountType == 'Personal')
                        SizedBox(height: 2.h),
                      if (widget.user.accountType == 'Personal')
                        Text(
                          'Gender',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      if (widget.user.accountType == 'Personal')
                        SizedBox(height: 1.h),
                      if (widget.user.accountType == 'Personal')
                        CustomDropdown(
                          items: _gender.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            );
                          }).toList(),
                          name: 'gender',
                          hintText: 'Gender',
                          initialValue: widget.user.gender,
                          fillColor: AppColors.fieldFillColor,
                          validator: FormBuilderValidators.compose([
                            if (widget.user.accountType == 'Personal')
                              FormBuilderValidators.required()
                          ]),
                        ),
                      SizedBox(height: 2.h),
                      if (widget.user.accountType == 'Personal')
                        Text(
                          'Date of Birth',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      if (widget.user.accountType == 'Company')
                        Text(
                          'Formation Date',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
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
                                Text(
                                  DateFormat('dd-MM-yyyy').format(
                                    date ??
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            widget.user.date
                                                .microsecondsSinceEpoch),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Bio',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 1.h),
                      CustomTextField(
                        hintText: '',
                        maxLines: 3,
                        initialValue: widget.user.bio,
                        keyboardType: TextInputType.emailAddress,
                        name: 'bio',
                        fillColor: AppColors.fieldFillColor,
                      ),
                      SizedBox(height: 2.h),
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
                                isLoading: true,
                                label: 'Save',
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
                                label: 'Save',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    AuthenticationState authState =
                                        BlocProvider.of<AuthenticationCubit>(
                                                context)
                                            .state;
                                    if (authState is Authenticated) {
                                      BlocProvider.of<PostCubit>(context)
                                          .updateUser(
                                              authState.user!.uid,
                                              {
                                                'username': _formKey
                                                    .currentState
                                                    ?.fields['username']
                                                    ?.value,
                                                'name': _formKey.currentState
                                                    ?.fields['name']?.value,
                                                'email': _formKey.currentState
                                                    ?.fields['email']?.value,
                                                'gender':
                                                    widget.user.accountType ==
                                                            'Personal'
                                                        ? _formKey
                                                            .currentState
                                                            ?.fields['gender']
                                                            ?.value
                                                        : null,
                                                'date': date == null
                                                    ? widget.user.date
                                                    : Timestamp.fromDate(
                                                        DateTime(
                                                            date!.year,
                                                            date!.month,
                                                            date!.day),
                                                      ),
                                                'bio': _formKey.currentState
                                                    ?.fields['bio']?.value,
                                              },
                                              image)
                                          .whenComplete(
                                            () =>
                                                AppCustomNavigator.pop(context),
                                          );
                                    }
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
            ],
          )),
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
