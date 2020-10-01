import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends PostEvent {
  final userID;
  final searchOptions;

  Load({
    @required this.userID,
    @required this.searchOptions,
  });

  @override
  List<Object> get props => [userID, searchOptions];
}

class Refresh extends PostEvent {
  final userID;
  final searchOptions;

  Refresh({
    @required this.userID,
    @required this.searchOptions,
  });

  @override
  List<Object> get props => [userID, searchOptions];
}
