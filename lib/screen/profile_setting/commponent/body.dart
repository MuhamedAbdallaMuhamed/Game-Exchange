import 'dart:io';

import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/storge/storage_manager_imp.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/screen_size_confg.dart';
import 'package:GM_Nav/screen/login/components/utilities.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final _picker = ImagePicker();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _userManager = container<UserManager>();
  final _storageManager = container<StorageFirebaseManager>();
  String _imagePath = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _imagePath = "";
  }

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _password.dispose();
  }

  Widget _nameBtn() {
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
            controller: _name,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GameConstants.OPENSANS_FONT,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_balance,
                color: Colors.white,
              ),
              hintText: DesignConstants.ACC_SETTING_HINT[0].tr(),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.ACC_SETTING_HINT[1],
          style: kLabelStyle,
        ).tr(),
        SizedBox(height: ScreenSizeConfig.safeBlockVertical),
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
            controller: _password,
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
                Icons.security,
                color: Colors.white,
              ),
              hintText: DesignConstants.ACC_SETTING_HINT[1].tr(),
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

  Widget _addToStore() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ScreenSizeConfig.safeBlockVertical * 2,
      ),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_name.text.isEmpty &&
              _imagePath.isEmpty &&
              _password.text.isEmpty) {
            submit(GameConstants.MISSING_DATA);
          } else {
            String storedID = (BlocProvider.of<AuthenticationBloc>(context)
                    .state as AuthenticationAuthenticated)
                .id;
            User currentUser = ((await _userManager.get(storedID)) as User);
            currentUser.name =
                (_name.text.isNotEmpty ? _name.text : currentUser.name);
            currentUser.password = (_password.text.isNotEmpty
                ? _password.text
                : currentUser.password);
            currentUser.imageUrl = (_imagePath.isNotEmpty
                ? (await _storageManager.upload(
                    new File(_imagePath),
                    _imagePath,
                  ))
                : currentUser.imageUrl);
            await _userManager.update(currentUser);
            submit(GameConstants.SUCCESS);
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
          DesignConstants.UPDATE_ACC,
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
        duration: new Duration(seconds: 5),
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
          new SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _nameBtn(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _passwordBtn(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _addToStore(),
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
