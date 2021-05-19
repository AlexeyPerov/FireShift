import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConditionalWidget extends StatelessWidget {
  final Widget child;
  final Widget fallback;
  final bool condition;

  const ConditionalWidget({
    Key key,
    this.child, this.condition, this.fallback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return condition ? child : fallback != null ? fallback : Container();
  }
}

class NavigatorUtilities {
  static pushAndRemoveUntil(BuildContext context, WidgetBuilder builder) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: builder), (Route<dynamic> route) => false);
  }
}

typedef Widget GetWidget(BuildContext context);

final DateFormat dateFormatter = DateFormat('dd MMM');
final DateFormat timeFormatter = DateFormat('h:mm');