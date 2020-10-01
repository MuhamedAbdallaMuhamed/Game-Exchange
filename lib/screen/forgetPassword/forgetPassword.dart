import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:flutter/material.dart';
import 'commponent/body.dart';

class ForgetPSW extends StatelessWidget {
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
        DesignConstants.FORGET_PASSWORD,
        style: TextStyle(
          color: Color(
            0xfffafafa,
          ),
        ),
      ),
    );
  }
}
