import 'dart:math';

import 'package:async_redux/async_redux.dart';
import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/redux/chat_state_store.dart';
import 'package:fireshift/shift/redux/dashboard_state_store.dart';
import 'package:fireshift/shift/redux/entities/support_thread.dart';
import 'package:fireshift/shift/redux/viewmodels/chat_viewmodel.dart';
import 'package:fireshift/shift/screens/chat/components/message_card.dart';
import 'package:flutter/foundation.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _contents = '';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async => {postPressed()},
          backgroundColor: Color(0xFF757575),
          child: Icon(Icons.send)),
      body: Stack(children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var height = constraints.hasInfiniteHeight
                ? MediaQuery.of(context).size.height
                : constraints.maxHeight;

            var messages = widget.viewModel.thread.contents.messages;

            return Container(
              height: height,
              width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height - 166,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: const EdgeInsets.all(8.0),
                          itemCount: messages != null ? messages.length : 0,
                          itemBuilder: (BuildContext context, int index) {
                            final message = messages[index];
                            return SupportMessageCard(message: message);
                          }),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Container(
                        height: 140,
                        child: Column(
                          children: [
                            TextFormField(
                              maxLines: 3,
                              keyboardType: TextInputType.text,
                              autofocus: true,
                              onSaved: (value) => _contents = value,
                              initialValue: "",
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        )
      ]),
    );
  }

  postPressed() {
    if (_validateAndSave()) {
      widget.viewModel.onAddMessage(
          widget.viewModel.threadId,
          SupportMessage(
              authorId: "0", contents: _contents, time: DateTime.now()));
    }
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }
}
