import 'package:GM_Nav/config/exception_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/exceptions/exception_manager.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/authentication/authentication.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class GmailAuthentication extends Authentication {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  PublishSubject loading = PublishSubject();
  final uuid = Uuid();

  @override
  Future<User> authenticate() async {
    try {
      loading.add(true);
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      User user = User(
        uuid.v1(),
        email: googleSignInAccount.email,
        imageUrl: googleSignInAccount.photoUrl,
        nOfVotes: 0,
        userRateSum: 0,
        name: googleSignInAccount.displayName,
        password: GameConstants.STATIC_PASSWORD,
      );

      loading.add(false);

      return user;
    } catch (error) {
      throw ExceptionManager.getException(
          ExceptionConstants.AUTHENTICATIONFAILED,
          error.toString() + ", occurs in AuthenticationWithGoogle");
    }
  }
}
