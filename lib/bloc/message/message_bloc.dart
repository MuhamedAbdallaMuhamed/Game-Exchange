import 'package:GM_Nav/bloc/message/message_state.dart';
import 'package:GM_Nav/config/dependency_injection.dart';
import 'package:GM_Nav/model/DataModel.dart';
import 'package:GM_Nav/model/chatRoom.dart';
import 'package:GM_Nav/repository/chatMessage/room_manager.dart';
import 'package:bloc/bloc.dart';
import 'message_event.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc();
  List<DataModel> _messages = new List<DataModel>();
  @override
  get initialState => MessageUninitialized();

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    final currentState = state;
    final _messageManager = container<RoomManager>();

    if (event is Load && !_hasReachedMax(currentState)) {
      try {
        if (currentState is MessageUninitialized) {
          if (event.chatRoom.id == "") {
            _merge(event.value);
            yield MessageLoaded(
              messages: _messages,
              hasReachedMax: false,
            );
          } else if (event.chatRoom.id == "**") {
            _messages.clear();
          } else {
            List<DataModel> messages = await _messageManager.getMessages(
              (event.chatRoom as ChatRoom).messagesID,
            );
            _merge(messages);
            yield MessageLoaded(
              messages: _messages,
              hasReachedMax: false,
            );
          }
          return;
        }
        if (currentState is MessageLoaded) {
          final messages = _fetchMessages(currentState.messages.length, 5);
          yield messages.isEmpty
              ? MessageLoaded(
                  messages: currentState.messages,
                  hasReachedMax: true,
                )
              : MessageLoaded(
                  messages: currentState.messages + messages,
                  hasReachedMax: false,
                );
        }
      } catch (error) {
        print(error);
        yield MessageError();
      }
    }

    if (event is Refresh) {
      yield MessageUninitialized();
      add(
        Load(
          chatRoom: event.chatRoom,
          value: event.value,
        ),
      );
    }
  }

  bool _hasReachedMax(MessageState state) =>
      state is MessageLoaded && state.hasReachedMax;

  List<DataModel> _fetchMessages(int startIndex, int limit) {
    List<DataModel> messages = List<DataModel>();
    for (int i = startIndex;
        i < startIndex + limit && i < _messages.length;
        i++) {
      messages.add(_messages[i]);
    }
    return messages;
  }

  void _merge(List<DataModel> messages) {
    for (int i = 0; i < messages.length; i++) {
      _messages.add(messages[i]);
    }
  }
}
