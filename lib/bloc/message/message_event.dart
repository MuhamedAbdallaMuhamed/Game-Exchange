import 'package:GM_Nav/model/DataModel.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends MessageEvent {
  final chatRoom;
  final List<DataModel> value;

  Load({
    @required this.chatRoom,
    @required this.value,
  });

  @override
  List<Object> get props => [
        chatRoom,
        value,
      ];
}

class Refresh extends MessageEvent {
  final chatRoom;
  final value;

  Refresh({
    @required this.chatRoom,
    @required this.value,
  });

  @override
  List<Object> get props => [
        chatRoom,
        value,
      ];
}
