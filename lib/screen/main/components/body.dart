import 'dart:async';
import 'dart:io';
import 'package:GM_Nav/bloc/post/post_bloc.dart';
import 'package:GM_Nav/bloc/post/post_event.dart';
import 'package:GM_Nav/bloc/post/post_state.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/search_constants.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/model/Product.dart';
import 'package:GM_Nav/repository/cache_manager/cache_manager.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/product/product_manager.dart';
import 'package:GM_Nav/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:GM_Nav/screen/details/details_screen.dart';
import 'package:GM_Nav/screen/search/search_box.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category.dart';
import 'product_list.dart';
import 'utilities.dart';

class Body extends StatefulWidget {
  // ignore: close_sinks
  static PostBloc postBloc;

  Body({
    Key key,
  }) : super(key: key);

  _Body createState() => new _Body();
}

class _Body extends State<Body> {
  final _cacheManager = container<CacheManager>();
  final _scrollListener = ScrollController();
  final _productManager = container<ProductManager>();
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _scrollListener.addListener(_onScroll);
    Body.postBloc = Body.postBloc = BlocProvider.of<PostBloc>(context);
    _refreshCompleter = Completer<void>();
  }

  @override
  Future<void> dispose() async {
    _scrollListener.dispose();
    await container<PostManager>().init();
    Body.postBloc.add(
      Refresh(
        userID: "**",
        searchOptions: SearchOptions.General_Search,
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          SearchBox(),
          CategoryList(),
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
                                      Product curProduct =
                                          await _productManager.get(
                                        (state.posts[index] as Post).productID,
                                      );
                                      String image =
                                          await _cacheManager.getCache(
                                        (state.posts[index] as Post).image,
                                      );
                                      FileImage sendImage = new FileImage(
                                        new File(image),
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailsScreen(
                                            product: curProduct,
                                            post: (state.posts[index] as Post),
                                            postImage: sendImage,
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
                          Body.postBloc.add(
                            Refresh(
                              userID: "",
                              searchOptions: SearchOptions.General_Search,
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
          Body.postBloc.add(
            Load(
              userID: "",
              searchOptions: SearchOptions.General_Search,
            ),
          );
        },
      );
    }
  }
}
