import 'dart:convert';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:http/http.dart' as http;

class FacebookAuthentication {
  Future<String> authenticate() async {
    final facebookLogin = FacebookLogin();
    final facebookLoginResult =
        await facebookLogin.logIn([GameConstants.FACEBOOK_EMAIL]);
    final token = facebookLoginResult.accessToken.token;
    final graphResponse =
        await http.get(GameConstants.GRAPH_RESPONE_HTTP + '$token');
    Map facebookUserProfile = json.decode(graphResponse.body);
    return facebookUserProfile[GameConstants.FACEBOOK_EMAIL];
  }
}
