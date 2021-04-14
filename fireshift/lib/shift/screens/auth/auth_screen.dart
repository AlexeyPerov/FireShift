import 'dart:math';

import 'package:fireshift/platform/utilities/navigator.dart';
import 'package:fireshift/platform/widgets/conditional_widget.dart';
import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/screens/dashboard/dashboard_screen.dart';
import 'package:fireshift/shift/screens/error/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

// TODO this is a stub for future auth implementation
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _loginController;
  bool buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
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
                              obscureText: true,
                              textAlign: TextAlign.center,
                              controller: _loginController,
                              onChanged: (v) => {
                                setState(() {
                                  buttonEnabled = v.isNotEmpty && v.length >=3;
                                })
                              },
                            ),
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
      onPressed: () => {
        if (_loginController.text == "pass")
          {_navigateToNotes(context)}
        else
          {_navigateToErrorScreen(context)}
      },
    );
  }

  void _navigateToErrorScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ErrorScreen(),
      ),
    );
  }

  void _navigateToNotes(BuildContext context) {
    NavigatorUtilities.pushAndRemoveUntil(
        context, (context) => DashboardConnector());
  }
}
