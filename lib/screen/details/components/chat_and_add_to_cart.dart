import 'package:GM_Nav/bloc/authentication/authentication_bloc.dart';
import 'package:GM_Nav/bloc/chat/chat_bloc.dart';
import 'package:GM_Nav/bloc/chat/chat_event.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/Post.dart';
import 'package:GM_Nav/model/User.dart';
import 'package:GM_Nav/model/chatMessage.dart';
import 'package:GM_Nav/model/chatRoom.dart';
import 'package:GM_Nav/repository/cache_manager/cache_manager.dart';
import 'package:GM_Nav/repository/chatMessage/chat_message_manager.dart';
import 'package:GM_Nav/repository/chatMessage/room_manager.dart';
import 'package:GM_Nav/repository/user/user_manager.dart';
import 'package:GM_Nav/screen/chat/home_chat.dart';
import 'package:GM_Nav/screen/profile/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:GM_Nav/config/design_constants.dart';
import 'package:GM_Nav/screen/main/components/utilities.dart';
import 'package:uuid/uuid.dart';

class ChatAndAddToCart extends StatelessWidget {
  final post;

  const ChatAndAddToCart({
    @required this.post,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uuid = Uuid();
    final _chatManager = container<ChatMessageManager>();
    final _messageManager = container<RoomManager>();
    final _userManager = container<UserManager>();
    final _cacheManager = container<CacheManager>();

    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFFCBF1E),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: <Widget>[
          FlatButton.icon(
            onPressed: () async {
              DataModel chat = await _chatManager.getLastMessage(
                  ((BlocProvider.of<AuthenticationBloc>(context).state
                          as AuthenticationAuthenticated)
                      .id),
                  (post as Post).userID);

              String storedID = ((BlocProvider.of<AuthenticationBloc>(context)
                      .state as AuthenticationAuthenticated)
                  .id);
              if (chat.id == "" && storedID != (post as Post).userID) {
                String messageID = uuid.v1();
                Timestamp timestamp = new Timestamp.now();
                ChatRoom chatRoom = new ChatRoom(
                  uuid.v1(),
                  firstID: storedID,
                  secondID: (post as Post).userID,
                  messagesID: messageID,
                  lastMessage: "",
                  messageTime: timestamp,
                );
                ChatMessages message = new ChatMessages(
                  uuid.v1(),
                  message: "",
                  date: new Timestamp.now(),
                  pathID: messageID,
                  senderID: "",
                  receiverID: "",
                  chatID: chatRoom.id,
                );
                ChatRoom rchatRoom = new ChatRoom(
                  uuid.v1(),
                  firstID: (post as Post).userID,
                  secondID: storedID,
                  messagesID: messageID,
                  lastMessage: "",
                  messageTime: timestamp,
                );
                await _chatManager.insert(chatRoom);
                await _chatManager.insert(rchatRoom);
                await _messageManager.init();
                await _messageManager.insert(message);
              }
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
            icon: SvgPicture.asset(
              DesignConstants.CHAT_IMAGE,
              height: 18,
            ),
            label: Text(
              DesignConstants.CHAT,
              style: TextStyle(color: Colors.white),
            ),
          ),
          // it will cover all available spaces
          Spacer(),
          FlatButton.icon(
            onPressed: () async {
              DataModel user = (await _userManager.get((post as Post).userID));
              String image =
                  await _cacheManager.getCache((user as User).imageUrl);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    currentUser: user,
                    userImage: image,
                  ),
                ),
              );
            },
            icon: SvgPicture.asset(
              DesignConstants.VIEW_IMAGE,
              height: 18,
            ),
            label: Text(
              DesignConstants.VIEW,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
