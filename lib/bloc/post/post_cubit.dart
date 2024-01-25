import 'dart:io';
import 'package:wishes_app/export.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  Future<void> createNewUser(AppUser user, File image) async {
    emit(PostingData());
    try {
      await UserServices.create(user, image);
      emit(DataPosted());
    } catch (e) {
      debugPrint(e.toString());
      emit(
        PostingError(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> updateUser(
      String uid, Map<String, dynamic> data, File? image) async {
    emit(PostingData());
    try {
      await UserServices.update(uid, data, image);
      emit(DataPosted());
    } catch (e) {
      emit(
        PostingError(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> createNewPost(Post createPost, List<File> image) async {
    emit(PostingData());
    try {
      await PostServices.create(createPost, image);
      emit(DataPosted());
    } catch (e) {
      emit(
        PostingError(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> createNewEmail(Email email) async {
    emit(PostingData());
    try {
      await EmailService.sendEmail(email);
      emit(DataPosted());
    } catch (e) {
      emit(
        PostingError(
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> createNewComment(Comment comment, List<File> image) async {
    emit(PostingData());
    try {
      await CommentServices.addComment(comment, image);
      emit(DataPosted());
    } catch (e) {
      emit(
        PostingError(
          error: e.toString(),
        ),
      );
    }
  }
}
