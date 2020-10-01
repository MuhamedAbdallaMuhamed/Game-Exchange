import 'package:GM_Nav/model/DataModel.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatUninitialized extends ChatState {}

class ChatError extends ChatState {}

class ChatLoaded extends ChatState {
  final List<DataModel> chats;
  final List<String> names;
  final List<String> images;
  final bool hasReachedMax;

  const ChatLoaded({
    this.chats,
    this.hasReachedMax,
    this.names,
    this.images,
  });

  @override
  List<Object> get props => [chats, hasReachedMax, images];
}
