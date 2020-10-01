import 'dart:async';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:GM_Nav/repository/authentication/authentication.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    yield AuthenticationUninitialized();

    if (event is AppStarted) {
      await Future.delayed(Duration(seconds: 6));
      final String id = await Authentication.getId();
      await container<PostManager>().init();
      if (id != null) {
        yield AuthenticationAuthenticated(id: id);
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationLoading();
      await container<PostManager>().init();
      await Authentication.persistId(event.id);
      yield AuthenticationAuthenticated(id: event.id);
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await container<PostManager>().init();
      await Authentication.logOut();
      yield AuthenticationUnauthenticated();
    }
  }
}
