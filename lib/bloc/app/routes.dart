import 'package:flutter/widgets.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/screen/login/login_screen.dart';
import 'package:GM_Nav/screen/signUp/signUp.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  GameConstants.SIGNUP_PAGE_ROUTE: (BuildContext context) => SignUpScreen(),
  GameConstants.LOGIN_PAGE_ROUTE: (BuildContext context) => LoginScreen(),
};
