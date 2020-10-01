import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/model/Product.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:GM_Nav/screen/own_details/components/body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OwnDetailsScreen extends StatelessWidget {
  final Product product;
  final Post post;
  final postImage;

  const OwnDetailsScreen({
    Key key,
    this.product,
    this.post,
    this.postImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: buildAppBar(context),
      body: Body(
        curProduct: product,
        curPost: post,
        curImage: postImage,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kBackgroundColor,
      elevation: 0,
      leading: IconButton(
        padding: EdgeInsets.only(left: kDefaultPadding),
        icon: SvgPicture.asset(DesignConstants.ARROW_BACK),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        DesignConstants.BACK.toUpperCase(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(DesignConstants.CARD),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            DesignConstants.PROFILE_IMAGE,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: SvgPicture.asset(
            DesignConstants.SETTING_IMAGE,
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
