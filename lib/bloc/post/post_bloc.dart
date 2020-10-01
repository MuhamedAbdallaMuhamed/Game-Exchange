import 'dart:async';
import 'package:GM_Nav/bloc/post/post_event.dart';
import 'package:GM_Nav/bloc/post/post_state.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/shared_data.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/repository/cache_manager/cache_manager.dart';
import 'package:GM_Nav/repository/post/post_manage_imp.dart';
import 'package:GM_Nav/repository/services/search/search_query.dart';
import 'package:bloc/bloc.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc();
  List<DataModel> _posts = new List<DataModel>();
  List<String> _images = new List<String>();

  @override
  get initialState => PostUninitialized();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    final currentState = state;
    final _cacheManager = container<CacheManager>();

    if (event is Load && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          if (event.userID == "**") {
            _posts.clear();
            _images.clear();
            yield PostLoaded(
              posts: _posts,
              userID: event.userID,
              images: _images,
              hasReachedMax: true,
            );
            return;
          }
          final _postManager = container<PostManager>();
          _posts = await _postManager.getPosts(
            SearchQuery(
              id: event.userID,
              option: (SharedData.selectedList.isNotEmpty
                  ? SharedData.selectedList
                  : []),
              searchOption: event.searchOptions,
            ),
          );
          for (int i = 0; i < _posts.length; i++) {
            _images.add(
              (await _cacheManager.getCache(
                (_posts[i] as Post).image,
              )),
            );
          }
          final posts = _fetchPosts(0, _posts.length);
          final images = _fetchImages(0, _images.length);
          yield PostLoaded(
            posts: posts,
            userID: event.userID,
            images: images,
            hasReachedMax: false,
          );
          return;
        }
        if (currentState is PostLoaded) {
          final posts = _fetchPosts(currentState.posts.length, 5);
          final images = _fetchImages(currentState.images.length, 5);
          yield posts.isEmpty
              ? PostLoaded(
                  posts: currentState.posts,
                  userID: currentState.userID,
                  images: currentState.images,
                  hasReachedMax: true,
                )
              : PostLoaded(
                  posts: currentState.posts + posts,
                  userID: currentState.userID,
                  images: currentState.images + images,
                  hasReachedMax: false,
                );
        }
      } catch (error) {
        print(error);
        yield PostError();
      }
    }

    if (event is Refresh) {
      await container<PostManager>().init();
      _posts.clear();
      _images.clear();
      yield PostUninitialized();
      add(Load(
        userID: event.userID,
        searchOptions: event.searchOptions,
      ));
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  List<DataModel> _fetchPosts(int startIndex, int limit) {
    List<DataModel> posts = List<DataModel>();
    for (int i = startIndex; i < startIndex + limit && i < _posts.length; i++) {
      posts.add(_posts[i]);
    }
    return posts;
  }

  List<String> _fetchImages(int startIndex, int limit) {
    List<String> images = List<String>();
    for (int i = startIndex;
        i < startIndex + limit && i < _images.length;
        i++) {
      images.add(_images[i]);
    }
    return images;
  }
}
