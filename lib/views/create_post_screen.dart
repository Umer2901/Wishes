import 'dart:io';
import 'package:toastification/toastification.dart';
import 'package:wishes_app/export.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<XFile> postImages = [];

  bool isLoading = true;

  AppUser? user;

  @override
  void initState() {
    super.initState();
    config();
  }

  config() async {
    user = await UserServices.fetch(FirebaseAuth.instance.currentUser!.uid);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ksize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('assets/images/home.png'),
        title: Text(
          'Create Post',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            child: Align(
                              alignment: user!.language == 'English'
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Text(
                                user!.accountType != 'Personal'
                                    ? user!.language == 'English'
                                        ? 'We Wish'
                                        : 'نتمنى'
                                    : user!.language == 'English'
                                        ? 'I Wish'
                                        : 'أتمنى',
                                style: user!.language == 'English'
                                    ? TextStyle(
                                        fontFamily: 'MCPU',
                                        fontSize: 16.sp,
                                      )
                                    : TextStyle(
                                        fontFamily: 'Arabic',
                                        fontSize: 26.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: user!.language == 'English' ? 1.h : 0),
                          user!.language == 'English'
                              ? FormBuilder(
                                  key: _formKey,
                                  child: CustomTextField(
                                    name: 'post',
                                    hintText: 'What\'s on your mind?',
                                    fillColor: Colors.transparent,
                                    enableBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    validator: FormBuilderValidators.required(),
                                    maxLines: 16,
                                  ),
                                )
                              : FormBuilder(
                                  key: _formKey,
                                  child: CustomTextField(
                                    name: 'post',
                                    hintText: 'ما الذي يدور في ذهنك؟',
                                    fillColor: Colors.transparent,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    enableBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    validator: FormBuilderValidators.required(),
                                    maxLines: 16,
                                  ),
                                ),
                          SizedBox(height: ksize.height < 820 ? 2.h : 15.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: SizedBox(
                              height: 10.h,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();

                                      final XFile? image =
                                          await picker.pickImage(
                                              imageQuality: 10,
                                              source: ImageSource.gallery);

                                      if (image != null) {
                                        setState(() {
                                          postImages.add(image);
                                        });
                                      }
                                    },
                                    child: SizedBox(
                                      width: 20.w,
                                      child: Container(
                                        height: 12.h,
                                        width: 22.w,
                                        decoration: BoxDecoration(
                                          color: AppColors.fieldFillColor,
                                          borderRadius:
                                              BorderRadius.circular(5.sp),
                                        ),
                                        child: Icon(
                                          Icons.image_rounded,
                                          color: AppColors.blackColor
                                              .withOpacity(0.3),
                                          size: 28.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: postImages
                                            .map(
                                              (image) => Padding(
                                                padding:
                                                    EdgeInsets.only(right: 2.w),
                                                child: Container(
                                                  height: 12.h,
                                                  width: 22.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.sp),
                                                    image: DecorationImage(
                                                      image: FileImage(
                                                        File(image.path),
                                                      ),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        postImages
                                                            .remove(image);
                                                      });
                                                    },
                                                    child: const Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Icon(
                                                        Icons.cancel,
                                                        color: AppColors
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 1.5.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: BlocConsumer<PostCubit, PostState>(
                              listener: (context, state) {
                                if (state is PostingError) {
                                  debugPrint(state.error);
                                }
                              },
                              builder: (context, state) {
                                if (state is PostingData) {
                                  return Align(
                                    alignment: Alignment.center,
                                    child: CustomButton(
                                      foregroundColor: AppColors.whiteColor,
                                      borderColor: AppColors.grayColor,
                                      height: 6.5.h,
                                      width: 100.w,
                                      borderRadius: 30.sp,
                                      label: 'Post',
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
                                      height: 6.5.h,
                                      width: 100.w,
                                      borderRadius: 30.sp,
                                      label: 'Post',
                                      onPressed: () {
                                        if (_formKey.currentState!
                                                    .fields['post']?.value !=
                                                null ||
                                            postImages.isNotEmpty) {
                                          AuthenticationState authState =
                                              BlocProvider.of<
                                                          AuthenticationCubit>(
                                                      context)
                                                  .state;
                                          if (authState is Authenticated) {
                                            BlocProvider.of<PostCubit>(context)
                                                .createNewPost(
                                                  Post(
                                                    id: '',
                                                    uid: FirebaseAuth.instance
                                                            .currentUser?.uid ??
                                                        '',
                                                    description: _formKey
                                                        .currentState!
                                                        .fields['post']!
                                                        .value,
                                                    postImageURL: [],
                                                    comment: [],
                                                    likes: [],
                                                    timestamp:
                                                        Timestamp.fromDate(
                                                      DateTime.now(),
                                                    ),
                                                    language: user!.language,
                                                  ),
                                                  postImages
                                                      .map(
                                                        (image) =>
                                                            File(image.path),
                                                      )
                                                      .toList(),
                                                )
                                                .whenComplete(
                                                  () => AppCustomNavigator
                                                      .replace(
                                                    context,
                                                    const BottomNavBarScreen(),
                                                  ),
                                                );
                                          }
                                        } else {
                                          toastification.show(
                                            context: context,
                                            type: ToastificationType.error,
                                            style: ToastificationStyle.flat,
                                            autoCloseDuration:
                                                const Duration(seconds: 2),
                                            title:
                                                'Image or Description Required',
                                            description:
                                                'Add image or description to create a post.',
                                            alignment: Alignment.topRight,
                                            direction: TextDirection.ltr,
                                            animationDuration: const Duration(
                                                milliseconds: 300),
                                            icon: const Icon(Icons.check),
                                            primaryColor: AppColors.grayColor,
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 16),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 8),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x07000000),
                                                blurRadius: 16,
                                                offset: Offset(0, 16),
                                                spreadRadius: 0,
                                              )
                                            ],
                                            showProgressBar: false,
                                            closeButtonShowType:
                                                CloseButtonShowType.onHover,
                                            closeOnClick: false,
                                            pauseOnHover: true,
                                            dragToClose: true,
                                            callbacks: ToastificationCallbacks(
                                              onTap: (toastItem) {},
                                              onCloseButtonTap: (toastItem) {},
                                              onAutoCompleteCompleted:
                                                  (toastItem) {},
                                              onDismissed: (toastItem) {},
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
