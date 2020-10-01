import 'dart:async';
import 'package:GM_Nav/bloc/post/post_bloc.dart';
import 'package:GM_Nav/bloc/post/post_event.dart';
import 'package:GM_Nav/bloc/post/post_state.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/model/Product.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/product/product_manager.dart';
import 'package:GM_Nav/screen/main/components/product_list.dart';
import 'package:GM_Nav/screen/own_details/details_screen.dart';
import 'package:GM_Nav/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utilities.dart';

class Body extends StatefulWidget {
  final currentUser;
  // ignore: close_sinks
  static PostBloc ownPostBloc;

  Body({
    Key key,
    @required this.currentUser,
  }) : super(key: key);

  _Body createState() => new _Body();
}

class _Body extends State<Body> {
  final _scrollListener = ScrollController();
  final _productManager = container<ProductManager>();
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _scrollListener.addListener(_onScroll);
    Body.ownPostBloc = BlocProvider.of<PostBloc>(context);
    _refreshCompleter = Completer<void>();
  }

  @override
  Future<void> dispose() async {
    await container<PostManager>().init();
    Body.ownPostBloc.add(
      Refresh(
        userID: "**",
        searchOptions: SearchOptions.OwnSearch,
      ),
    );
    _scrollListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(
              children: <Widget>[
                // Our background
                Container(
                  margin: EdgeInsets.only(top: 70),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                BlocConsumer<PostBloc, PostState>(
                  listener: (context, state) {
                    if (state is PostLoaded) {
                      _refreshCompleter?.complete();
                      _refreshCompleter = Completer();
                    }
                  },
                  builder: (BuildContext context, PostState state) {
                    if (state is PostUninitialized) {
                      return SplashScreen();
                    }
                    if (state is PostLoaded) {
                      return RefreshIndicator(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return state.posts.length <= index
                                ? Center(
                                    child: Text('End Of Games...'),
                                  )
                                : ProductCard(
                                    itemIndex: index,
                                    post: (state.posts[index] as Post),
                                    image: state.images[index],
                                    press: () async {
                                      Product curProduct = await _productManager
                                          .get((state.posts[index] as Post)
                                              .productID);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OwnDetailsScreen(
                                            product: curProduct,
                                            post: (state.posts[index] as Post),
                                            postImage: state.images[index],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                          },
                          itemCount: state.hasReachedMax
                              ? state.posts.length
                              : state.posts.length + 1,
                          controller: _scrollListener,
                        ),
                        onRefresh: () {
                          Body.ownPostBloc.add(
                            Refresh(
                              userID: widget.currentUser.id,
                              searchOptions: SearchOptions.OwnSearch,
                            ),
                          );
                          return _refreshCompleter.future;
                        },
                      );
                    }
                    return Center(
                      child: Text(''),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onScroll() {
    if (_scrollListener.offset >= _scrollListener.position.maxScrollExtent &&
        !_scrollListener.position.outOfRange) {
      setState(
        () {
          Body.ownPostBloc.add(
            Load(
              userID: widget.currentUser.id,
              searchOptions: SearchOptions.OwnSearch,
            ),
          );
        },
      );
    }
  }
}
