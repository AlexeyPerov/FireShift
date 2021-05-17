import 'dart:math';

import 'package:fireshift/shift/app/theme/theme_constants.dart';
import 'package:fireshift/shift/bloc/dashboard/dashboard.dart';
import 'package:fireshift/shift/entities/support_thread.dart';
import 'package:fireshift/shift/screens/dashboard/components/filter_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/thread_paged_list.dart';

class DashboardConnector extends StatelessWidget {
  DashboardConnector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DashboardBloc>(create: (context) {
      return DashboardBloc();
    }, child: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, DashboardState state) {
      return DashboardScreen(state.filter);
    }));
  }
}

class DashboardScreen extends StatelessWidget {
  final Filter filter;

  const DashboardScreen(this.filter, {Key key}) : super(key: key);

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
                      FilterCard(filter: filter),
                      SizedBox(height: 7),
                      Container(
                          height: height - 75 - 51, child: ThreadPagedList(filter))
                    ],
                  ),
                );
              }),
            ),
          ],
        ));
  }
}



