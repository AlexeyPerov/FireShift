abstract class SettingsRepository {
  Future initialize();
  String get(String key, {String defaultValue = ''});
  void put(String key, String value);
}