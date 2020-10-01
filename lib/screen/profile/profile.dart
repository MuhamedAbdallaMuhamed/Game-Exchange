import 'dart:io';
import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/config/game_constants.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/model/userVote.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/services/userVote/userVote_manager.dart';
import 'package:GM_Nav/screen/own_post/own_posts.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends StatefulWidget {
  final User currentUser;
  final String userImage;

  ProfilePage({
    Key key,
    @required this.currentUser,
    @required this.userImage,
  }) : super(key: key);

  @override
  _ProfilePage createState() => new _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final uuid = Uuid();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _voteManager = container<UserVoteManager>();
  var _value = 0.0;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    ScrollController _scrollController = ScrollController();

    return new Stack(
      children: <Widget>[
        new Scaffold(
          key: _scaffoldKey,
          appBar: new AppBar(
            leading: IconButton(
              icon: new Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () async {
                await container<PostManager>().init();
                Navigator.pop(
                  context,
                );
              },
            ),
            elevation: 0,
            centerTitle: false,
            title: new Text(
              DesignConstants.PROFILE,
              style: TextStyle(
                color: Color(
                  0xfffafafa,
                ),
              ),
            ),
            actions: <Widget>[
              (((BlocProvider.of<AuthenticationBloc>(context).state
                              as AuthenticationAuthenticated)
                          .id) ==
                      widget.currentUser.id)
                  ? IconButton(
                      icon: SvgPicture.asset(
                        DesignConstants.VIEW_POSTS,
                      ),
                      onPressed: () async {
                        await container<PostManager>().init();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OwnPost(
                              currentUser: widget.currentUser,
                            ),
                          ),
                        );
                      },
                    )
                  : new Text(''),
            ],
          ),
          drawer: new Drawer(
            child: new Container(),
          ),
          backgroundColor: Colors.white60,
          body: new Center(
            child: new Column(
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(DesignConstants.BACKGROUND_PROFILE),
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.linearToSrgbGamma(),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new SizedBox(
                            height: _height / 12,
                          ),
                          new CircleAvatar(
                            radius: _width < _height ? _width / 4 : _height / 4,
                            backgroundImage: FileImage(
                              new File(widget.userImage),
                            ),
                          ),
                          new Divider(
                            height: _height / 30,
                            color: Colors.blue,
                          ),
                          new SizedBox(
                            height: _height / 25.0,
                          ),
                          new Text(
                            widget.currentUser.name,
                            style: new TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: _width / 15,
                              color: Colors.black,
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(
                                top: _height / 30,
                                left: _width / 8,
                                right: _width / 8),
                            child: new Text(
                              DesignConstants.GAMER_HONOR,
                              style: new TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: _width / 25,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          new SizedBox(
                            height: _height / 150.0,
                          ),
                          SmoothStarRating(
                            allowHalfRating: true,
                            onRated: (v) {},
                            starCount: 5,
                            rating: widget.currentUser.nOfVotes == 0
                                ? 0
                                : ((widget.currentUser.userRateSum) /
                                    (GameConstants.HONOR_FACTOR *
                                        widget.currentUser.nOfVotes)),
                            size: 30.0,
                            isReadOnly: true,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            color: Colors.lightGreen,
                            borderColor: Colors.white,
                            spacing: 0.0,
                          ),
                          new SizedBox(
                            height: _height / 25.0,
                          ),
                          new Text(
                            DesignConstants.RATE_GAMER_HONOR,
                            style: new TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: _width / 25,
                              color: Colors.black,
                            ),
                          ),
                          new SizedBox(
                            height: _height / 80,
                          ),
                          SmoothStarRating(
                            allowHalfRating: true,
                            onRated: (v) {
                              _value = v;
                            },
                            starCount: 5,
                            size: 25.0,
                            isReadOnly: false,
                            defaultIconData: Icons.star_border,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            color: Colors.green,
                            borderColor: Colors.white,
                            spacing: 0.0,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.rate_review,
                              color: Color(0xF11FFFAF),
                            ),
                            onPressed: () async {
                              String storedID =
                                  (BlocProvider.of<AuthenticationBloc>(context)
                                          .state as AuthenticationAuthenticated)
                                      .id;
                              String currentID = widget.currentUser.id;
                              if (currentID == storedID) {
                                await submit(
                                    GameConstants.RATE_YOURSELF_DENIED);
                              } else {
                                if ((await _voteManager.isVoteExist(
                                    storedID, currentID))) {
                                  await submit(GameConstants.RATED_BEFORE);
                                } else {
                                  await _voteManager.rateUser(
                                    UserVote(
                                      uuid.v1(),
                                      firstID: storedID,
                                      secondID: currentID,
                                      rate: _value,
                                    ),
                                  );
                                  await submit(GameConstants.SUCCESS);
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  submit(String message) async {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        backgroundColor: (message.contains(GameConstants.SUCCESS)
            ? Colors.green
            : Colors.red),
        content: new Text(message),
        duration: new Duration(seconds: 3),
      ),
    );
  }
}
