import 'dart:io';
import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/bloc/post/post_bloc.dart';
import 'package:GM_Nav/bloc/post/post_event.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/repository/cache_manager/cache_manager.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:GM_Nav/screen/add_post/add_post.dart';
import 'package:GM_Nav/screen/profile/profile.dart';
import 'package:GM_Nav/screen/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:GM_Nav/config/design_constants.dart';
import '../../repository/authentication/authentication.dart';
import 'components/body.dart';
import 'components/utilities.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: kPrimaryColor,
      body: BlocProvider(
        create: (context) => PostBloc()
          ..add(
            Load(
              userID: (BlocProvider.of<AuthenticationBloc>(context).state
                      as AuthenticationAuthenticated)
                  .id,
              searchOptions: SearchOptions.General_Search,
            ),
          ),
        child: Body(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    final _userManager = container<UserManager>();
    final _cacheManager = container<CacheManager>();

    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text(
        DesignConstants.DASH,
        style: TextStyle(
          color: Color(
            0xfffafafa,
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            DesignConstants.ADD_POST_ICON,
          ),
          onPressed: () async {
            await container<PostManager>().init();
            Body.postBloc.add(
              Refresh(
                userID: "**",
                searchOptions: SearchOptions.General_Search,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPost(),
              ),
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            DesignConstants.PROFILE_IMAGE,
          ),
          onPressed: () async {
            await container<PostManager>().init();
            Body.postBloc.add(
              Refresh(
                userID: "**",
                searchOptions: SearchOptions.General_Search,
              ),
            );
            User currentUser = await _userManager.get(
                (BlocProvider.of<AuthenticationBloc>(context).state
                        as AuthenticationAuthenticated)
                    .id);
            String userImage =
                await _cacheManager.getCache(currentUser.imageUrl);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(
                  currentUser: currentUser,
                  userImage: userImage,
                ),
              ),
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            DesignConstants.SETTING_IMAGE,
          ),
          onPressed: () async {
            await container<PostManager>().init();
            Body.postBloc.add(
              Refresh(
                userID: "**",
                searchOptions: SearchOptions.General_Search,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingScreen(),
              ),
            );
          },
        ),
        IconButton(
          icon: SvgPicture.asset(
            DesignConstants.LOGOUT,
          ),
          onPressed: () async {
            await Authentication.logOut();
            exit(0);
          },
        ),
      ],
    );
  }
}
