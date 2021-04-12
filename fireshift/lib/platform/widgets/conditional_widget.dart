import 'package:flutter/material.dart';

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