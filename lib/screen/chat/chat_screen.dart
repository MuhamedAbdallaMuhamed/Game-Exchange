import 'dart:async';
import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/bloc/message/message_bloc.dart';
import 'package:GM_Nav/bloc/message/message_event.dart';
import 'package:GM_Nav/bloc/message/message_state.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/chatMessage.dart';
import 'package:GM_Nav/model/chatRoom.dart';
import 'package:GM_Nav/repository/chatMessage/chat_message_manager.dart';
import 'package:GM_Nav/repository/chatMessage/room_manager.dart';
import 'package:GM_Nav/repository/server/server_manager.dart';
import 'package:GM_Nav/screen/splash/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:GM_Nav/screen/chat/components/utility.dart' as myColors;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';
import 'components/receive_message.dart';
import 'components/send_message.dart';

class ChatPageView extends StatefulWidget {
  final ChatRoom chatRoom;
  final String name;
  final FileImage image;
  // ignore: close_sinks
  static MessageBloc messageBloc;

  const ChatPageView({
    Key key,
    this.chatRoom,
    this.image,
    this.name,
  }) : super(key: key);

  @override
  _ChatPageViewState createState() => _ChatPageViewState();
}

class _ChatPageViewState extends State<ChatPageView> {
  final uuid = Uuid();
  TextEditingController _text = new TextEditingController();
  ScrollController _scrollController = ScrollController();
  final _messageManager = container<RoomManager>();
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    ScopedModel.of<ServerModel>(context, rebuildOnChange: false).init(
      widget.chatRoom,
    );
    _scrollController.addListener(_onScroll);
    ChatPageView.messageBloc = BlocProvider.of<MessageBloc>(context);
    _refreshCompleter = Completer<void>();
  }

  @override
  Future<void> dispose() async {
    _scrollController.dispose();
    await _messageManager.init();
    ScopedModel.of<ServerModel>(context, rebuildOnChange: false).end();
    ChatPageView.messageBloc.add(
      Refresh(
        chatRoom: new ChatRoom("**"),
        value: [],
      ),
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 65,
                    child: Container(
                      color: Color(0xFF035AA6),
                      child: Row(
                        children: <Widget>[
                          ScopedModelDescendant<ServerModel>(
                            builder: (contextScope, child, model) {
                              return IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  await _messageManager.init();
                                  model.end();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                            child: Container(
                              child: ClipRRect(
                                child: Container(
                                  child: CircleAvatar(
                                    backgroundImage: widget.image,
                                  ),
                                  color: myColors.orange,
                                ),
                                borderRadius: new BorderRadius.circular(50),
                              ),
                              height: 55,
                              width: 55,
                              padding: const EdgeInsets.all(0.0),
                              decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5.0,
                                      spreadRadius: -1,
                                      offset: Offset(0.0, 5.0))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 0,
                    color: Colors.black54,
                  ),
                  ScopedModelDescendant<ServerModel>(
                    builder: (context, child, model) {
                      List<ChatMessages> message =
                          model.getMessagesForChatID(widget.chatRoom.id);

                      if (message.isNotEmpty) {
                        ChatPageView.messageBloc.add(
                          Refresh(
                            chatRoom: new ChatRoom(""),
                            value: message,
                          ),
                        );
                      }

                      return Flexible(
                        fit: FlexFit.tight,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  DesignConstants.BACKGROUND_CHAT,
                                ),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.linearToSrgbGamma()),
                          ),
                          child: BlocConsumer<MessageBloc, MessageState>(
                            listener: (context, state) {
                              if (state is MessageLoaded) {
                                _refreshCompleter?.complete();
                                _refreshCompleter = Completer();
                              }
                            },
                            builder:
                                (BuildContext context, MessageState state) {
                              if (state is MessageUninitialized) {
                                return SplashScreen();
                              }
                              if (state is MessageLoaded) {
                                return RefreshIndicator(
                                  child: ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return state.messages.length <= index
                                          ? Center(
                                              child: Text(''),
                                            )
                                          : (((BlocProvider.of<AuthenticationBloc>(
                                                                  context)
                                                              .state
                                                          as AuthenticationAuthenticated)
                                                      .id) ==
                                                  (state.messages[index]
                                                          as ChatMessages)
                                                      .senderID)
                                              ? Align(
                                                  alignment: Alignment(1, 0),
                                                  child: SendedMessageWidget(
                                                    content:
                                                        (state.messages[index]
                                                                as ChatMessages)
                                                            .message,
                                                    time:
                                                        DateFormat.Hm().format(
                                                      (state.messages[index]
                                                              as ChatMessages)
                                                          .date
                                                          .toDate(),
                                                    ),
                                                  ),
                                                )
                                              : ((state.messages[index]
                                                              as ChatMessages)
                                                          .senderID) ==
                                                      ""
                                                  ? Center()
                                                  : new Align(
                                                      alignment:
                                                          Alignment(-1, 0),
                                                      child:
                                                          ReceivedMessageWidget(
                                                        content: (state.messages[
                                                                    index]
                                                                as ChatMessages)
                                                            .message,
                                                        time: DateFormat.Hm()
                                                            .format(
                                                          (state.messages[index]
                                                                  as ChatMessages)
                                                              .date
                                                              .toDate(),
                                                        ),
                                                      ),
                                                    );
                                    },
                                    itemCount: state.hasReachedMax
                                        ? state.messages.length
                                        : state.messages.length + 1,
                                    controller: _scrollController,
                                  ),
                                  onRefresh: () {
                                    ChatPageView.messageBloc.add(
                                      Refresh(
                                        chatRoom: widget.chatRoom,
                                        value: [],
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
                        ),
                      );
                    },
                  ),
                  Divider(height: 0, color: Colors.black26),
                  ScopedModelDescendant<ServerModel>(
                    builder: (context, child, model) {
                      return Container(
                        color: Colors.white,
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextField(
                            maxLines: 20,
                            controller: _text,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () async {
                                  if (_text.text.isNotEmpty) {
                                    String storedID =
                                        (BlocProvider.of<AuthenticationBloc>(
                                                        context)
                                                    .state
                                                as AuthenticationAuthenticated)
                                            .id;
                                    Timestamp timeSend = new Timestamp.now();
                                    DataModel receriverChatRoom =
                                        await container<ChatMessageManager>()
                                            .getLastMessage(
                                      widget.chatRoom.secondID,
                                      storedID,
                                    );
                                    ChatMessages message = new ChatMessages(
                                      uuid.v1(),
                                      senderID: storedID,
                                      message: _text.text,
                                      date: timeSend,
                                      pathID: widget.chatRoom.messagesID,
                                      receiverID: widget.chatRoom.secondID,
                                      chatID:
                                          (receriverChatRoom as ChatRoom).id,
                                    );
                                    await _messageManager.insert(message);
                                    model.sendMessage(message);
                                    _text.text = "";
                                    ChatPageView.messageBloc.add(
                                      Refresh(
                                        chatRoom: new ChatRoom(""),
                                        value: [message],
                                      ),
                                    );
                                  }
                                },
                              ),
                              border: InputBorder.none,
                              hintText: DesignConstants.CHAT_HINT,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(
        () {
          ChatPageView.messageBloc.add(
            Load(
              chatRoom: widget.chatRoom,
              value: [],
            ),
          );
        },
      );
    }
  }
}
