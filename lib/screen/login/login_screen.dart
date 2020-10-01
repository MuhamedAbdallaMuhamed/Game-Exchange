import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:GM_Nav/screen/forgetPassword/forgetPassword.dart';
import 'package:GM_Nav/screen/signUp/signUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:GM_Nav/bloc/login/login_bloc.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/screen/login/components/utilities.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/config/screen_size_confg.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailControler = TextEditingController();
  final _passwordControler = TextEditingController();
  final UserManager _userManager = container<UserManager>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  submit(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: new Text(message),
        duration: new Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _emailControler.dispose();
    _passwordControler.dispose();
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.EMAIL,
          style: kLabelStyle,
        ).tr(),
        SizedBox(
          height: ScreenSizeConfig.safeBlockVertical,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
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
            controller: _emailControler,
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
              hintText: DesignConstants.EMAIL_HINT.tr(),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.PASSWORD_TEXT,
          style: kLabelStyle,
        ).tr(),
        SizedBox(height: ScreenSizeConfig.safeBlockVertical),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
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
            controller: _passwordControler,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GameConstants.OPENSANS_FONT,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: ScreenSizeConfig.safeBlockVertical * 2),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: DesignConstants.PASSWORD_HINT_TEXT.tr(),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForgetPSW(),
            ),
          );
        },
        child: Text(
          DesignConstants.FORGET_PASSWORD_TEXT,
          style: kLabelStyle,
        ).tr(),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 2),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_emailControler.text.contains(GameConstants.GMAIL_KEY) &&
              _passwordControler.text.isNotEmpty) {
            DataModel user =
                await _userManager.getWithGmail(_emailControler.text);
            if (user.id == "") {
              submit(GameConstants.MISSING_USER);
            } else {
              BlocProvider.of<LoginBloc>(context).add(
                LoginButtonPressed(
                  user: user,
                ),
              );
            }
          } else {
            submit(GameConstants.MISSING_DATA);
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
          DesignConstants.LOGIN_TEXT.toUpperCase(),
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

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          DesignConstants.OR_TEXT,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ).tr(),
        SizedBox(height: ScreenSizeConfig.safeBlockVertical),
        Text(
          DesignConstants.SIGN_WITH_TEXT,
          style: kLabelStyle,
        ).tr(),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ScreenSizeConfig.safeBlockVertical * 9,
        width: ScreenSizeConfig.safeBlockVertical * 9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 3),
              blurRadius: ScreenSizeConfig.safeBlockVertical,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: ScreenSizeConfig.safeBlockVertical),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () async {
              BlocProvider.of<LoginBloc>(context).add(GmailButtonPressed());
            },
            AssetImage(
              GameConstants.GOOGLE_LOGO,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
      child: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUpScreen(),
              ),
            );
          },
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: DesignConstants.DONOT_HAVE_ACCOUNT_TEXT.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenSizeConfig.safeBlockHorizontal * 5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(text: '  '),
                TextSpan(
                  text: DesignConstants.SIGN_UP_BUTTON_TEXT.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenSizeConfig.safeBlockHorizontal * 6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenSizeConfig().init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ScreenSizeConfig.safeBlockHorizontal * 3,
            ),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(
                    ScreenSizeConfig.safeBlockVertical * 3 +
                        ScreenSizeConfig.safeBlockHorizontal * 3),
                bottomLeft: Radius.circular(
                    ScreenSizeConfig.safeBlockVertical * 3 +
                        ScreenSizeConfig.safeBlockHorizontal * 3),
              ),
              child: Container(
                width: double.infinity,
                height: ScreenSizeConfig.safeBlockVertical * 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorLight
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(
                        ScreenSizeConfig.safeBlockVertical * 3 +
                            ScreenSizeConfig.safeBlockHorizontal * 3),
                    bottomLeft: Radius.circular(
                        ScreenSizeConfig.safeBlockVertical * 3 +
                            ScreenSizeConfig.safeBlockHorizontal * 3),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: ScreenSizeConfig.safeBlockVertical * 4),
                      child: Text(
                        DesignConstants.LOGIN_TEXT.tr(),
                        style: TextStyle(
                          fontSize: ScreenSizeConfig.safeBlockHorizontal * 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: GameConstants.OPENSANS_FONT,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenSizeConfig.safeBlockVertical,
                          horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
                      child: _buildEmailTF(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenSizeConfig.safeBlockVertical,
                          horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
                      child: _buildPasswordTF(),
                    ),
                    _buildForgotPasswordBtn(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 3),
            child: _buildLoginBtn(),
          ),
          _buildSignInWithText(),
          _buildSocialBtnRow(),
          SizedBox(height: ScreenSizeConfig.safeBlockHorizontal * 5),
          _buildSignupBtn(),
        ],
      ),
    );
  }
}
