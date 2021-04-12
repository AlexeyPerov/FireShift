import 'package:fireshift/platform/repositories/hive_settings_repository.dart';
import 'package:fireshift/platform/repositories/settings_repository.dart';
import 'package:fireshift/shift/repositories/mock_support_repository.dart';
import 'package:fireshift/shift/repositories/support_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class App {
  static Future initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    getIt.registerSingleton<SettingsRepository>(HiveSettingsRepository());

    initializeLogging();

    await getIt.get<SettingsRepository>().initialize();

    getIt.registerSingleton<SupportRepository>(
        MockSupportRepository(),
        signalsReady: true);

    await getIt<SupportRepository>().initialize();
  }

  static void initializeLogging() {}
}
