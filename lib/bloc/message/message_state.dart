import 'package:GM_Nav/model/DataModel.dart';
import 'package:equatable/equatable.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageUninitialized extends MessageState {}

class MessageError extends MessageState {}

class MessageLoaded extends MessageState {
  final List<DataModel> messages;
  final bool hasReachedMax;

  const MessageLoaded({
    this.messages,
    this.hasReachedMax,
  });

  @override
  List<Object> get props => [messages, hasReachedMax];
}
