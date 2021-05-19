import 'package:flutter/material.dart';
import 'package:flutter_client/client/screens/auth_screen.dart';
import 'package:flutter_client/client/app.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  final Future _appInitialization;

  AppWidget() : _appInitialization = App.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'shift_client',
      title: 'ShiftClient',
      onGenerateRoute: _generateRoute,
    );
  }

  FutureBuilder _redirectOnAppInit(RouteToWidget routeTo) {
    return FutureBuilder(
      future: _appInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          logger.e(snapshot.error);
          return Container();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return routeTo();
        }

        return LinearProgressIndicator();
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => _redirectOnAppInit(() => AuthScreen()),
    );
  }
}

typedef Widget RouteToWidget();
