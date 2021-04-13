import 'package:fireshift/platform/utilities/routing.dart';
import 'package:fireshift/shift/app/app.dart';
import 'package:fireshift/shift/app/options/app_options.dart';
import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/app/theme/themes.dart';
import 'package:fireshift/shift/screens/auth/auth_screen.dart';
import 'package:fireshift/shift/screens/dashboard/dashboard_screen.dart';
import 'package:fireshift/shift/screens/error/error_screen.dart';
import 'package:fireshift/shift/screens/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  final Future _appInitialization;

  AppWidget() : _appInitialization = App.initializeApp();

  @override
  Widget build(BuildContext context) => ModelBinding(
    initialModel: AppOptions(
      themeMode: ThemeMode.system,
      textScaleFactor: systemTextScaleFactorOption,
      timeDilation: timeDilation,
      platform: defaultTargetPlatform,
      isTestMode: false,
    ),
    child: Builder(
      builder: (context) {
        return _createApp(context);
      },
    ),
  );

  MaterialApp _createApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'notes',
      title: 'Notes',
      themeMode: AppOptions.of(context).themeMode,
      theme: AppThemeData.lightThemeData.copyWith(
        platform: AppOptions.of(context).platform,
      ),
      darkTheme: AppThemeData.darkThemeData.copyWith(
        platform: AppOptions.of(context).platform,
      ),
      onGenerateRoute: _generateRoute,
    );
  }

  FutureBuilder _redirectOnAppInit(RouteToWidget routeTo) {
    return FutureBuilder(
      future: _appInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return routeTo();
        }

        return SplashScreen();
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    var routingData = settings.name.getRoutingData;
    switch (routingData.route) {
      case '/error':
        return MaterialPageRoute(
          builder: (context) => _redirectOnAppInit(() => ErrorScreen()),
        );
      case '/auth':
        return MaterialPageRoute(
          builder: (context) => _redirectOnAppInit(() => AuthScreen()),
        );
    }

    return MaterialPageRoute(
      builder: (context) => _redirectOnAppInit(
              () => kReleaseMode ? AuthScreen() : DashboardConnector()),
    );
  }
}

typedef Widget RouteToWidget();
