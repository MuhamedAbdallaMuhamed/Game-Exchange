part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final User user;

  const LoginButtonPressed({
    @required this.user,
  });

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'LoginButtonPressed {  }';
}

class GmailButtonPressed extends LoginEvent {}
