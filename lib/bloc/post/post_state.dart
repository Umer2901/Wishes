part of 'post_cubit.dart';

sealed class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}

final class PostingData extends PostState {}

final class DataPosted extends PostState {}

final class PostingError extends PostState {
  final String error;

  const PostingError({required this.error});
}
