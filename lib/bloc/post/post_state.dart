import 'package:GM_Nav/model/DataModel.dart';
import 'package:equatable/equatable.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object> get props => [];
}

class PostUninitialized extends PostState {}

class PostError extends PostState {}

class PostLoaded extends PostState {
  final List<DataModel> posts;
  final List<String> images;
  final userID;
  final bool hasReachedMax;

  const PostLoaded({
    this.posts,
    this.userID,
    this.hasReachedMax,
    this.images,
  });

  @override
  List<Object> get props => [posts, userID, hasReachedMax, images];
}
