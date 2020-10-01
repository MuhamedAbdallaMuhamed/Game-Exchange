import 'dart:async';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:equatable/equatable.dart';
import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/repository/authentication/facebook_authenticate.dart';
import 'package:GM_Nav/repository/authentication/gmail_authenticate.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  GmailAuthentication gmailAuthentication;
  FacebookAuthentication facebookAuthentication;
  final AuthenticationBloc authenticationBloc;
  final _userManager = container<UserManager>();

  LoginBloc({
    @required this.authenticationBloc,
  }) {
    gmailAuthentication = GmailAuthentication();
    facebookAuthentication = FacebookAuthentication();
  }
  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is GmailButtonPressed) {
      yield LoginLoading();

      try {
        User user = await gmailAuthentication.authenticate();
        await container<PostManager>().init();

        User isExist = await _userManager.getWithGmail(user.email);

        if (isExist.id == "")
          await _userManager.insert(user);
        else
          user = isExist;

        authenticationBloc.add(LoggedIn(id: user.id));

        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    } else if (event is LoginButtonPressed) {
      try {
        await container<PostManager>().init();
        authenticationBloc.add(LoggedIn(id: event.user.id));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
