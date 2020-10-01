import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/bloc/chat/chat_bloc.dart';
import 'package:GM_Nav/bloc/chat/chat_event.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/model/Product.dart';
import 'package:GM_Nav/screen/chat/home_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Product product;
  final Post post;
  final FileImage postImage;

  const DetailsScreen({
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
          icon: SvgPicture.asset(
            DesignConstants.CHAT_ICON,
          ),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => ChatBloc()
                    ..add(
                      Load(
                        userID: (BlocProvider.of<AuthenticationBloc>(context)
                                .state as AuthenticationAuthenticated)
                            .id,
                      ),
                    ),
                  child: ChatListPageView(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
