import 'package:async_redux/async_redux.dart';

import 'entities/support_thread.dart';

var store = Store<ChatState>(
  initialState: ChatState.initialState(),
);

class ChatState {
  final SupportThread thread;

  ChatState({this.thread});

  ChatState copy({SupportThread thread}) =>
      ChatState(thread: thread ?? this.thread);

  static ChatState initialState() => ChatState(
      thread: SupportThread(
          info: SupportThreadInfo(), contents: SupportThreadContents()));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatState &&
          runtimeType == other.runtimeType &&
          thread == other.thread;

  @override
  int get hashCode => thread.hashCode;
}
