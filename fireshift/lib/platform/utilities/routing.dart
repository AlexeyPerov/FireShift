class RoutingData {
  final String route;
  final Map<String, String> _queryParameters;
  RoutingData({
    this.route,
    Map<String, String> queryParameters,
  }) : _queryParameters = queryParameters;
  operator [](String key) => _queryParameters[key];
}

extension RoutingExtension on String {
  RoutingData get getRoutingData {
    var uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}