import 'package:GM_Nav/screen/add_post/components/body.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:flutter/material.dart';
import 'package:GM_Nav/config/design_constants.dart';

class AddPost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: kPrimaryColor,
      body: Body(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(
            context,
          );
        },
      ),
      title: Text(
        DesignConstants.ADD_POST,
        style: TextStyle(
          color: Color(
            0xfffafafa,
          ),
        ),
      ),
    );
  }
}
