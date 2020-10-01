import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends ChatEvent {
  final userID;

  Load({
    @required this.userID,
  });

  @override
  List<Object> get props => [userID];
}

class Refresh extends ChatEvent {
  final userID;

  Refresh({
    @required this.userID,
  });

  @override
  List<Object> get props => [userID];
}
