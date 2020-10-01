import 'package:GM_Nav/bloc/chat/chat_state.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/model/chatRoom.dart';
import 'package:GM_Nav/repository/cache_manager/cache_manager.dart';
import 'package:GM_Nav/repository/chatMessage/chat_message_manager.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:bloc/bloc.dart';
import 'chat_event.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc();
  List<DataModel> _chats = new List<DataModel>();
  List<String> _names = new List<String>();
  List<String> _images = new List<String>();

  @override
  get initialState => ChatUninitialized();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    final currentState = state;
    final _userManager = container<UserManager>();
    final _cacheManager = container<CacheManager>();

    if (event is Load && !_hasReachedMax(currentState)) {
      try {
        if (currentState is ChatUninitialized) {
          if (event.userID == "**") {
            _chats.clear();
            _images.clear();
            _names.clear();
          } else {
            final _chatManager = container<ChatMessageManager>();
            _chats = await _chatManager.getAllChats(
              event.userID,
            );
            for (int i = 0; i < _chats.length; i++) {
              User user = (await _userManager
                  .get((_chats[i] as ChatRoom).secondID) as User);
              _images.add(
                (await _cacheManager.getCache(
                  (user.imageUrl),
                )),
              );
              _names.add(user.name);
            }
            final chats = _fetchChats(0, _chats.length);
            final images = _fetchImages(0, _images.length);
            final names = _fetchNames(0, _names.length);
            yield ChatLoaded(
              chats: chats,
              images: images,
              names: names,
              hasReachedMax: false,
            );
          }
          return;
        }
        if (currentState is ChatLoaded) {
          final chats = _fetchChats(currentState.chats.length, 5);
          final images = _fetchImages(currentState.images.length, 5);
          final names = _fetchNames(currentState.names.length, 5);
          yield chats.isEmpty
              ? ChatLoaded(
                  chats: currentState.chats,
                  images: currentState.images,
                  names: currentState.names,
                  hasReachedMax: true,
                )
              : ChatLoaded(
                  chats: currentState.chats + chats,
                  images: currentState.images + images,
                  names: currentState.names + names,
                  hasReachedMax: false,
                );
        }
      } catch (error) {
        print(error);
        yield ChatError();
      }
    }

    if (event is Refresh) {
      yield ChatUninitialized();
      add(Load(
        userID: event.userID,
      ));
    }
  }

  bool _hasReachedMax(ChatState state) =>
      state is ChatLoaded && state.hasReachedMax;

  List<DataModel> _fetchChats(int startIndex, int limit) {
    List<DataModel> chats = List<DataModel>();
    for (int i = startIndex; i < startIndex + limit && i < _chats.length; i++) {
      chats.add(_chats[i]);
    }
    return chats;
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

  List<String> _fetchNames(int startIndex, int limit) {
    List<String> names = List<String>();
    for (int i = startIndex; i < startIndex + limit && i < _names.length; i++) {
      names.add(_names[i]);
    }
    return names;
  }
}
