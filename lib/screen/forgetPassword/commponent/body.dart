import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/screen_size_confg.dart';
import 'package:GM_Nav/screen/login/components/utilities.dart';
import 'package:easy_localization/easy_localization.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final _gmail = TextEditingController();
  final _userManager = container<UserManager>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    _gmail.dispose();
  }

  Widget _gmailBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.GMAIL,
          style: kLabelStyle,
        ).tr(),
        SizedBox(
          height: ScreenSizeConfig.safeBlockVertical,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius:
                BorderRadius.circular(ScreenSizeConfig.safeBlockHorizontal * 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: ScreenSizeConfig.safeBlockHorizontal,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: ScreenSizeConfig.safeBlockVertical * 8,
          child: TextField(
            controller: _gmail,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GameConstants.OPENSANS_FONT,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: ScreenSizeConfig.safeBlockVertical * 2),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: DesignConstants.GMAIL.tr(),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _submit() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenSizeConfig.safeBlockVertical * 2,
      ),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_gmail.text.contains(GameConstants.GMAIL_KEY)) {
            DataModel user = await _userManager.getWithGmail(_gmail.text);
            if (user.id == "") {
              await submit(GameConstants.MISSING_USER);
            } else {
              String generatedPSW = GameConstants.STATIC_PASSWORD;
              await submit(GameConstants.GENERATED_PASSWORD);
              (user as User).password = generatedPSW;
              await _userManager.update(user);
              await _userManager.resetPassword((user as User).email);
              Navigator.pop(context);
            }
          } else {
            await submit(GameConstants.MISSING_DATA);
          }
        },
        padding: EdgeInsets.all(ScreenSizeConfig.safeBlockVertical +
            ScreenSizeConfig.safeBlockHorizontal),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ScreenSizeConfig.safeBlockHorizontal * 4),
        ),
        color: Theme.of(context).primaryColorLight,
        child: Text(
          DesignConstants.SUBMIT,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: ScreenSizeConfig.safeBlockHorizontal * .7,
            fontSize: ScreenSizeConfig.safeBlockHorizontal * 5,
            fontWeight: FontWeight.bold,
            fontFamily: GameConstants.OPENSANS_FONT,
          ),
        ).tr(),
      ),
    );
  }

  submit(String message) async {
    int duration = (message.contains(GameConstants.DURATION_KEY) ? 2 : 5);
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: new Text(message),
        duration: new Duration(seconds: duration),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColorDark,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _gmailBtn(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _submit(),
          ),
        ],
      ),
    );
  }
}
