import 'package:fireshift/platform/repositories/hive_settings_repository.dart';
import 'package:fireshift/platform/repositories/settings_repository.dart';
import 'package:fireshift/shift/bloc/loggable_bloc_observer.dart';
import 'package:fireshift/shift/repositories/mock_support_repository.dart';
import 'package:fireshift/shift/repositories/support_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt getIt = GetIt.instance;

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

    getIt.registerSingleton<SupportRepository>(
        MockSupportRepository(),
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
          printTime: false
      ),
    );
  }
}

class CommonLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return !kReleaseMode;
  }
}