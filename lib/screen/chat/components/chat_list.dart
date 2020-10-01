import 'package:GM_Nav/bloc/message/message_bloc.dart';
import 'package:GM_Nav/bloc/message/message_event.dart';
import 'package:GM_Nav/model/chatRoom.dart';
import 'package:GM_Nav/repository/server/server_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoped_model/scoped_model.dart';
import '../chat_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatListViewItem extends StatelessWidget {
  final FileImage image;
  final String name;
  final ChatRoom chats;

  const ChatListViewItem({
    Key key,
    this.image,
    this.chats,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 10,
                child: ListTile(
                  title: Text(
                    name,
                    style: TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(
                    chats.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12),
                  ),
                  leading: CircleAvatar(
                    backgroundImage: image,
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DateFormat.yMMMEd().format(chats.messageTime.toDate()),
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox()
                    ],
                  ),
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ScopedModel(
                          model: ServerModel(),
                          child: MaterialApp(
                            debugShowCheckedModeBanner: false,
                            home: BlocProvider(
                              create: (context) => MessageBloc()
                                ..add(
                                  Load(
                                    chatRoom: chats,
                                    value: [],
                                  ),
                                ),
                              child: ChatPageView(
                                chatRoom: chats,
                                name: name,
                                image: image,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Divider(
            endIndent: 12.0,
            indent: 12.0,
            height: 0,
          ),
        ],
      ),
    );
  }
}
