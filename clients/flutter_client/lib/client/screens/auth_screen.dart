import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client/client/app.dart';
import 'package:flutter_client/client/screens/chat_screen.dart';
import 'package:flutter_client/client/support_request_repository.dart';
import 'package:flutter_client/client/utilities.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _userIdController;
  bool buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    _userIdController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
                            TextFormField(
                              autocorrect: false,
                              obscureText: false,
                              textAlign: TextAlign.center,
                              controller: _userIdController,
                              onChanged: (v) => {
                                setState(() {
                                  buttonEnabled = v.isNotEmpty;
                                })
                              },
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: ConditionalWidget(
                                  child: _loginButton(context, textTheme, colorScheme),
                                  condition: buttonEnabled),
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

  IconButton _loginButton(
      BuildContext context, TextTheme textTheme, ColorScheme colorScheme) {
    return IconButton(
      icon: const Icon(Icons.login),
      tooltip: "Login",
      onPressed: () =>
      {_login(_userIdController.text)},
    );
  }

  void _login(String userId) async {
    getIt<SupportRequestRepository>().setUserId(userId);
    _navigateToNotes(context);
  }

  void _navigateToNotes(BuildContext context) {
    NavigatorUtilities.pushAndRemoveUntil(
        context, (context) => ChatConnector());
  }
}
