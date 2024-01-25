import 'package:toastification/toastification.dart';
import 'package:wishes_app/export.dart';

class ComposeEmailScreen extends StatefulWidget {
  final AppUser? user;
  const ComposeEmailScreen({super.key, this.user});

  @override
  State<ComposeEmailScreen> createState() => _ComposeEmailScreenState();
}

class _ComposeEmailScreenState extends State<ComposeEmailScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearching = false;
  bool isSelected = false;

  final _formKey = GlobalKey<FormBuilderState>();

  AppUser? selectedUser;

  @override
  void initState() {
    super.initState();
    selectedUser = widget.user;
    if (selectedUser != null) {
      isSelected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Compose Mail',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        leading: GestureDetector(
          onTap: () => AppCustomNavigator.pop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 0.h,
            horizontal: 4.w,
          ),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Divider(
                          color: AppColors.borderColor,
                        ),
                        SizedBox(height: 0.5.h),
                        Stack(
                          children: [
                            Column(
                              children: [
                                isSelected && selectedUser != null
                                    ? buildUserListTile(selectedUser!)
                                    : Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.h),
                                        child: SearchBar(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.sp))),
                                          elevation:
                                              MaterialStateProperty.all(0.5),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.fieldFillColor),
                                          hintText: 'Search here...',
                                          hintStyle: MaterialStatePropertyAll(
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          controller: _searchController,
                                          onChanged: (query) {
                                            setState(() {
                                              isSearching = query.isNotEmpty;
                                            });
                                          },
                                          trailing: const [
                                            Icon(
                                              Icons.search,
                                              color: AppColors.primaryColor,
                                            )
                                          ],
                                        ),
                                      ),
                                const CustomTextField(
                                  hintText: 'Type subject here',
                                  name: 'subject',
                                  fillColor: AppColors.fieldFillColor,
                                  textInputAction: TextInputAction.next,
                                ),
                                SizedBox(
                                  height: 1.h,
                                ),
                                CustomTextField(
                                  hintText: 'Start typing here ...',
                                  name: 'description',
                                  fillColor: AppColors.fieldFillColor,
                                  maxLines: 20,
                                  validator: FormBuilderValidators.required(),
                                ),
                                SizedBox(height: 4.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 4.w),
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
                                            foregroundColor:
                                                AppColors.whiteColor,
                                            borderColor: AppColors.grayColor,
                                            height: 6.5.h,
                                            width: 100.w,
                                            borderRadius: 30.sp,
                                            label: 'Send',
                                            isLoading: true,
                                            onPressed: () {},
                                          ),
                                        );
                                      } else {
                                        return Align(
                                          alignment: Alignment.center,
                                          child: CustomButton(
                                            foregroundColor:
                                                AppColors.whiteColor,
                                            borderColor: AppColors.grayColor,
                                            height: 6.5.h,
                                            width: 100.w,
                                            borderRadius: 30.sp,
                                            label: 'Send',
                                            onPressed: () {
                                              if (_formKey
                                                          .currentState!
                                                          .fields['description']
                                                          ?.value !=
                                                      null &&
                                                  selectedUser != null) {
                                                BlocProvider.of<PostCubit>(
                                                        context)
                                                    .createNewEmail(
                                                      Email(
                                                        id: '',
                                                        subject: _formKey
                                                            .currentState!
                                                            .fields['subject']
                                                            ?.value
                                                            .toString(),
                                                        timestamp:
                                                            Timestamp.fromDate(
                                                          DateTime.now(),
                                                        ),
                                                        senderUID: FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid,
                                                        recieverUID:
                                                            selectedUser!.uid,
                                                        description: _formKey
                                                            .currentState!
                                                            .fields[
                                                                'description']!
                                                            .value
                                                            .toString(),
                                                      ),
                                                    )
                                                    .whenComplete(
                                                      () => AppCustomNavigator
                                                          .pop(context),
                                                    );
                                              } else {
                                                toastification.show(
                                                  context: context,
                                                  type:
                                                      ToastificationType.error,
                                                  style:
                                                      ToastificationStyle.flat,
                                                  autoCloseDuration:
                                                      const Duration(
                                                          seconds: 2),
                                                  title: selectedUser != null
                                                      ? 'Description Required'
                                                      : 'Select User',
                                                  description: selectedUser !=
                                                          null
                                                      ? 'Add description to send the email.'
                                                      : 'Select user to send the email.',
                                                  alignment: Alignment.topRight,
                                                  direction: TextDirection.ltr,
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 300),
                                                  icon: const Icon(Icons.check),
                                                  primaryColor:
                                                      AppColors.grayColor,
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 16),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
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
                                                      CloseButtonShowType
                                                          .onHover,
                                                  closeOnClick: false,
                                                  pauseOnHover: true,
                                                  dragToClose: true,
                                                  callbacks:
                                                      ToastificationCallbacks(
                                                    onTap: (toastItem) {},
                                                    onCloseButtonTap:
                                                        (toastItem) {},
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
                                SizedBox(height: 3.h),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 7.5.h, horizontal: 0.w),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 40.0.h,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.fieldFillColor,
                                    border: Border.all(
                                        color: AppColors.borderColor),
                                    borderRadius: BorderRadius.circular(10.sp),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        if (isSearching && !isSelected)
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              var users = snapshot.data!.docs;
                                              users.removeWhere(
                                                (user) => (user.id ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid ||
                                                    !(user['name']
                                                        .toLowerCase()
                                                        .contains(_searchController
                                                            .text
                                                            .toLowerCase())) ||
                                                    (user['privateProfile'] == true &&
                                                        !user['followers']
                                                            .contains(FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid)) ||
                                                    user['block'].contains(
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid)),
                                              );

                                              return users.isNotEmpty
                                                  ? SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          for (var user
                                                              in users) ...{
                                                            buildUserListTile(
                                                                AppUser.fromDoc(
                                                                    user)),
                                                          }
                                                        ],
                                                      ),
                                                    )
                                                  : Center(
                                                      child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.h),
                                                      child: const Text(
                                                          'No users found'),
                                                    ));
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUserListTile(AppUser user) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: selectedUser != null ? 1.h : 0),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                color: AppColors.fieldFillColor,
              ),
            ),
            tileColor: AppColors.fieldFillColor,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                user.imageURL ?? 'https://example.com/placeholder.jpg',
              ),
            ),
            onTap: () {
              selectedUser == null
                  ? setState(() {
                      _searchController.clear();
                      isSearching = !isSearching;
                      isSelected = !isSelected;
                      selectedUser = user;
                    })
                  : null;
            },
            title: Text(
              user.name,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: user.email == null
                ? const Text('')
                : Text(
                    user.email!,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
          ),
        ),
        selectedUser != null
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _searchController.text = '';
                    isSearching = false;
                    isSelected = false;
                    selectedUser = null;
                  });
                },
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.w),
                    child: const Icon(
                      Icons.cancel,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
