import 'dart:io';

import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/storge/storage_manager_imp.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/screen_size_confg.dart';
import 'package:GM_Nav/screen/login/components/utilities.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final uuid = Uuid();
  final _picker = ImagePicker();
  final _emailControler = TextEditingController();
  final _passwordControler = TextEditingController();
  final _nameControler = TextEditingController();
  final _userManager = container<UserManager>();
  final _firebaseStorage = container<StorageFirebaseManager>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _imagePath = "";

  @override
  void dispose() {
    super.dispose();
    _emailControler.dispose();
    _passwordControler.dispose();
    _nameControler.dispose();
    _imagePath = "";
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

  Widget _buildNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.NAME_LABEL_TEXT,
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
            controller: _nameControler,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GameConstants.OPENSANS_FONT,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: DesignConstants.NAME_HINT_TEXT.tr(),
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

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColorLight,
          title: Text(DesignConstants.CAMERA_MSG),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text(DesignConstants.GALLARY),
                  onTap: () {
                    _openGallery(context);
                    Navigator.pop(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text(DesignConstants.CAMERA),
                  onTap: () {
                    _openCamera(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _openGallery(BuildContext context) async {
    var picture = await _picker.getImage(source: ImageSource.gallery);
    this.setState(
      () {
        _imagePath = picture.path;
      },
    );
  }

  void _openCamera(BuildContext context) async {
    var picture = await _picker.getImage(source: ImageSource.camera);
    this.setState(
      () {
        _imagePath = picture.path;
      },
    );
  }

  Widget _buildSignUpBtn() {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: ScreenSizeConfig.safeBlockVertical * 2),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_nameControler.text.isNotEmpty &&
              _passwordControler.text.isNotEmpty &&
              _emailControler.text.contains(GameConstants.GMAIL_KEY) &&
              _imagePath.isNotEmpty) {
            DataModel user =
                await _userManager.getWithGmail(_emailControler.text);
            if (user.id != "") {
              submit(GameConstants.MISSING_USER);
            } else {
              _userManager.insert(
                User(
                  uuid.v1(),
                  email: _emailControler.text,
                  nOfVotes: 0,
                  userRateSum: 0,
                  name: _nameControler.text,
                  password: _passwordControler.text,
                  imageUrl: await _firebaseStorage.upload(
                    new File(_imagePath),
                    _imagePath,
                  ),
                ),
              );
              await submit(GameConstants.SUCCESS);
              Navigator.pop(context);
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
          DesignConstants.SIGN_UP_BUTTON_TEXT,
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

  submit(String message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: (message.contains(GameConstants.SUCCESS)
            ? Colors.green
            : Colors.red),
        content: new Text(message),
        duration: new Duration(seconds: 3),
      ),
    );
    Future.delayed(
      new Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        elevation: 0,
        centerTitle: false,
      ),
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
                height: ScreenSizeConfig.safeBlockVertical * 65,
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
                          top: ScreenSizeConfig.safeBlockVertical * 7),
                      child: Text(
                        DesignConstants.SIGN_UP_TEXT,
                        style: TextStyle(
                          fontSize: ScreenSizeConfig.safeBlockHorizontal * 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: GameConstants.OPENSANS_FONT,
                        ),
                      ).tr(),
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
                      child: _buildNameTF(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenSizeConfig.safeBlockVertical,
                          horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
                      child: _buildPasswordTF(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 3),
            child: _buildSignUpBtn(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: FloatingActionButton(
              onPressed: () async {
                await _showSelectionDialog(context);
              },
              child: Icon(Icons.camera),
            ),
          ),
        ],
      ),
    );
  }
}
