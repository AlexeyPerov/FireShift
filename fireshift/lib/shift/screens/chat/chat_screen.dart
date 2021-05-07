import 'dart:math';

import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/bloc/entities/support_thread.dart';
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

  TextEditingController _newMessageController;

  @override
  void initState() {
    super.initState();
    _newMessageController = TextEditingController();
  }

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
            var messagesCount = messages != null ? messages.length : 0; // TODO can be null?

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
                          itemCount: messagesCount,
                          itemBuilder: (BuildContext context, int index) {
                            final message = messages[messagesCount - index - 1];
                            return SupportMessageCard(message: message);
                          }),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Container(
                        height: 140,
                        child: TextFormField(
                          controller: _newMessageController,
                          validator: _validateNonEmpty,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          autofocus: true
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
              authorId: "0", contents: _newMessageController.text, time: DateTime.now()));

      _newMessageController.text = "";
    }
  }

  static String _validateNonEmpty(String value) {
    if (value.isEmpty) {
      return 'Message cannot be empty';
    }
    return null;
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
