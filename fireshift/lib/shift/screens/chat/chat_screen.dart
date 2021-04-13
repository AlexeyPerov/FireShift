import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/redux/chat_state_store.dart';
import 'package:fireshift/shift/redux/dashboard_state_store.dart';
import 'package:fireshift/shift/redux/viewmodels/chat_viewmodel.dart';
import 'package:flutter/material.dart';

class ChatConnector extends StatelessWidget {
  final String threadId;

  ChatConnector({Key key, this.threadId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<ChatState>(
      store: chatStore,
      child: StoreConnector<ChatState, ChatViewModel>(
        model: ChatViewModel(threadId: threadId),
        onInitialBuild: (viewModel) => viewModel.onLoad(),
        builder: (BuildContext context, ChatViewModel viewModel) =>
            ChatScreen(viewModel: viewModel),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final ChatViewModel viewModel;

  const ChatScreen({Key key, this.viewModel}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
