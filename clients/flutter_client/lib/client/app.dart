import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_client/client/support_bloc.dart';
import 'package:flutter_client/client/support_request_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

const double kMinWebContainerWidth = 850;

GetIt getIt = GetIt.instance;

Logger logger;

class App {
  static Future initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    initializeLogging();

    if (!kReleaseMode) {
      Bloc.observer = LoggableBlocObserver();
    }

    getIt.registerSingleton<SupportRequestRepository>(
        RemoteSupportRequestRepository(),
        signalsReady: true);
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