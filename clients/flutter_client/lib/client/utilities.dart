import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NavigatorUtilities {
  static pushAndRemoveUntil(BuildContext context, WidgetBuilder builder) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: builder), (Route<dynamic> route) => false);
  }
}

typedef Widget GetWidget(BuildContext context);

final DateFormat dateFormatter = DateFormat('dd MMM');
final DateFormat timeFormatter = DateFormat('h:mm');