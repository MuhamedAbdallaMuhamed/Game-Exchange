import 'package:GM_Nav/bloc/post/post_bloc.dart';
import 'package:GM_Nav/bloc/post/post_event.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/body.dart';
import 'components/utilities.dart';

class OwnPost extends StatefulWidget {
  final User currentUser;

  OwnPost({
    Key key,
    @required this.currentUser,
  }) : super(key: key);

  @override
  _OwnPost createState() => new _OwnPost();
}

class _OwnPost extends State<OwnPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: kPrimaryColor,
      body: BlocProvider(
        create: (context) => PostBloc()
          ..add(
            Load(
              userID: widget.currentUser.id,
              searchOptions: SearchOptions.OwnSearch,
            ),
          ),
        child: Body(
          currentUser: widget.currentUser,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: new Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Body.ownPostBloc.add(
            Refresh(
              userID: "**",
              searchOptions: SearchOptions.OwnSearch,
            ),
          );
          Navigator.pop(
            context,
          );
        },
      ),
      elevation: 0,
      centerTitle: false,
      title: new Text(
        DesignConstants.MY_STORE,
        style: TextStyle(
          color: Color(
            0xfffafafa,
          ),
        ),
      ),
    );
  }
}
