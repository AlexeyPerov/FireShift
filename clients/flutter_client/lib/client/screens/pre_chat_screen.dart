import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client/client/app.dart';
import 'package:flutter_client/client/screens/chat_screen.dart';
import 'package:flutter_client/client/support_request_repository.dart';
import 'package:flutter_client/client/utilities.dart';

class PreChatScreen extends StatefulWidget {
  @override
  _PreChatScreenState createState() => _PreChatScreenState();
}

class _PreChatScreenState extends State<PreChatScreen> {
  String _notificationsCountMessage = "Unread: N/A";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: new LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var height = MediaQuery.of(context).size.height;
            return Container(
              width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
              height: constraints.hasInfiniteHeight
                  ? height
                  : constraints.maxHeight,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: "Update",
                      onPressed: () => {_update(context)},
                    ),
                    SizedBox(height: 10),
                    Text(_notificationsCountMessage),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                        icon: const Icon(Icons.login),
                        tooltip: "Login",
                        onPressed: () => {_navigateToChat(context)},
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    ));
  }

  void _navigateToChat(BuildContext context) {
    NavigatorUtilities.pushAndRemoveUntil(
        context, (context) => ChatConnector());
  }

  void _update(BuildContext context) async {
    var result = await getIt<SupportRequestRepository>().getUnreadCount();
    setState(() {
      _notificationsCountMessage = "Unread: " + result.toString();
    });
  }
}
