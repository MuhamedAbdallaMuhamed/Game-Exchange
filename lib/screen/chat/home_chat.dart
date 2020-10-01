import 'dart:async';
import 'dart:io';
import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/bloc/chat/chat_bloc.dart';
import 'package:GM_Nav/bloc/chat/chat_event.dart';
import 'package:GM_Nav/bloc/chat/chat_state.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/repository/chatMessage/chat_message_manager.dart';
import 'package:GM_Nav/screen/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:GM_Nav/screen/chat/components/utility.dart' as myColors;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/chat_list.dart';

class ChatListPageView extends StatefulWidget {
  // ignore: close_sinks
  static ChatBloc chatBloc;

  @override
  _ChatListPageViewState createState() => _ChatListPageViewState();
}

class _ChatListPageViewState extends State<ChatListPageView> {
  final _scrollListener = ScrollController();
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _scrollListener.addListener(_onScroll);
    ChatListPageView.chatBloc = BlocProvider.of<ChatBloc>(context);
    _refreshCompleter = Completer<void>();
  }

  @override
  Future<void> dispose() async {
    _scrollListener.dispose();
    await container<ChatMessageManager>().init();
    ChatListPageView.chatBloc.add(
      Refresh(
        userID: "**",
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: myColors.blue,
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () async {
              await container<ChatMessageManager>().init();
              ChatListPageView.chatBloc.add(
                Refresh(
                  userID: "**",
                ),
              );
              Navigator.pop(
                context,
              );
            },
          ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          centerTitle: true,
          title: Text(
            DesignConstants.CHAT,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: Container(
          child: Container(
            decoration: BoxDecoration(
                color: myColors.backGround,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                )),
            child: Stack(
              children: <Widget>[
                BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is ChatLoaded) {
                      _refreshCompleter?.complete();
                      _refreshCompleter = Completer();
                    }
                  },
                  builder: (BuildContext context, ChatState state) {
                    if (state is ChatUninitialized) {
                      return SplashScreen();
                    }
                    if (state is ChatLoaded) {
                      return RefreshIndicator(
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return state.chats.length <= index
                                ? Center(
                                    child: Text(''),
                                  )
                                : ChatListViewItem(
                                    image: FileImage(
                                        new File(state.images[index])),
                                    name: state.names[index],
                                    chats: state.chats[index],
                                  );
                          },
                          itemCount: state.hasReachedMax
                              ? state.chats.length
                              : state.chats.length + 1,
                          controller: _scrollListener,
                        ),
                        onRefresh: () {
                          ChatListPageView.chatBloc.add(
                            Refresh(
                              userID:
                                  ((BlocProvider.of<AuthenticationBloc>(context)
                                          .state as AuthenticationAuthenticated)
                                      .id),
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
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollListener.offset >= _scrollListener.position.maxScrollExtent &&
        !_scrollListener.position.outOfRange) {
      setState(
        () {
          ChatListPageView.chatBloc.add(
            Load(
              userID: ((BlocProvider.of<AuthenticationBloc>(context).state
                      as AuthenticationAuthenticated)
                  .id),
            ),
          );
        },
      );
    }
  }
}
