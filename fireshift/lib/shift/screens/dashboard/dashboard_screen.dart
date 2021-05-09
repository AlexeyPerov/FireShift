import 'dart:math';

import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'components/thread_paged_list.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: new LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              var height = constraints.hasInfiniteHeight
                  ? MediaQuery.of(context).size.height
                  : constraints.maxHeight;

              return Container(
                width: kIsWeb ? min(kMinWebContainerWidth, width) : null,
                height: height,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(height: 10),
                    Container(height: height - 50, child: ThreadPagedList()),
                  ],
                ),
              );
            }),
          ),
        ],
      )
    );
  }
}
