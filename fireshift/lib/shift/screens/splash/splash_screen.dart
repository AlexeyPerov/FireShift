import 'dart:math';

import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                        child: LinearProgressIndicator(),
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}
