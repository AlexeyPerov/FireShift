import 'dart:math';

import 'package:fireshift/platform/utilities/navigator.dart';
import 'package:fireshift/platform/widgets/conditional_widget.dart';
import 'package:fireshift/shift/app/app.dart';
import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/repositories/auth/auth_repository.dart';
import 'package:fireshift/shift/screens/dashboard/dashboard_screen.dart';
import 'package:fireshift/shift/screens/error/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _loginController;
  TextEditingController _passwordController;
  bool buttonEnabled = false;

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
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
                      controller: _loginController,
                      onChanged: (v) => {
                        setState(() {
                          buttonEnabled = v.isNotEmpty && v.length >= 3;
                        })
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                        autocorrect: false,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        controller: _passwordController),
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
          {_login(_loginController.text, _passwordController.text)},
    );
  }

  void _login(String login, String password) async {
    var result = await getIt<AuthRepository>().authenticate(login, password);

    if (result.isRight()) {
      _navigateToErrorScreen(context);
    } else {
      _navigateToDashboard(context);
    }
  }

  void _navigateToErrorScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ErrorScreen(),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context) {
    NavigatorUtilities.pushAndRemoveUntil(
        context, (context) => DashboardConnector());
  }
}
