import 'dart:math';

import 'package:fireshift/platform/utilities/navigator.dart';
import 'package:fireshift/shift/app/app.dart';
import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:fireshift/shift/bloc/thread_chat/thread_chat.dart';
import 'package:fireshift/shift/repositories/support/support_repository.dart';
import 'package:fireshift/shift/screens/chat/components/message_card.dart';
import 'package:fireshift/shift/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatConnector extends StatelessWidget {
  final String threadId;

  ChatConnector({Key key, this.threadId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThreadChatBloc>(create: (context) {
      return ThreadChatBloc(supportRepository: getIt<SupportRepository>())
        ..add(LoadThread(threadId))
        ..add(MarkThreadRead(threadId, true)); // TODO handle Load error
    }, child: BlocBuilder<ThreadChatBloc, ThreadChatState>(
        builder: (context, ThreadChatState state) {
      if (state is ThreadChatLoaded) {
        return ChatScreen(thread: state.thread);
      } else {
        return Scaffold(
          body: Align(
              alignment: Alignment.center, child: LinearProgressIndicator()),
        );
      }
    }));
  }
}

class ChatScreen extends StatefulWidget {
  final SupportThread thread;

  const ChatScreen({Key key, this.thread}) : super(key: key);

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
        onPressed: () => NavigatorUtilities.pushAndRemoveUntil(
            context, (c) => DashboardConnector()),
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async => {postPressed(context)},
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

            var messages = widget.thread.contents.messages;
            var messagesCount = messages.length;

            return Container(
              height: height,
              width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.favorite,
                                    color: widget.thread.info.starred
                                        ? Colors.pink
                                        : Theme.of(context).iconTheme.color,
                                    size: 24.0),
                                onPressed: () => {
                                      BlocProvider.of<ThreadChatBloc>(context).add(
                                          StarThread(widget.thread.info.id,
                                              !widget.thread.info.starred))
                                    }),
                            SizedBox(height: 5),
                            Text("Favorite")
                          ],
                        ),
                        SizedBox(width: 20),
                        Column(
                          children: [
                            IconButton(
                                icon: Icon(Icons.archive,
                                    color: widget.thread.info.archived
                                        ? Colors.pink
                                        : Theme.of(context).iconTheme.color,
                                    size: 24.0),
                                onPressed: () => {
                                      BlocProvider.of<ThreadChatBloc>(context).add(
                                          ArchiveThread(widget.thread.info.id,
                                              !widget.thread.info.archived))
                                    }),
                            SizedBox(height: 5),
                            Text("Archive")
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height - 231,
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
                            autofocus: true),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        )
      ]),
    );
  }

  postPressed(BuildContext context) {
    if (_validateAndSave()) {
      BlocProvider.of<ThreadChatBloc>(context).add(AddThreadMessage(
          widget.thread.info.id,
          SupportMessage(
              authorId: "0",
              contents: _newMessageController.text,
              time: DateTime.now())));

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
