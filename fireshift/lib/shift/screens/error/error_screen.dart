import 'dart:math';

import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: new LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    var height = MediaQuery.of(context).size.height;
                    return Container(
                      width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
                      height: constraints.hasInfiniteHeight
                          ? height
                          : constraints.maxHeight,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("#error",
                            style: textTheme.headline1
                                .apply(color: colorScheme.onSurface)),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
