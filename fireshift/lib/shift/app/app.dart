import 'package:firebase_core/firebase_core.dart';
import 'package:fireshift/platform/repositories/hive_settings_repository.dart';
import 'package:fireshift/platform/repositories/settings_repository.dart';
import 'package:fireshift/shift/bloc/loggable_bloc_observer.dart';
import 'package:fireshift/shift/repositories/auth/auth_repository.dart';
import 'package:fireshift/shift/repositories/auth/firebase_auth_repository.dart';
import 'package:fireshift/shift/repositories/support/remote_support_repository.dart';
import 'package:fireshift/shift/repositories/support/support_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt getIt = GetIt.instance;

FirebaseApp firebaseApp;

Logger logger;

class App {
  static Future initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    getIt.registerSingleton<SettingsRepository>(HiveSettingsRepository());

    initializeLogging();

    if (!kReleaseMode) {
      Bloc.observer = LoggableBlocObserver();
    }

    await getIt.get<SettingsRepository>().initialize();

    try {
      firebaseApp = await Firebase.initializeApp();
    } catch (e) {
      logger.e(e);
    }

    getIt.registerSingleton<AuthRepository>(FirebaseAuthRepository(),
        signalsReady: true);

    await getIt.get<AuthRepository>().initialize();

    getIt.registerSingleton<SupportRepository>(RemoteSupportRepository(),
        signalsReady: true);

    await getIt<SupportRepository>().initialize();
  }

  static void initializeLogging() {
    logger = Logger(
      filter: CommonLogFilter(),
      printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: false),
    );
  }
}

class CommonLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return !kReleaseMode;
  }
}
