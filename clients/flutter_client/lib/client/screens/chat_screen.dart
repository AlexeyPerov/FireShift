import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/client/app.dart';
import 'package:flutter_client/client/screens/auth_screen.dart';
import 'package:flutter_client/client/support_bloc.dart';
import 'package:flutter_client/client/support_request_repository.dart';

import '../utilities.dart';

class ChatConnector extends StatelessWidget {
  final String threadId;

  ChatConnector({Key key, this.threadId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBloc>(create: (context) {
      return ChatBloc(
          supportRequestRepository: getIt<SupportRequestRepository>())
        ..add(ChatFetchEvent());
    }, child:
        BlocBuilder<ChatBloc, ChatState>(builder: (context, ChatState state) {
      return ChatScreen(messages: state.messages);
    }));
  }
}

class ChatScreen extends StatefulWidget {
  final List<SupportMessage> messages;

  const ChatScreen({Key key, this.messages}) : super(key: key);

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
        onPressed: () =>
            NavigatorUtilities.pushAndRemoveUntil(context, (c) => AuthScreen()),
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

            var messages = widget.messages;
            var messagesCount = messages.length;

            return Container(
              height: height,
              width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
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
      BlocProvider.of<ChatBloc>(context).add(AddMessageEvent(SupportMessage(
          authorId: getIt<SupportRequestRepository>().getCurrentUserId(),
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

class SupportMessageCard extends StatelessWidget {
  final SupportMessage message;

  const SupportMessageCard({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final isAdmin = message.authorId == "0";

    return Padding(
      padding: EdgeInsets.only(
          bottom: 18, left: isAdmin ? 0 : 40, right: isAdmin ? 40 : 0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          splashColor: Colors.blue,
          onTap: () => null,
          child: Container(
            padding: EdgeInsets.all(25.0),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(message.contents,
                          style: textTheme.bodyText2
                              .apply(color: colorScheme.onSurface)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: ConditionalWidget(
                          condition: message.authorId != "0",
                          child: Text("User " + message.authorId,
                              style: textTheme.subtitle1
                                  .apply(color: colorScheme.onSurface)),
                        ),
                      ),
                      Text(dateFormatter.format(message.time),
                          style: textTheme.subtitle1
                              .apply(color: colorScheme.onSurface)),
                      SizedBox(width: 10),
                      Text(timeFormatter.format(message.time),
                          style: textTheme.subtitle1
                              .apply(color: colorScheme.onSurface)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
