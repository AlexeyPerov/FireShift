import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/redux/actions/all_actions.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:flutter/widgets.dart';

import '../chat_state_store.dart';

class ChatViewModel extends BaseModel<ChatState> {
  final String threadId;

  ChatViewModel({@required this.threadId});

  SupportThread thread;

  VoidCallback onLoad;
  Function(String, SupportMessage) onAddMessage;
  Function(String, bool) onStar;
  Function(String, bool) onMarkRead;
  Function(String, bool) onArchive;

  ChatViewModel.build(
      {@required this.threadId,
      @required this.thread,
      @required this.onLoad,
      @required this.onAddMessage,
      @required this.onStar,
      @required this.onMarkRead,
      @required this.onArchive})
      : super(equals: [thread]);

  @override
  ChatViewModel fromStore() => ChatViewModel.build(
      threadId: threadId,
      thread: state.thread,
      onLoad: () => dispatch(LoadContentsAction(threadId: threadId)),
      onAddMessage: (ticketId, message) async => dispatchFuture(
          AddMessageAction(threadId: ticketId, message: message)),
      onStar: (id, archive) =>
          dispatch(StarAction(threadId: id, star: archive)),
      onMarkRead: (id, archive) =>
          dispatch(MarkReadAction(threadId: id, read: archive)),
      onArchive: (id, archive) =>
          dispatch(ArchiveAction(threadId: id, archive: archive)));
}
