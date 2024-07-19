import 'dart:io';
import 'package:toastification/toastification.dart';
import 'package:wishes_app/export.dart';
import 'package:wishes_app/firebase_messaging_service.dart';
import 'package:wishes_app/widgets/design/comment_container.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, required this.post});
  final Post post;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<XFile> commentImages = [];
  late Comment comment;
  // late StreamController<void> _replyController;

  AppUser? appUser;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    comment = Comment(
      commentId: '',
      senderUid: FirebaseAuth.instance.currentUser?.uid ?? '',
      recieverUid: widget.post.uid,
      postId: widget.post.id,
      parentId: '',
      commentDescription: '',
      timestamp: Timestamp.fromDate(DateTime.now()),
      commentImageURL: [],
      likes: [],
    );
    config();
    // _replyController = StreamController<void>.broadcast();
  }

  config() async {
    appUser = await UserServices.fetch(FirebaseAuth.instance.currentUser!.uid);
    setState(() {
      isLoading = false;
    });
  }

  void _handleReplyTap(String parentId) {
    comment.parentId = parentId;

    // print('parent: ${comment.parentId}');
  }

  @override
  Widget build(BuildContext context) {
    String postid = widget.post.id;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            AppCustomNavigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: StreamBuilder<int>(
          // StreamBuilder to listen for comment count changes
          stream: CommentServices()
              .getCommentCountStream(postid), // Replace with your own stream
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(
                'Comments',
                // '${snapshot.data} Comments',
                style: Theme.of(context).textTheme.headlineSmall,
              );
            } else {
              return Text(
                'Loading...',
                style: Theme.of(context).textTheme.headlineSmall,
              );
            }
          },
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0.h),
          child: const Divider(),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.h),
              child: Stack(
                children: [
                  SizedBox(
                    height: 100.h,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StreamBuilder<Map<String, dynamic>?>(
                            stream: PostServices.getPostByIdStream(
                                postid), // Replace with your postId
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (snapshot.hasData && snapshot.data != null) {
                                  // Accessing post and user from the map
                                  Post post = snapshot.data!['post'];
                                  AppUser user = snapshot.data!['user'];

                                  return SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        CommentsPostContainer(
                                          user: user,
                                          post: post,
                                          comment: comment,
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      'No Post',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          SizedBox(height: 1.h),
                          StreamBuilder<List<Map<String, dynamic>>?>(
                            stream: CommentServices.getCommentsForPost(postid),
                            builder: (context, snapshot) {
                              try {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  // print("Error: ${snapshot.error}");
                                  return const Text("Error occurred");
                                } else {
                                  if (snapshot.hasData &&
                                      snapshot.data != null &&
                                      snapshot.data!.isNotEmpty) {
                                    List<Map<String, dynamic>> comments =
                                        snapshot.data!;
                                    return Column(
                                      children: [
                                        for (var comment in comments) ...{
                                          // Text(
                                          //     'ParentID:${comment['comment'].parentId}'),
                                          // Conditionally render CommentContainer or ReplyContainer
                                          comment['comment'].parentId == ''
                                              ? CommentContainer(
                                                  user: comment['user'],
                                                  comment: comment['comment'],
                                                  onReplyTap: _handleReplyTap,
                                                )
                                              : ReplyContainer(
                                                  user: comment['user'],
                                                  comment: comment['comment'],
                                                  onReplyTap: _handleReplyTap,
                                                ),
                                        }
                                      ],
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }
                              } catch (error) {
                                return const Text("Error occurred");
                              }
                            },
                          ),
                          SizedBox(
                            height: 9.h,
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2.h,
                    child: Center(
                      child: Row(
                        children: [
                          FormBuilder(
                            key: _formKey,
                            child: SizedBox(
                              width: 70.w,
                              child: CustomTextField(
                                maxLines: 2,
                                minLines: 1,
                                name: 'comment',
                                hintText: 'Type here',
                                fillColor: AppColors.whiteColor,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.5.h, horizontal: 1.w),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage('${appUser!.imageURL}'),
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.5.h, horizontal: 1.w),
                                  child: InkWell(
                                    onTap: () async {
                                      final ImagePicker picker = ImagePicker();

                                      final XFile? image =
                                          await picker.pickImage(
                                              imageQuality: 10,
                                              source: ImageSource.gallery);

                                      if (image != null) {
                                        setState(() {
                                          commentImages.add(image);
                                        });
                                      }
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.grayColor,
                                      child: Icon(
                                        Icons.image_rounded,
                                        color: AppColors.blackColor
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 0.h),
                            child: BlocConsumer<PostCubit, PostState>(
                              listener: (context, state) {
                                if (state is PostingError) {
                                  debugPrint(state.error);
                                }
                              },
                              builder: (context, state) {
                                if (state is PostingData) {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomButton(
                                      foregroundColor: AppColors.whiteColor,
                                      borderColor: AppColors.grayColor,
                                      height: 5.5.h,
                                      width: 20.w,
                                      borderRadius: 30.sp,
                                      label: 'Send',
                                      isLoading: true,
                                      onPressed: () {},
                                    ),
                                  );
                                } else {
                                  return Align(
                                    alignment: Alignment.centerRight,
                                    child: CustomButton(
                                      foregroundColor: AppColors.whiteColor,
                                      borderColor: AppColors.grayColor,
                                      height: 5.5.h,
                                      width: 20.w,
                                      borderRadius: 30.sp,
                                      label: 'Send',
                                      onPressed: () async {
                                        if (_formKey.currentState!
                                                    .fields['comment']?.value !=
                                                null ||
                                            commentImages.isNotEmpty) {
                                          AuthenticationState authState =
                                              BlocProvider.of<
                                                          AuthenticationCubit>(
                                                      context)
                                                  .state;
                                          if (authState is Authenticated) {
                                            BlocProvider.of<PostCubit>(context)
                                                .createNewComment(
                                                  Comment(
                                                    commentId: '',
                                                    senderUid: FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.uid ??
                                                        '',
                                                    recieverUid:
                                                        widget.post.uid,
                                                    postId: widget.post.id,
                                                    parentId: comment.parentId,
                                                    commentDescription: _formKey
                                                        .currentState!
                                                        .fields['comment']
                                                        ?.value,
                                                    timestamp:
                                                        Timestamp.fromDate(
                                                      DateTime.now(),
                                                    ),
                                                    commentImageURL: [],
                                                    likes: [],
                                                  ),
                                                  commentImages
                                                      .map(
                                                        (image) =>
                                                            File(image.path),
                                                      )
                                                      .toList(),
                                                )
                                                .whenComplete(() => _formKey
                                                    .currentState
                                                    ?.reset());
                                          }

                                          await UserServices.fetch(
                                                  widget.post.uid)
                                              .then((value) {
                                            if (value!.commentNotification) {
                                              NotificationServices.create(
                                                AppNotification(
                                                  id: '',
                                                  type: NotificationTypes
                                                      .like.name,
                                                  sender: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  receiver: widget.post.uid,
                                                  text: 'Commented you a post.',
                                                  objectId: widget.post.id,
                                                  timestamp: Timestamp.fromDate(
                                                    DateTime.now(),
                                                  ),
                                                ),
                                              );
                                            }
                                            if (value.token != null &&
                                                value.pushNotification &&
                                                value.uid !=
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid) {
                                              FirebaseMessagingServices()
                                                  .sendNotification(
                                                value,
                                                'Post Commented',
                                                'have commented your post check it out.',
                                              );
                                            }
                                          });
                                        } else {
                                          toastification.show(
                                            context: context,
                                            type: ToastificationType.error,
                                            style: ToastificationStyle.flat,
                                            autoCloseDuration:
                                                const Duration(seconds: 2),
                                            title:
                                                Text('Image or Description Required'),
                                            description:
                                                Text('Add image or description to create a post.'),
                                            alignment: Alignment.topRight,
                                            // direction: TextDirection.ltr,
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
