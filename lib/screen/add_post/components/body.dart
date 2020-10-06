import 'dart:io';
import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/model/Product.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/product/product_manager.dart';
import 'package:GM_Nav/repository/storge/storage_manager_imp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/config/screen_size_confg.dart';
import 'package:GM_Nav/screen/login/components/utilities.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:uuid/uuid.dart';

class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}

class _Body extends State<Body> {
  final uuid = Uuid();
  final _picker = ImagePicker();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _price = TextEditingController();
  // ignore: unused_field
  String _imagePath = "";
  // ignore: unused_field
  List _category = List<String>();
  final _postManager = container<PostManager>();
  final _productManager = container<ProductManager>();
  final _firebaseStorage = container<StorageFirebaseManager>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _description.dispose();
    _price.dispose();
    _imagePath = "";
  }

  Widget _priceBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.PRICE,
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
            controller: _price,
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
                Icons.attach_money,
                color: Colors.white,
              ),
              hintText: DesignConstants.PRICE.tr(),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
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
                Icons.gamepad,
                color: Colors.white,
              ),
              hintText: DesignConstants.PRICE_HINT.tr(),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _descriptionBtn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.DESCRIPTION,
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
            controller: _description,
            obscureText: false,
            style: TextStyle(
              color: Colors.white,
              fontFamily: GameConstants.OPENSANS_FONT,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.only(top: ScreenSizeConfig.safeBlockVertical * 2),
              prefixIcon: Icon(
                Icons.description,
                color: Colors.white,
              ),
              hintText: DesignConstants.DESCRIPTION.tr(),
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _selectCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          DesignConstants.CATEGORIES_TXT,
          style: kLabelStyle,
        ).tr(),
        SizedBox(height: ScreenSizeConfig.safeBlockVertical),
        Container(
          padding: EdgeInsets.all(0),
          child: MultiSelectFormField(
            autovalidate: false,
            titleText: ''.tr(),
            fillColor: Theme.of(context).primaryColorLight,
            validator: (value) {
              if (value == null || value.length == 0) {
                return 'error';
              }
              return value;
            },
            dataSource: DesignConstants.LIST_CATEGORIES,
            textField: 'display',
            valueField: 'value',
            okButtonLabel: 'OK',
            cancelButtonLabel: 'CANCEL',
            hintText: ''.tr(),
            onSaved: (value) {
              if (value == null) return;
              setState(
                () {
                  _category = value;
                },
              );
            },
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
          if (_imagePath.isNotEmpty &&
              _price.text.isNotEmpty &&
              _name.text.isNotEmpty &&
              _category.isNotEmpty &&
              _description.text.isNotEmpty) {
            String userID = (BlocProvider.of<AuthenticationBloc>(context).state
                    as AuthenticationAuthenticated)
                .id;
            String productID = uuid.v1();
            DataModel product = new Product(
              productID,
              description: _description.text,
            );
            DataModel post = new Post(
              uuid.v1(),
              isSold: false,
              userID: userID,
              name: _name.text,
              catergory: List.from(_category),
              date: new Timestamp.now(),
              price: double.parse(_price.text),
              productID: productID,
              image: await _firebaseStorage.upload(
                new File(_imagePath),
                _imagePath,
              ),
            );
            await _postManager.insert(post);
            await _productManager.insert(product);
            await submit(GameConstants.SUCCESS);
            _name.text = _price.text = _imagePath = _description.text = "";
            Navigator.pop(context);
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
          GameConstants.ADD_TO_STORE,
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
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: (message.contains(GameConstants.SUCCESS)
            ? Colors.green
            : Colors.red),
        content: new Text(message),
        duration: new Duration(seconds: 5),
      ),
    );
    await Future.delayed(Duration(seconds: 2));
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
            child: _nameBtn(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _descriptionBtn(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _priceBtn(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ScreenSizeConfig.safeBlockVertical,
                horizontal: ScreenSizeConfig.safeBlockHorizontal * 4),
            child: _selectCategory(),
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
